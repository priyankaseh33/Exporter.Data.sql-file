using Renci.SshNet;
using System.IO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Exporter.Services
{
    public class SftpUploader
    {
        private readonly string _host;
        private readonly int _port;
        private readonly string _username;
        private readonly string? _password;
        private readonly string? _privateKeyPath;
        private readonly string? _privateKeyPassphrase;
        private readonly string _remoteDir;

        public static SftpUploader FromSettings(Dictionary<string, string> settings)
        {
            // Expected keys in dbo.ExportSetting:
            // SFTP_HOST, SFTP_PORT, SFTP_USER, SFTP_PASS (optional), SFTP_KEY_PATH (optional),
            // SFTP_KEY_PASSPHRASE (optional), SFTP_REMOTE_DIR
            if (!settings.TryGetValue("SFTP_HOST", out var host) || string.IsNullOrWhiteSpace(host))
                throw new InvalidOperationException("Missing SFTP_HOST in settings.");
            var port = settings.TryGetValue("SFTP_PORT", out var p) && int.TryParse(p, out var pn) ? pn : 22;
            if (!settings.TryGetValue("SFTP_USER", out var user) || string.IsNullOrWhiteSpace(user))
                throw new InvalidOperationException("Missing SFTP_USER in settings.");
            settings.TryGetValue("SFTP_PASS", out var pass);
            settings.TryGetValue("SFTP_KEY_PATH", out var keyPath);
            settings.TryGetValue("SFTP_KEY_PASSPHRASE", out var keyPass);
            var remoteDir = settings.TryGetValue("SFTP_REMOTE_DIR", out var rd) && !string.IsNullOrWhiteSpace(rd) ? rd : "/";

            return new SftpUploader(host, port, user, pass, keyPath, keyPass, remoteDir);
        }

        public SftpUploader(string host, int port, string username, string? password, string? privateKeyPath, string? privateKeyPassphrase, string remoteDir)
        {
            _host = host;
            _port = port;
            _username = username;
            _password = password;
            _privateKeyPath = privateKeyPath;
            _privateKeyPassphrase = privateKeyPassphrase;
            _remoteDir = string.IsNullOrWhiteSpace(remoteDir) ? "/" : remoteDir.Replace('\\', '/');
        }

        public void Upload(string localFilePath)
        {
            if (!File.Exists(localFilePath))
                throw new FileNotFoundException("Local file not found.", localFilePath);

            var methods = new List<AuthenticationMethod>();

            if (!string.IsNullOrEmpty(_privateKeyPath) && File.Exists(_privateKeyPath))
            {
                if (!string.IsNullOrEmpty(_privateKeyPassphrase))
                    methods.Add(new PrivateKeyAuthenticationMethod(_username, new PrivateKeyFile(_privateKeyPath, _privateKeyPassphrase)));
                else
                    methods.Add(new PrivateKeyAuthenticationMethod(_username, new PrivateKeyFile(_privateKeyPath)));
            }

            if (!string.IsNullOrEmpty(_password))
            {
                methods.Add(new PasswordAuthenticationMethod(_username, _password));
            }

            if (methods.Count == 0)
                throw new InvalidOperationException("No valid SFTP authentication method configured.");

            var connInfo = new ConnectionInfo(_host, _port, _username, methods.ToArray());

            using var sftp = new SftpClient(connInfo);
            sftp.Connect();

            // Ensure remote directory exists (create if necessary)
            EnsureRemoteDirectory(sftp, _remoteDir);

            var remotePath = $"{_remoteDir.TrimEnd('/')}/{Path.GetFileName(localFilePath)}";
            using var fs = File.OpenRead(localFilePath);
            sftp.UploadFile(fs, remotePath, true);

            sftp.Disconnect();
        }

        private static void EnsureRemoteDirectory(SftpClient sftp, string dir)
        {
            if (string.IsNullOrWhiteSpace(dir) || dir == "/") return;
            var parts = dir.Trim('/').Split('/', StringSplitOptions.RemoveEmptyEntries);
            var current = "";
            foreach (var p in parts)
            {
                current += "/" + p;
                if (!sftp.Exists(current))
                    sftp.CreateDirectory(current);
            }
        }
    }
}

