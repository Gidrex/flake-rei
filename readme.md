# Machines

- `laptop-hypr` - performance station
- `nixos-icelake` - Ice Lake NixOS laptop
- `clean` - clean setup, only cli tools

## Nix installing on non-NixOS systems
Install nix via a script or your system's package manager and sometimes you will optionally need to:
```sh
sudo usermod -aG nix-users $(whoami) # nix-users group must be
sudo systemctl start nix-daemon
```

### First system-build with home-manager
```sh
git clone git@codeberg.org:Gidrex/flake-sysconf.git ~/flake-sysconf
nix run --experimental-features "flakes nix-command" home-manager/master -- switch --flake ~/flake-sysconf/#<current machine>
```

## Building NixOS with disko for icelake machine

### Disk partitioning and system installation:
```sh
sudo nix run --experimental-features "flakes nix-command" github:nix-community/disko -- --mode disko ./machines/nixos-icelake/hardware/disko.nix \
&& sudo nix run --experimental-features "flakes nix-command" github:nix-community/disko -- --mode mount ./machines/nixos-icelake/hardware/disko.nix \
&& sudo nixos-generate-config --root /mnt \
&& sudo nixos-install --flake .#nixos-icelake
```

### Building and switching NixOS configuration:
```sh
sudo nixos-rebuild switch --flake .#nixos-icelake
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