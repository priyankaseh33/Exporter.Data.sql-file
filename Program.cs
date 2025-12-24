using Exporter.file.K2toPrint;
using Exporter.Services;
using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Threading.Tasks;

class Program
{
    static async Task<int> Main(string[] args)
    {
        string connStr = Environment.GetEnvironmentVariable("EXPORTERCONNSTR")
            ?? ConfigurationManager.ConnectionStrings["Exporter"]?.ConnectionString
            ?? throw new InvalidOperationException("Connection string not configured.");

        var repo = new BatchRepository(connStr);
        var settings = await repo.GetSettingsAsync();

        // Always fetch the SharePoint folder once here
        if (!settings.TryGetValue("SHAREPOINT_UPLOAD_FOLDER", out var sharepointFolder))
            sharepointFolder = "Documents/UAT/Collection/Adler"; // fallback default

        var spUploader = new SharePointUploader(
            settings["SHAREPOINT_TENANT_ID"],
            settings["SHAREPOINT_CLIENT_ID"],
            settings["SHAREPOINT_SITE_URL"],
            settings["SHAREPOINT_CERT_PATH"],
            settings["SHAREPOINT_CERT_PASS"]
        );

        var outputRoot = settings.TryGetValue("PRINT_FOLDER", out var of)
            ? of
            : Path.Combine(Environment.CurrentDirectory, "Output");

        var logRoot = settings.TryGetValue("LOG_FOLDER", out var lf)
            ? lf
            : Path.Combine(outputRoot, "Logs");

        Directory.CreateDirectory(logRoot);
        var batchLog = Path.Combine(logRoot, $"Batch_{DateTime.UtcNow:yyyyMMdd_HHmmss}.log");
        var bangkokTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time"));
        void Log(string s) => File.AppendAllText(batchLog, $"[{bangkokTime:dd-MM-yyyy HH:mm:ss}] {s}{Environment.NewLine}");

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
                bool hasSourceTable = !string.IsNullOrWhiteSpace(job.SourceTableName);
                bool hasPrimaryKey = !string.IsNullOrWhiteSpace(job.PrimaryKeyColumnName);
                bool hasColumn = dt.Columns.Contains(job.PrimaryKeyColumnName);
                bool canUpdateStatus = hasSourceTable && hasPrimaryKey && hasColumn;

                if (canUpdateStatus)
                {
                    idTable.Columns.Add("ID", typeof(long));
                    foreach (DataRow row in dt.Rows)
                        idTable.Rows.Add(row[job.PrimaryKeyColumnName]);
                }

                //if (hasColumn) dt.Columns.Remove(job.PrimaryKeyColumnName);

                if (hasPrimaryKey)
                {
                    dt.Columns.Remove(job.PrimaryKeyColumnName);
                    Log($"Removed primary key column: {job.PrimaryKeyColumnName}");
                }



                var outPath = PathResolver.ResolveOutputPath(settings, job, DateTime.UtcNow);

                try
                {

                    outPath = Path.ChangeExtension(outPath, ".txt");
                    new Exporter.Services.TextWriter().Write(dt, outPath);
                    Log($"File generated successfully: {outPath}");


                    if (canUpdateStatus)
                    {
                        Log($"Updating status to 2220 for {idTable.Rows.Count} records.");
                        await repo.UpdateSourceDataStatusAsync(idTable, 2220, job.SourceTableName!, job.PrimaryKeyColumnName!);
                        Log("Status update to 2220 successful.");
                    }



                    if (!File.Exists(outPath))
                    {
                        throw new FileNotFoundException($"File was not created at expected path: {outPath}");
                    }

                    var fileInfo = new FileInfo(outPath);
                    Log($"File size: {fileInfo.Length} bytes");

                    // Upload to SharePoint
                    await spUploader.UploadFileAsync(outPath, sharepointFolder);
                    Log("File uploaded to SharePoint successfully.");
                   

                    // Move file to backup folder after upload
                    var backupFolder = await repo.GetBackupFolderAsync(); // Implement GetBackupFolderAsync to read from [Export_PrintSetting] table
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
                    

                    await repo.EndRunAsync(runId, "Success", dt.Rows.Count, outPath, null);
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