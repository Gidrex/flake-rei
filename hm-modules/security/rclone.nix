{ config, ... }:
{
  programs.rclone = {
    enable = true;
    remotes = {
      gdrive = {
        config = {
          type = "drive";
          scope = "drive";
        };
        secrets = {
          client_id = config.sops.secrets.gdrive_client_id.path;
          client_secret = config.sops.secrets.gdrive_secret.path;
          token = config.sops.secrets.gdrive_token.path;
        };
        mounts = {
          "" = {
            enable = true;
            mountPoint = "${config.home.homeDirectory}/gdrive";
            options = {
              vfs-cache-max-size = "10G";
              vfs-cache-max-age = "24h";
              dir-cache-time = "1h";
              poll-interval = "15s";
              vfs-read-chunk-size = "32M";
              vfs-read-chunk-size-limit = "2G";
            };
          };
        };
      };
    };
  };
}
