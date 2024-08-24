{
  description = "Gidrex NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence"; # TODO
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
    flake-utils.url = "github:numtide/flake-utils";
    byedpi.url = "github:Gidrex/byedpi-nix";
  };

  outputs = { nixpkgs, catppuccin, byedpi, ... }: let
    system = "x86_64-linux";
    # pkgs = import nixpkgs { system = system; };
  in {
    nixosConfigurations = {
      rei = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./configuration.nix
          catppuccin.nixosModules.catppuccin
          # home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gidrex = {
              imports = [ 
                ./home.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
          }
          {
            environment.systemPackages = [ byedpi.packages.${system}.default ];
          }
        ];
      };
    };
  };
}
