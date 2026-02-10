# Machines

- `clean-niri` - pc setup with niri
- `nixos-icelake` - Ice Lake NixOS laptop
- `clean` - clean setup, only cli tools

## Nix installing on non-NixOS systems
Install nix via a script or your system's package manager and sometimes you will optionally need to:
```sh
sudo usermod -aG nix-users $(whoami) # nix-users group must be
sudo systemctl start nix-daemon
sudo systemctl enable --now nix-daemon.socket nix-daemon.service
```

### First system-build with home-manager
```sh
git clone git@github.com:Gidrex/flake-rei.git ~/flake-rei
nix run --experimental-features "flakes nix-command" home-manager/master -- switch --flake ~/flake-rei/#<current machine>
```

## Setup rclone for Google Drive
1) configure rclone with alias/name "gdisk"
2)
```sh
rclone mount gdrive: ~/gdrive \
  --vfs-cache-mode full \
  --vfs-cache-max-size 10G \
  --vfs-cache-max-age 24h \
  --dir-cache-time 1h \
  --poll-interval 15s \
  --vfs-read-chunk-size 32M \
  --vfs-read-chunk-size-limit 2G \
  --daemon
```