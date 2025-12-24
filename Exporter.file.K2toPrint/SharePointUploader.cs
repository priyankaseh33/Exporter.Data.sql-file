using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using Microsoft.Identity.Client;

namespace Exporter.Services
{
    public class SharePointUploader
    {
        private readonly string _tenantId;
        private readonly string _clientId;
        private readonly string _siteUrl;
        private readonly string _certPath;
        private readonly string _certPass;

        public SharePointUploader(string tenantId, string clientId, string siteUrl, string certPath, string certPass)
        {
            _tenantId = tenantId;
            _clientId = clientId;
            _siteUrl = siteUrl;
            _certPath = certPath;
            _certPass = certPass;
        }

        public async Task UploadFileAsync(string filePath, string folderRelativeUrl)
        {
            var certificate = new X509Certificate2(_certPath, _certPass, X509KeyStorageFlags.MachineKeySet);
            var app = ConfidentialClientApplicationBuilder.Create(_clientId)
                .WithCertificate(certificate)
                .WithTenantId(_tenantId)
                .Build();

            var scopes = new[] { $"https://{new Uri(_siteUrl).Host}/.default" };
            var authResult = await app.AcquireTokenForClient(scopes).ExecuteAsync();
            var accessToken = authResult.AccessToken;

            var fileName = Path.GetFileName(filePath);

            //URL-encode the filename for the SharePoint API
            var encodedFileName = Uri.EscapeDataString(fileName);

            //use encodedFileName:
            var uploadUrl = $"{_siteUrl.TrimEnd('/')}/_api/web/GetFolderByServerRelativeUrl('{folderRelativeUrl}')/Files/add(overwrite=true, url='{encodedFileName}')";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            using var stream = File.OpenRead(filePath);
            var content = new StreamContent(stream);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");

            var response = await httpClient.PostAsync(uploadUrl, content);
            response.EnsureSuccessStatusCode();
        }



        public async Task UploadFileAsync_backup(string filePath, string folderRelativeUrl)
        {
            var certificate = new X509Certificate2(_certPath, _certPass, X509KeyStorageFlags.MachineKeySet);
            var app = ConfidentialClientApplicationBuilder.Create(_clientId)
                .WithCertificate(certificate)
                .WithTenantId(_tenantId)
                .Build();

            //var scopes = new[] { $"{new Uri(_siteUrl).Host}/.default" };
            var scopes = new[] { $"https://{new Uri(_siteUrl).Host}/.default" };
            var siteHost = new Uri(_siteUrl).Host; // e.g., 'ngernhaijai.sharepoint.com'

            var authResult = await app.AcquireTokenForClient(scopes).ExecuteAsync();
            var accessToken = authResult.AccessToken;

            var fileName = Path.GetFileName(filePath);
            var uploadUrl = $"{_siteUrl.TrimEnd('/')}/_api/web/GetFolderByServerRelativeUrl('{folderRelativeUrl}')/Files/add(overwrite=true, url='{fileName}')";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            using var stream = File.OpenRead(filePath);
            var content = new StreamContent(stream);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");

            var response = await httpClient.PostAsync(uploadUrl, content);
            response.EnsureSuccessStatusCode();
        }
    }
}
