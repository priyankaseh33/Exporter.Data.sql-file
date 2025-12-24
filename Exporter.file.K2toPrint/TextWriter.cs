using System;
using System.Data;
using System.IO;
using System.Text;

namespace Exporter.Services
{

    public class TextWriter
    {
        public string Write(DataTable dt, string path)
        {
            var sb = new StringBuilder();

            /*
            // Write headers separated by ','
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                sb.Append(dt.Columns[i].ColumnName);
                if (i < dt.Columns.Count - 1)
                    sb.Append(",");
            }
            sb.AppendLine();
            */

            // Write data rows separated by ','
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    var value = row[i] == DBNull.Value ? "" : row[i].ToString();
                    value = value.Replace("\"", "\"\""); // Escape any double quotes inside value

                    sb.Append("\"");
                    sb.Append(value);
                    sb.Append("\"");

                    if (i < dt.Columns.Count - 1)
                        sb.Append(",");
                }
                sb.AppendLine();
            }
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            
            //ANSI ENCODING
            //var encoding = Encoding.GetEncoding(1252); // or "windows-1252"
            var encoding = Encoding.GetEncoding(874); // or "windows-1252"
            File.WriteAllText(path, sb.ToString(), encoding);

            //utf-8
            //File.WriteAllText(path, sb.ToString());

            return path;
        }
    }

 }

