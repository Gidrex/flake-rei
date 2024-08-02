# Apart of disko
```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disk-config.nix
```

# Chanels of latest versions
```sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --update
```

# Setup flake
```sh
git clone git@github.com:gidrex/flake-rei
cd flake-rei
./config/dotfiling.sh
sudo nixos-rebuild switch --flake ~/flake-rei/
```
