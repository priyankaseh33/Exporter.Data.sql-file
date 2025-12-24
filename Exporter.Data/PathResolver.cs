
using System;
using System.Collections.Generic;
using System.IO;
using Exporter.Data;

namespace Exporter.Util
{
    public static class PathResolver
    {
        // NEW: resolve root by key from settings, then build final path


        public static string ResolveOutputPath(
Dictionary<string, string> settings,
ExportJob job,
DateTime nowUtc)
        {
            var rootKey = string.IsNullOrWhiteSpace(job.OutputRootKey) ? "PRINT_FOLDER" : job.OutputRootKey;
            if (!settings.TryGetValue(rootKey, out var rootFolder) || string.IsNullOrWhiteSpace(rootFolder))
                rootFolder = settings.TryGetValue("PRINT_FOLDER", out var of) ? of : Path.Combine(Environment.CurrentDirectory, "Output");

            var sub = (job.OutputSubfolder ?? "").Trim();
            sub = ApplyTokens(sub, job, nowUtc);

            var file = ApplyTokens(job.FileNameTemplate, job, nowUtc);
            if (!file.EndsWith(".xlsx", StringComparison.OrdinalIgnoreCase)) file += ".xlsx";

            var folder = string.IsNullOrWhiteSpace(sub) ? rootFolder : Path.Combine(rootFolder, sub);
            Directory.CreateDirectory(folder);
            return Path.Combine(folder, file);
        }



        


        private static string ApplyTokens(string template, ExportJob job, DateTime n) =>
(template ?? "")
.Replace("{DDMMYYYY}", n.ToString("ddMMyyyy")) // 02092025 (new) [2]  
.Replace("{ddMMyyyy}", n.ToString("ddMMyyyy")) // 02092025 (new) [2]                                                          
.Replace("{yyyyMMdd_HHmmss}", n.ToString("yyyyMMdd_HHmmss"))
// date + hh:mm (if you ever need minutes only)
.Replace("{yyyyMMdd_HHmm}", n.ToString("yyyyMMdd_HHmm"))
// time-only helpers (optional but useful in subfolders)
.Replace("{HHmmss}", n.ToString("HHmmss"))
// date-only
.Replace("{yyyyMMdd}", n.ToString("yyyyMMdd"))
// ISO-like date if you need it elsewhere
.Replace("{yyyy-MM-dd}", n.ToString("yyyy-MM-dd"))
// always available
.Replace("{JobCode}", job.JobCode);
    }
}
