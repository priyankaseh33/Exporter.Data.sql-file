using Exporter.file.K2toLMS;
using Exporter.Services;
using Microsoft.IdentityModel.Protocols;
using System.Configuration;
using System.Data;

class Program
{
    static async Task<int> Main(string[] args)
    {
        string connStr =
            Environment.GetEnvironmentVariable("EXPORTERCONNSTR")
            ?? ConfigurationManager.ConnectionStrings["Exporter"]?.ConnectionString
            ?? throw new InvalidOperationException("[Connection string not configured. Provide EXPORTERCONNSTR or set ConnectionStrings:Exporter.]");

        var repo = new BatchRepository(connStr);
        var settings = await repo.GetSettingsAsync();

        var outputRoot = settings.TryGetValue("LMS_Folder", out var of)
            ? of
            : Path.Combine(Environment.CurrentDirectory, "Output");

        var logRoot = settings.TryGetValue("LOG_FOLDER", out var lf)
            ? lf
            : Path.Combine(outputRoot, "Logs");

        Directory.CreateDirectory(logRoot);

        var fileNameGenerator = new FileNameGeneratorV2(outputRoot);

        var batchLog = Path.Combine(logRoot, $"Batch_{DateTime.UtcNow:yyyyMMdd_HHmmss}.log");

        // Get Bangkok time ONCE for this run
        var bangkokTz = TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time");
        var bangkokNow = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, bangkokTz);

        void Log(string s) => File.AppendAllText(
            batchLog,
            $"[{bangkokNow:dd-MM-yyyy HH:mm:ss}] {s}{Environment.NewLine}"
        );

        Log("[Batch start]");

        // use schedule instead of GetActiveJobsAsync
        int windowMinutes = 5; // same or less than Task Scheduler frequency
        var scheduledJobs = await repo.GetJobsToRunAsync(bangkokNow, windowMinutes);
        if (scheduledJobs.Count == 0)
        {
            Log("[No jobs scheduled for this time window.]");
            return 0;
        }

        string fileType = ConfigurationManager.AppSettings["FileType"]?.ToLower() ?? "excel";
        int failures = 0;

