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




            /* -- space between words
            // Write headers
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                sb.Append(dt.Columns[i].ColumnName.PadRight(20));
            }
            sb.AppendLine();

            // Write data
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    var value = row[i] == DBNull.Value ? "" : row[i].ToString();
                    sb.Append(value.PadRight(20));
                }
                sb.AppendLine();
            }*/



            File.WriteAllText(path, sb.ToString());
            return path;
        }
    }

 }
