using System;

namespace Exporter.file.K2toLMS
{
    public class ExportJob
    {
        public int JobId { get; set; }
        public string JobCode { get; set; } = "";
        public string JobName { get; set; } = "";
        public string StoredProcName { get; set; } = "";
        public string FileNameTemplate { get; set; } = "Export_{yyyyMMdd}.xlsx";
        public string SheetName { get; set; } = "Data";

        public string? OutputSubfolder { get; set; }
        public string? OutputRootKey { get; set; } // NEW: 'PRINT_FOLDER' (default) or 'LMS_Folder'
        public bool IsActive { get; set; }
        public int ExecuteOrder { get; set; } = 1;
        public int CommandTimeoutSec { get; set; } = 120;

        // 
        public string? SourceTableName { get; set; }
        public string? PrimaryKeyColumnName { get; set; }
    }
    public class ExportJobParam
    {
        public int JobParamId { get; set; }
        public int JobId { get; set; }
        public string ParamName { get; set; } = "";
        public string ParamType { get; set; } = "";
        public string? ParamValue { get; set; }
        public bool IsActive { get; set; } = true;
    }
}
