using System;
using System.Data;
using System.IO;

namespace Exporter.Services
{
    public class CsvWriter
    {
        public string Write(DataTable dt, string path)
        {
            using var writer = new StreamWriter(path);

            // Write header line
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                writer.Write(dt.Columns[i].ColumnName);
                if (i < dt.Columns.Count - 1)
                    writer.Write(",");
            }
            writer.WriteLine();

            // Write data rows
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    var value = row[i] == DBNull.Value ? "" : row[i].ToString()?.Replace(",", " ");
                    writer.Write(value);
                    if (i < dt.Columns.Count - 1)
                        writer.Write(",");
                }
                writer.WriteLine();
            }

            return path;
        }
    }
}
