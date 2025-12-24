using System;
using System.Data;
using System.IO;
using System.Text;

namespace Exporter.Services
{
    public class TextWriter
    {
        public void WriteTextWithHeaderTrailer(DataTable dt, string filePath )
        {

            DateTime processingDate = DateTime.Now;
            var sb = new StringBuilder();

            // Header Record: H|YYYY-MM-DD
            sb.AppendLine($"H|{processingDate:yyyy-MM-dd}");

            // Write all detail rows: D|col1|col2|col3|...
            foreach (DataRow row in dt.Rows)
            {
                sb.Append("D");
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    sb.Append("|");
                    var value = row[i] == DBNull.Value ? "" : row[i].ToString();
                    sb.Append(value);
                }
                sb.AppendLine();
            }

            // Trailer Record: T|[total_record]
            sb.AppendLine($"T|{dt.Rows.Count}");

            File.WriteAllText(filePath, sb.ToString(), Encoding.UTF8);
        }
    
        public string Write(DataTable dt, string path)
        {
            var sb = new StringBuilder();

            // Write headers separated by '|'
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                sb.Append(dt.Columns[i].ColumnName);
                if (i < dt.Columns.Count - 1)
                    sb.Append("|");
            }
            sb.AppendLine();

            // Write data rows separated by '|'
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    var value = row[i] == DBNull.Value ? "" : row[i].ToString();
                    sb.Append(value);
                    if (i < dt.Columns.Count - 1)
                        sb.Append("|");
                }
                sb.AppendLine();
            }

            File.WriteAllText(path, sb.ToString());
            return path;
        }

    }

}
