using Exporter.Data;
using Exporter.Services;
using Exporter.Util;
using System.Configuration;
using System.Data;

class Program
{
    static async Task<int> Main(string[] args)
    {
        string connStr =
            Environment.GetEnvironmentVariable("EXPORTERCONNSTR")
            ?? ConfigurationManager.ConnectionStrings["Exporter"]?.ConnectionString
            ?? throw new InvalidOperationException("Connection string not configured. Provide EXPORTERCONNSTR or set ConnectionStrings:Exporter.");

        var repo = new BatchRepository(connStr);
        var settings = await repo.GetSettingsAsync();

        var outputRoot = settings.TryGetValue("PRINTFOLDER", out var of)
            ? of
            : Path.Combine(Environment.CurrentDirectory, "Output");

        var logRoot = settings.TryGetValue("LogFolder", out var lf)
            ? lf
            : Path.Combine(outputRoot, "Logs");

        Directory.CreateDirectory(logRoot);

        var batchLog = Path.Combine(logRoot, $"Batch_{DateTime.UtcNow:yyyyMMdd_HHmmss}.log");
        //void Log(string s) => File.AppendAllText(batchLog, $"[{DateTime.UtcNow:O}] {s}{Environment.NewLine}");
        //void Log(string s) => File.AppendAllText(batchLog, $"[{DateTime.UtcNow:yyyy-MM-dd HH:mm:ss}] {s}{Environment.NewLine}");
        var bangkokTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time"));
        void Log(string s) => File.AppendAllText(
            batchLog,
            $"[{bangkokTime:dd-MM-yyyy HH:mm:ss}] {s}{Environment.NewLine}"
        );


        Log("Batch start");

        var jobs = await repo.GetActiveJobsAsync();
        if (jobs.Count == 0)
        {
            Log("No active jobs.");
            return 0;
        }

        string fileType = ConfigurationManager.AppSettings["FileType"]?.ToLower() ?? "excel";
        int failures = 0;

        foreach (var job in jobs)
        {
            long runId = 0;
            try
            {
                runId = await repo.StartRunAsync(job.JobId);
                Log($"START {job.JobCode} (SP={job.StoredProcName})");

                var prm = await repo.GetJobParamsAsync(job.JobId);
                var sqlParams = BatchRepository.BindJobParams(prm);
                var dt = await repo.ExecuteProcAsync(job.StoredProcName, sqlParams, job.CommandTimeoutSec);

                if (dt.Rows.Count == 0)
                {
                    await repo.EndRunAsync(runId, "INFO", 0, null, $"{job.JobCode}: 0 Rows, No File Generated");
                    Log($"INFO {job.JobCode}: rows 0 - no output generated");
                    continue;
                }

                // Prepare IDs for status updates
                DataTable idTable = new DataTable();
                //bool canUpdateStatus = !string.IsNullOrWhiteSpace(job.SourceTableName) &&
                //                       !string.IsNullOrWhiteSpace(job.PrimaryKeyColumnName) &&
                //                       dt.Columns.Contains(job.PrimaryKeyColumnName);


                bool hasSourceTable = !string.IsNullOrWhiteSpace(job.SourceTableName);
                bool hasPrimaryKey = !string.IsNullOrWhiteSpace(job.PrimaryKeyColumnName);
                bool hasColumn = dt.Columns.Contains(job.PrimaryKeyColumnName);

                //if (!hasSourceTable) Console.WriteLine("SourceTableName is empty.");
                //if (!hasPrimaryKey) Console.WriteLine("PrimaryKeyColumnName is empty.");
                //if (!hasColumn) Console.WriteLine($"Column '{job.PrimaryKeyColumnName}' not found in DataTable.");

                //bool canUpdateStatus = hasSourceTable && hasPrimaryKey;
                 bool canUpdateStatus = hasSourceTable && hasPrimaryKey && hasColumn;


                if (canUpdateStatus)
                {
                    idTable.Columns.Add("ID", typeof(long));
                    foreach (DataRow row in dt.Rows)
                        idTable.Rows.Add(row[job.PrimaryKeyColumnName]);
                }
                if (hasPrimaryKey)  dt.Columns.Remove(job.PrimaryKeyColumnName);

                var outPath = PathResolver.ResolveOutputPath(settings, job, DateTime.UtcNow);

                try
                {
                    // --- File generation based on app.config setting ---
                    switch (fileType)
                    {
                        case "csv":
                            outPath = Path.ChangeExtension(outPath, ".csv");
                            new CsvWriter().Write(dt, outPath);
                            break;

                        case "txt":
                            outPath = Path.ChangeExtension(outPath, ".txt");
                            new Exporter.Services.TextWriter().Write(dt, outPath);
                            break;

                        default:
                            outPath = Path.ChangeExtension(outPath, ".xlsx");
                            new ExcelWriter().Write(dt, job.SheetName, outPath);
                            break;
                    }

                    Log($"File generated successfully: {outPath}");


                    // Update DB to status = 2210 after file generation
                    if (canUpdateStatus)
                    {
                        Log($"Updating status to 2210 for {idTable.Rows.Count} records.");
                        await repo.UpdateSourceDataStatusAsync(idTable, 2210, job.SourceTableName!, job.PrimaryKeyColumnName!);
                        Log("Status update to 2210 successful.");
                    }

                    await repo.EndRunAsync(runId, "Success", dt.Rows.Count, outPath, null);

                    if (settings.TryGetValue("is_sftp_enabled", out var enabled) && enabled.Equals("true", StringComparison.OrdinalIgnoreCase))
                    {
                        try
                        {
                            var effectiveSettings = new Dictionary<string, string>(settings, StringComparer.OrdinalIgnoreCase);
                            if (settings.TryGetValue($"SFTP_REMOTE_DIR_{job.JobCode}", out var jobDir) && !string.IsNullOrWhiteSpace(jobDir))
                                effectiveSettings["SFTP_REMOTE_DIR"] = jobDir;

                            var uploader = SftpUploader.FromSettings(effectiveSettings);
                            uploader.Upload(outPath);

                            // Update DB to status = 2220 after upload
                            if (canUpdateStatus)
                            {
                                Log($"Updating status to 2220 for {idTable.Rows.Count} records.");
                                await repo.UpdateSourceDataStatusAsync(idTable, 2220, job.SourceTableName!, job.PrimaryKeyColumnName!);
                                Log("Status update to 2220 successful.");
                            }


                            Log($"SFTP SUCCESS {job.JobCode}: rows={dt.Rows.Count} file={outPath}");
                        }
                    catch (Exception sftpEx)
                        {
                            string msg = $"SFTP upload failed: {sftpEx.Message}";
                            await repo.LogErrorAsync(runId, "SFTP", sftpEx.ToString());
                            await repo.EndRunAsync(runId, "SFTP Failed", dt.Rows.Count, outPath, msg);
                            Log($"FAILED {job.JobCode} {msg}");
                            failures++;
                        }
                    }
                    else
                    {
                        Log("SFTP skipped, is_sftp_enabled=false or missing.");
                    }


                    
                }
                catch (Exception fileEx)
                {
                    await repo.LogErrorAsync(runId, "FileWrite", fileEx.ToString());
                    await repo.EndRunAsync(runId, "Failed", dt.Rows.Count, outPath, $"{fileType.ToUpper()} write failed");
                    Log($"FAILED {job.JobCode} {fileType} write: {fileEx.Message}");
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
                    await repo.EndRunAsync(runId, "Failed", null, null, ex.Message);
                }
                Log($"FAILED {job.JobCode}: {ex.Message}");
            }
        }

        Log("Batch end");
        return failures == 0 ? 0 : 1;
    }
}
