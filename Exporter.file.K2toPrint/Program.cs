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

        // Get SharePoint configuration
        if (!settings.TryGetValue("SHAREPOINT_UPLOAD_FOLDER", out var sharepointFolder))
            sharepointFolder = "Documents/UAT/Collection/Adler";

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
        var bangkokTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow,
            TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time"));

        void Log(string s) => File.AppendAllText(batchLog,
            $"[{bangkokTime:dd-MM-yyyy HH:mm:ss}] {s}{Environment.NewLine}");

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

                // Execute stored procedure
                var prm = await repo.GetJobParamsAsync(job.JobId);
                var sqlParams = BatchRepository.BindJobParams(prm);
                var dt = await repo.ExecuteProcAsync(job.StoredProcName, sqlParams, job.CommandTimeoutSec);

                if (dt.Rows.Count == 0)
                {
                    await repo.EndRunAsync(runId, "INFO", 0, null,
                        $"{job.JobCode}: 0 Rows, No File Generated");
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

                // Remove primary key column before writing to file
                if (hasPrimaryKey && dt.Columns.Count > 0)
                {
                    DataColumn pkColumn = null;
                    foreach (DataColumn col in dt.Columns)
                    {
                        if (col.ColumnName.Equals(job.PrimaryKeyColumnName,
                            StringComparison.OrdinalIgnoreCase))
                        {
                            pkColumn = col;
                            break;
                        }
                    }

                    if (pkColumn != null)
                    {
                        dt.Columns.Remove(pkColumn);
                        Log($"Removed primary key column '{pkColumn.ColumnName}'");
                    }
                    else
                    {
                        Log($"WARNING: Could not find primary key column '{job.PrimaryKeyColumnName}'");
                    }
                }

                var outPath = PathResolver.ResolveOutputPath(settings, job, DateTime.UtcNow);

                try
                {
                    // Generate text file
                    outPath = Path.ChangeExtension(outPath, ".txt");
                    new Exporter.Services.TextWriter().Write(dt, outPath);
                    Log($"File generated: {outPath} ({new FileInfo(outPath).Length} bytes)");

                    // Update source data status
                    if (canUpdateStatus)
                    {
                        await repo.UpdateSourceDataStatusAsync(idTable, 2220,
                            job.SourceTableName!, job.PrimaryKeyColumnName!);
                        Log($"Updated status to 2220 for {idTable.Rows.Count} records");
                    }

                    // Upload to SharePoint
                    await spUploader.UploadFileAsync(outPath, sharepointFolder);
                    Log("File uploaded to SharePoint");

                    // Move to backup folder
                    var backupFolder = await repo.GetBackupFolderAsync();
                    if (string.IsNullOrEmpty(backupFolder))
                    {
                        Log("Backup folder not configured. Skipping file move.");
                    }
                    else
                    {
                        Directory.CreateDirectory(backupFolder);
                        var backupPath = GetUniqueBackupPath(backupFolder, outPath);
                        File.Move(outPath, backupPath);
                        Log($"File moved to backup: {backupPath}");
                    }

                    await repo.EndRunAsync(runId, "Success", dt.Rows.Count, outPath, null);
                }
                catch (Exception fileEx)
                {
                    await repo.LogErrorAsync(runId, "FileWrite", fileEx.ToString());
                    await repo.EndRunAsync(runId, "Failed", dt.Rows.Count, outPath,
                        $"{fileType.ToUpper()} write failed");
                    Log($"FAILED {job.JobCode} {fileType} write: {fileEx.Message}");
                    failures++;
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

    /// <summary>
    /// Gets a unique backup path by appending _1, _2, etc. if file already exists
    /// </summary>
    private static string GetUniqueBackupPath(string backupFolder, string originalPath)
    {
        var fileName = Path.GetFileName(originalPath);
        var backupPath = Path.Combine(backupFolder, fileName);

        if (!File.Exists(backupPath))
            return backupPath;

        var directory = Path.GetDirectoryName(backupPath);
        var fileNameWithoutExt = Path.GetFileNameWithoutExtension(backupPath);
        var extension = Path.GetExtension(backupPath);
        int counter = 1;

        do
        {
            backupPath = Path.Combine(directory, $"{fileNameWithoutExt}_{counter}{extension}");
            counter++;
        }
        while (File.Exists(backupPath));

        return backupPath;
    }
}
