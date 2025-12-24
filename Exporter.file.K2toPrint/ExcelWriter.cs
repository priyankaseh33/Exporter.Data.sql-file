using System.Data;
using ClosedXML.Excel;

namespace Exporter.Services
{
    public class ExcelWriter
    {
        public string Write(DataTable dt, string sheetName, string path)
        {
            using var wb = new XLWorkbook();
            var ws = wb.Worksheets.Add(string.IsNullOrWhiteSpace(sheetName) ? "Data" : sheetName);

            // header row
            for (int c = 0; c < dt.Columns.Count; c++)
                ws.Cell(1, c + 1).Value = dt.Columns[c].ColumnName;

            // data
            for (int r = 0; r < dt.Rows.Count; r++)
            {
                for (int c = 0; c < dt.Columns.Count; c++)
                {
                    //var v = dt.Rows[r][c];
                    //ws.Cell(r + 2, c + 1).Value = v == DBNull.Value ? "" : v;
                    var v = dt.Rows[r][c];
                    var cell = ws.Cell(r + 2, c + 1);



                    if (v == DBNull.Value || v is null)
                    {
                        cell.SetValue(string.Empty);
                        continue;
                    }

                    switch (v)
                    {
                        case string s: cell.SetValue(s); break;
                        case DateTime d: cell.SetValue(d); break;
                        case bool b: cell.SetValue(b); break;
                        case byte b8: cell.SetValue(b8); break;
                        case short i16: cell.SetValue(i16); break;
                        case int i32: cell.SetValue(i32); break;
                        case long i64: cell.SetValue(i64); break;
                        case float f32: cell.SetValue(f32); break;
                        case double f64: cell.SetValue(f64); break;
                        case decimal m: cell.SetValue(m); break;
                        case Guid g: cell.SetValue(g.ToString()); break;
                        default: cell.SetValue(v.ToString()); break;
                    }
                }     
        
    }


            ws.RangeUsed()?.SetAutoFilter();
            ws.Columns().AdjustToContents();
            wb.SaveAs(path);
            return path;


        }
    }
}

