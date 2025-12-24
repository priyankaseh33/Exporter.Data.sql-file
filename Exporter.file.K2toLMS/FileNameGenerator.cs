using System;
using System.IO;
using System.Text.RegularExpressions;

namespace Exporter.file.K2toLMS
{
    public class FileNameGeneratorV2
    {
        private readonly string folderPath;

        public FileNameGeneratorV2(string folderPath)
        {
            this.folderPath = folderPath;
        }

        /// <summary>
        /// Generate file name from template, filling date and count number (if needed)
        /// </summary>
        public string GenerateFileName(string fileNameTemplate, DateTime date)
        {
            string datePart = date.ToString("yyyyMMdd");
            bool needsCount = fileNameTemplate.Contains("{N}");

            int count = needsCount ? GetNextCount(fileNameTemplate, datePart) : 0;

            string fileName = fileNameTemplate
                .Replace("{AD_YYYYMMDD}", datePart)
                .Replace("{N}", needsCount ? count.ToString() : "");

            return fileName;
        }

        /// <summary>
        /// Scan folder for files matching template and find max count N
        /// </summary>
        private int GetNextCount(string fileNameTemplate, string datePart)
        {
            // Build regex by replacing {N} with (\d+) and {AD_YYYYMMDD} with actual date
            string regexPattern = Regex.Escape(fileNameTemplate)
                .Replace("\\{N\\}", "(\\d+)")
                .Replace("\\{AD_YYYYMMDD\\}", datePart)
                .Replace("\\_", "_"); // Ensure underscore remains normal

            regexPattern = "^" + regexPattern + "$";

            var regex = new Regex(regexPattern);
            int maxN = 0;
            var files = Directory.GetFiles(folderPath);

            foreach (var filePath in files)
            {
                var fileName = Path.GetFileName(filePath);
                var match = regex.Match(fileName);
                if (match.Success && match.Groups.Count > 1 && int.TryParse(match.Groups[1].Value, out int n))
                {
                    if (n > maxN) maxN = n;
                }
            }
            return maxN + 1; // Next available count number
        }
    }

}
