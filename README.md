# Apart of disko
```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disk-config.nix
```

# Setup flake
```sh
git clone git@github.com:gidrex/flake-rei
cd flake-rei
sudo nixos-rebuild switch --flake ~/flake-rei/
```