        foreach (var scheduled in scheduledJobs)
        {
            var job = scheduled.Job;
            int scheduleId = scheduled.ScheduleId;

            long runId = 0;
            try
            {
                runId = await repo.StartRunAsync(job.JobId);
                Log($"[START] {job.JobCode} (SP={job.StoredProcName})");

                var prm = await repo.GetJobParamsAsync(job.JobId);
                var sqlParams = BatchRepository.BindJobParams(prm);
                var dt = await repo.ExecuteProcAsync(job.StoredProcName, sqlParams, job.CommandTimeoutSec);

                if (dt.Rows.Count == 0)
                {
                    await repo.EndRunAsync(runId, "[INFO]", 0, null, $"{job.JobCode}: 0 [Rows], [No File Generated]");
                    Log($"[INFO] {job.JobCode}: [rows] 0 - [no output generated]");
                    await repo.MarkScheduleRunAsync(scheduleId, bangkokNow.Date);
                    continue;
                }

                DataTable idTable = new DataTable();
                bool hasSourceTable = !string.IsNullOrWhiteSpace(job.SourceTableName);
                bool hasPrimaryKey = !string.IsNullOrWhiteSpace(job.PrimaryKeyColumnName);
                bool hasColumn = !string.IsNullOrWhiteSpace(job.PrimaryKeyColumnName);
                bool haveupdatefields = hasSourceTable && hasPrimaryKey && hasColumn;
                bool checkupdatestaus = false;

                if (settings.TryGetValue("is_Update_status", out var isUpdateEnabled)
                    && isUpdateEnabled.Equals("true", StringComparison.OrdinalIgnoreCase))
                {
                    checkupdatestaus = true;

                    if (haveupdatefields)
                    {
                        idTable.Columns.Add("[ID]", typeof(long));
                        foreach (DataRow row in dt.Rows)
                            idTable.Rows.Add(row[job.PrimaryKeyColumnName]);
                    }
                    if (haveupdatefields && hasPrimaryKey)
                        dt.Columns.Remove(job.PrimaryKeyColumnName);
                }

                // SE Asia local time for filename
                var today = bangkokNow;
                string fileName = fileNameGenerator.GenerateFileName(job.FileNameTemplate, today);
                var outPath = Path.Combine(outputRoot, fileName);

                try
                {
                    outPath = Path.ChangeExtension(outPath, ".txt");
                    new Exporter.Services.TextWriter().WriteTextWithHeaderTrailer(dt, outPath);
                    Log($"[File generated successfully]: {outPath}");

                    await repo.EndRunAsync(runId, "[Success]", dt.Rows.Count, outPath, null);

                    if (settings.TryGetValue("is_sftp_enabled", out var enabled)
                        && enabled.Equals("true", StringComparison.OrdinalIgnoreCase))
                    {
                        try
                        {
                            var effectiveSettings = new Dictionary<string, string>(settings, StringComparer.OrdinalIgnoreCase);

                            // *** FIX: guard against null/empty JobCode before using it as part of the key ***
                            if (!string.IsNullOrWhiteSpace(job.JobCode))
                            {
                                var jobSpecificKey = $"SFTP_REMOTE_DIR_{job.JobCode}";
                                if (settings.TryGetValue(jobSpecificKey, out var jobDir) &&
                                    !string.IsNullOrWhiteSpace(jobDir))
                                {
                                    effectiveSettings["SFTP_REMOTE_DIR"] = jobDir;
                                }
                            }

                            var uploader = SftpUploader.FromSettings(effectiveSettings);
                            uploader.Upload(outPath);

                            if (haveupdatefields)
                            {
                                Log($"[Updating status to 2220 for] {idTable.Rows.Count} [records.]");
                                await repo.UpdateSourceDataStatusAsync(idTable, 2220, job.SourceTableName!, job.PrimaryKeyColumnName!);
                                Log("[Status update to 2220 successful.]");
                            }

                            Log($"[SFTP SUCCESS] {job.JobCode}: [rows=]{dt.Rows.Count} [file=]{outPath}");
                        }
                        catch (Exception sftpEx)
                        {
                            string msg = $"[SFTP upload failed]: {sftpEx.Message}";
                            await repo.LogErrorAsync(runId, "SFTP", sftpEx.ToString());
                            await repo.EndRunAsync(runId, "[SFTP Failed]", dt.Rows.Count, outPath, msg);
                            Log($"[FAILED] {job.JobCode} {msg}");
                            failures++;
                        }
                    }
                    else
                    {
                        Log("[SFTP skipped, is_sftp_enabled=false or missing.]");
                    }

                    // Move file to backup folder
                    var backupFolder = await repo.GetBackupFolderAsync();
                    if (string.IsNullOrEmpty(backupFolder))
                    {
                        Log("Backup folder path not configured. Skipping file move.");
                    }
                    else
                    {
                        if (!Directory.Exists(backupFolder))
                            Directory.CreateDirectory(backupFolder);

                        var backupPath = Path.Combine(backupFolder, Path.GetFileName(outPath));
                        File.Move(outPath, backupPath);
                        Log($"File moved to backup folder: {backupPath}");
                    }

                    await repo.MarkScheduleRunAsync(scheduleId, bangkokNow.Date);
                }
                catch (Exception fileEx)
                {
                    await repo.LogErrorAsync(runId, "FileWrite", fileEx.ToString());
                    await repo.EndRunAsync(runId, "[Failed]", dt.Rows.Count, outPath, $"{fileType.ToUpper()} [write failed]");
                    Log($"[FAILED] {job.JobCode} {fileType} [write]: {fileEx.Message}");
                    failures++;
                    continue;
                }
            }
            catch (Exception ex)
            {
                failures++;
                if (runId != 0)
                {
                    await repo.LogErrorAsync(runId, "App", ex.ToString());
                    await repo.EndRunAsync(runId, "[Failed]", null, null, ex.Message);
                }
                Log($"[FAILED] {job.JobCode}: {ex.Message}");
            }
        }

        Log("[Batch end]");
        return failures == 0 ? 0 : 1;
    }
}
