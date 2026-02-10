# Machines

- `tigerlake` - my laptop-doc station with tigerlake arch
- `icelake` - my laptop with icelake arch
- `nixos-icelake` - icelake NixOS laptop
 
## Nix installing on non-NixOS systems
Install nix via a script or your system's package manager and sometimes you will optionally need to:
```sh
sudo usermod -aG nix-users $(whoami) # nix-users group must be
sudo systemctl start nix-daemon
sudo systemctl enable --now nix-daemon.socket nix-daemon.service
```

### First system-build with home-manager
```sh
export FLAKE_MACHINE=<machine name>
git clone git@github.com:Gidrex/flake-rei.git ~/flake-rei
nix run --experimental-features "flakes nix-command" home-manager/master -- switch --flake ~/flake-rei/#"$FLAKE_MACHINE" --experimental-features "nix-command flakes"
```

## Setup niri config are avaible for 2 machines:

- tigerlake
- icelake

```sh
export FLAKE_MACHINE=<machine name>
mkdir -p ~/.config/niri
ln -sf ~/flake-rei/dotfiles/niri/config_"$FLAKE_MACHINE".kdl ~/.config/niri/config.kdl
ln -sf ~/flake-rei/dotfiles/niri/{generic/,"$FLAKE_MACHINE"/} ~/.config/niri/
```

## Setup rclone for Google Drive
1) configure rclone with alias/name "gdrive"
```sh
rclone config 
```
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
