//using DocumentFormat.OpenXml.Drawing.Charts;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace Exporter.file.K2toLMS
{
    internal class BatchRepository
    {

        private readonly string _conn;
        public BatchRepository(string conn) => _conn = conn;

        public sealed class ScheduledJob
        {
            public int ScheduleId { get; set; }
            public ExportJob Job { get; set; } = null!;
        }

        public async Task<List<ScheduledJob>> GetJobsToRunAsync(DateTime bangkokNow, int windowMinutes)
        {
            var list = new List<ScheduledJob>();

            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();

            await using var cmd = new SqlCommand(
                "[JAI_DAILY_EXPORT].[dbo].[uspExportLMS_GetJobsToRun]", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CurrentLocalTime", bangkokNow);
            cmd.Parameters.AddWithValue("@WindowMinutes", windowMinutes);

            await using var rd = await cmd.ExecuteReaderAsync();




            //
            while (await rd.ReadAsync())
            {
                var job = new ExportJob
                {
                    JobId = rd.GetInt32(rd.GetOrdinal("JobId")),
                    JobCode = rd.IsDBNull(rd.GetOrdinal("JobCode")) ? "" : rd.GetString(rd.GetOrdinal("JobCode")),
                    JobName = rd.IsDBNull(rd.GetOrdinal("JobName")) ? "" : rd.GetString(rd.GetOrdinal("JobName")),
                    StoredProcName = rd.IsDBNull(rd.GetOrdinal("StoredProcName")) ? "" : rd.GetString(rd.GetOrdinal("StoredProcName")),
                    FileNameTemplate = rd.IsDBNull(rd.GetOrdinal("FileNameTemplate")) ? "" : rd.GetString(rd.GetOrdinal("FileNameTemplate")),
                    SheetName = rd.IsDBNull(rd.GetOrdinal("SheetName")) ? "" : rd.GetString(rd.GetOrdinal("SheetName")),
                    IsActive = rd.GetBoolean(rd.GetOrdinal("IsActive")),
                    ExecuteOrder = rd.GetInt32(rd.GetOrdinal("ExecuteOrder")),
                    OutputSubfolder = rd.IsDBNull(rd.GetOrdinal("OutputSubfolder")) ? null : rd.GetString(rd.GetOrdinal("OutputSubfolder")),
                    CommandTimeoutSec = rd.GetInt32(rd.GetOrdinal("CommandTimeoutSec")),
                    SourceTableName = rd.IsDBNull(rd.GetOrdinal("SourceTableName")) ? null : rd.GetString(rd.GetOrdinal("SourceTableName")),
                    PrimaryKeyColumnName = rd.IsDBNull(rd.GetOrdinal("PrimaryKeyColumnName")) ? null : rd.GetString(rd.GetOrdinal("PrimaryKeyColumnName")),
                    OutputRootKey = rd.IsDBNull(rd.GetOrdinal("OutputRootKey")) ? null : rd.GetString(rd.GetOrdinal("OutputRootKey"))
                };

                var schedId = rd.GetInt32(rd.GetOrdinal("ScheduleId"));

                list.Add(new ScheduledJob
                {
                    ScheduleId = schedId,
                    Job = job
                });
            }

            //



            return list;
        }

        public async Task MarkScheduleRunAsync(int scheduleId, DateTime runDate)
        {
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();

            await using var cmd = new SqlCommand(
                "[JAI_DAILY_EXPORT].[dbo].[uspExportLMS_MarkScheduleRun]", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ScheduleId", scheduleId);
            cmd.Parameters.AddWithValue("@RunDate", runDate.Date);

            await cmd.ExecuteNonQueryAsync();
        }
    





        public async Task<string?> GetBackupFolderAsync()
        {
            const string sql = @"
                SELECT SettingValue
                FROM [JAI_DAILY_EXPORT].[dbo].[Export_LMSSetting]
                WHERE SettingKey = 'BACKUP_FOLDER'
            ";

            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();

            await using var cmd = new SqlCommand(sql, cn);
            // cmd.Parameters.AddWithValue("@JobId", jobId);

            var result = await cmd.ExecuteScalarAsync();
            if (result != null && result != DBNull.Value)
            {
                return result.ToString();
            }
            return null;
        }


        public async Task<Dictionary<string, string>> GetSettingsAsync()
        {
            var dict = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand("SELECT SettingKey, SettingValue FROM dbo.Export_LMSSetting", cn);
            await using var rd = await cmd.ExecuteReaderAsync();
            while (await rd.ReadAsync())
                dict[rd.GetString(0)] = rd.GetString(1);
            return dict;
        }

        public async Task<List<ExportJob>> GetActiveJobsAsync()
        {
            /*
            const string sql = @"SELECT JobId, JobCode, JobName, StoredProcName, FileNameTemplate, SheetName, IsActive, ExecuteOrder,
ISNULL(OutputSubfolder, N'') AS OutputSubfolder,
120 AS CommandTimeoutSec
FROM dbo.ExportJob
WHERE IsActive = 1
ORDER BY ExecuteOrder, JobId;";
            */


            const string sql = @"SELECT JobId, JobCode, JobName, StoredProcName, FileNameTemplate, SheetName, IsActive, ExecuteOrder,
ISNULL(OutputSubfolder, N'') AS OutputSubfolder,
120 AS CommandTimeoutSec,
SourceTableName,PrimaryKeyColumnName,
ISNULL(OutputRootKey, N'PRINT_FOLDER') AS OutputRootKey
FROM dbo.Export_LMSJob
WHERE IsActive = 1
ORDER BY ExecuteOrder, JobId;";

            var list = new List<ExportJob>();
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand(sql, cn);
            await using var rd = await cmd.ExecuteReaderAsync();
            //while (await rd.ReadAsync())
            //{
            //    list.Add(new ExportJob
            //    {
            //        JobId = rd.GetInt32(0),
            //        JobCode = rd.GetString(1),
            //        JobName = rd.GetString(2),
            //        StoredProcName = rd.GetString(3),
            //        FileNameTemplate = rd.GetString(4),
            //        SheetName = rd.GetString(5),
            //        IsActive = rd.GetBoolean(6),
            //        ExecuteOrder = rd.GetInt32(7),
            //        OutputSubfolder = rd.GetString(8),
            //        CommandTimeoutSec = rd.GetInt32(9),
            //        SourceTableName = rd.GetString(10),
            //        PrimaryKeyColumnName = rd.GetString(11),
            //        OutputRootKey = rd.GetString(12)
            //    });
            //}

            while (await rd.ReadAsync())
            {
                list.Add(new ExportJob
                {
                    JobId = rd.GetInt32(0),
                    JobCode = rd.IsDBNull(1) ? "" : rd.GetString(1),
                    JobName = rd.IsDBNull(2) ? "" : rd.GetString(2),
                    StoredProcName = rd.IsDBNull(3) ? "" : rd.GetString(3),
                    FileNameTemplate = rd.IsDBNull(4) ? "" : rd.GetString(4),
                    SheetName = rd.IsDBNull(5) ? "" : rd.GetString(5),
                    IsActive = rd.GetBoolean(6),
                    ExecuteOrder = rd.GetInt32(7),
                    OutputSubfolder = rd.IsDBNull(8) ? "" : rd.GetString(8),
                    CommandTimeoutSec = rd.GetInt32(9),
                    SourceTableName = rd.IsDBNull(10) ? "" : rd.GetString(10),
                    PrimaryKeyColumnName = rd.IsDBNull(11) ? "" : rd.GetString(11),
                    OutputRootKey = rd.IsDBNull(12) ? "" : rd.GetString(12)
                });
            }


            return list;
        }

        public async Task<List<ExportJobParam>> GetJobParamsAsync(int jobId)
        {
            const string sql = @"SELECT JobParamId, JobId, ParamName, ParamType, ParamValue, IsActive
FROM dbo.Export_LMSJobParam
WHERE JobId = @JobId AND IsActive = 1
ORDER BY JobParamId;";
            var list = new List<ExportJobParam>();
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@JobId", jobId);
            await using var rd = await cmd.ExecuteReaderAsync();
            while (await rd.ReadAsync())
            {
                list.Add(new ExportJobParam
                {
                    JobParamId = rd.GetInt32(0),
                    JobId = rd.GetInt32(1),
                    ParamName = rd.GetString(2),
                    ParamType = rd.GetString(3),
                    ParamValue = rd.IsDBNull(4) ? null : rd.GetString(4),
                    IsActive = rd.GetBoolean(5)
                });
            }
            return list;
        }

        public async Task<long> StartRunAsync(int jobId)
        {
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand("dbo.usp_ExportJobRun_Start", cn)
            { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.AddWithValue("@JobId", jobId);
            var outParam = new SqlParameter("@RunId", SqlDbType.BigInt)
            { Direction = ParameterDirection.Output };
            cmd.Parameters.Add(outParam);
            await cmd.ExecuteNonQueryAsync();
            return (long)outParam.Value;
        }

        public async Task EndRunAsync(long runId, string status, int? rows, string? file, string? message)
        {
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand("dbo.usp_ExportJobRun_End", cn)
            { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.AddWithValue("@RunId", runId);
            cmd.Parameters.AddWithValue("@Status", status);
            cmd.Parameters.AddWithValue("@Rows", (object?)rows ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@OutputFilePath", (object?)file ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Message", (object?)message ?? DBNull.Value);
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task LogErrorAsync(long runId, string stage, string error)
        {
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand("dbo.usp_ExportJobRun_Error", cn)
            { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.AddWithValue("@RunId", runId);
            cmd.Parameters.AddWithValue("@Stage", stage);
            cmd.Parameters.AddWithValue("@ErrorMessage", error);
            await cmd.ExecuteNonQueryAsync();
        }

        //public async Task<DataTable> ExecuteProcAsync(string proc, IEnumerable<SqlParameter> parameters, int timeoutSec)
        public async Task<System.Data.DataTable> backup_ExecuteProcAsync(string proc, IEnumerable<SqlParameter> parameters, int timeoutSec)
        {
            //var dt = new DataTable();
            var dt = new System.Data.DataTable();
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand(proc, cn)
            { CommandType = CommandType.StoredProcedure, CommandTimeout = timeoutSec };
            foreach (var p in parameters) cmd.Parameters.Add(p);
            await using var rdr = await cmd.ExecuteReaderAsync();
            dt.Load(rdr);
            return dt;
        }

        public async Task<DataTable> ExecuteProcAsync(string proc, IEnumerable<SqlParameter> parameters, int timeoutSec)
        {
            var dt = new System.Data.DataTable();
            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand(proc, cn) { CommandType = CommandType.StoredProcedure, CommandTimeout = timeoutSec };
            foreach (var p in parameters) cmd.Parameters.Add(p);
            await using var rdr = await cmd.ExecuteReaderAsync();

            // Load with null-safe handling for binary columns
            dt.Load(rdr);  // This is fine for most types
            return dt;
        }


        // Parameter binding with tokens
        public static List<SqlParameter> BindJobParams(IEnumerable<ExportJobParam> ps)
        {
            var list = new List<SqlParameter>();
            foreach (var p in ps)
            {
                var sp = new SqlParameter(p.ParamName, MapDb(p.ParamType))
                { Value = ResolveToken(p.ParamValue, p.ParamType) };
                list.Add(sp);
            }
            return list;
        }

        private static SqlDbType MapDb(string t) => t.Trim().ToLowerInvariant() switch
        {
            "int" => SqlDbType.Int,
            "bigint" => SqlDbType.BigInt,
            "bit" => SqlDbType.Bit,
            "date" => SqlDbType.Date,
            "datetime" => SqlDbType.DateTime,
            "datetime2" => SqlDbType.DateTime2,
            "decimal" => SqlDbType.Decimal,
            "float" => SqlDbType.Float,
            "money" => SqlDbType.Money,
            "nvarchar" or "nvarchar(max)" => SqlDbType.NVarChar,
            "varchar" or "varchar(max)" => SqlDbType.VarChar,
            "uniqueidentifier" => SqlDbType.UniqueIdentifier,
            _ => SqlDbType.NVarChar
        };

        private static object ResolveToken(string? v, string type)
        {
            if (string.IsNullOrWhiteSpace(v)) return DBNull.Value;
            var s = v.Trim();
            if (s.Equals("{TodayUtc}", StringComparison.OrdinalIgnoreCase)) return DateTime.UtcNow.Date;
            if (s.Equals("{YesterdayUtc}", StringComparison.OrdinalIgnoreCase)) return DateTime.UtcNow.Date.AddDays(-1);
            try
            {
                return type.Trim().ToLowerInvariant() switch
                {
                    "int" => int.Parse(s),
                    "bigint" => long.Parse(s),
                    "bit" => (s == "1" || s.Equals("true", StringComparison.OrdinalIgnoreCase)),
                    "date" or "datetime" or "datetime2" => DateTime.Parse(s),
                    "decimal" or "money" => decimal.Parse(s),
                    "float" => double.Parse(s),
                    "uniqueidentifier" => Guid.Parse(s),
                    _ => s
                };
            }
            catch { return s; }
        }

        public async Task ExecuteUpdateProcedureAsync(long runId, string procedureName, int status)
        {
            if (string.IsNullOrWhiteSpace(procedureName))
            {
                return; // Silently ignore if no procedure is configured
            }

            await using var cn = new SqlConnection(_conn);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand(procedureName, cn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@RunId", runId);
            cmd.Parameters.AddWithValue("@Status", status);

            await cmd.ExecuteNonQueryAsync();
        }

        // ++ Add this new method to call the update SP
        public async Task UpdateSourceDataStatusAsync(DataTable ids, int status, string tableName, string pkColumnName)
        {
            

            string _conn_repo =
            Environment.GetEnvironmentVariable("repossess_jaiCONNSTR")
            ?? ConfigurationManager.ConnectionStrings["repossess_jai"]?.ConnectionString
            ?? throw new InvalidOperationException("Connection string not configured. Provide repossess_jai or set ConnectionStrings:repossess_jai.");



            if (ids.Rows.Count == 0 || string.IsNullOrWhiteSpace(tableName) || string.IsNullOrWhiteSpace(pkColumnName))
            {
                return; // Nothing to do
            }

            await using var cn = new SqlConnection(_conn_repo);
            await cn.OpenAsync();
            await using var cmd = new SqlCommand("dbo.usp_UpdateSourceDataStatus", cn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@TableName", tableName);
            cmd.Parameters.AddWithValue("@PkColumnName", pkColumnName);
            cmd.Parameters.AddWithValue("@Status", status);

            // This is where we pass the DataTable as a structured parameter
            var idParam = cmd.Parameters.AddWithValue("@Ids", ids);
            idParam.SqlDbType = SqlDbType.Structured;
            idParam.TypeName = "dbo.IdList"; // Must match the UDTT name

            await cmd.ExecuteNonQueryAsync();
        }



    }


}
