{
  description = "Gidrex NixOS flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # impermanence.url = "github:nix-community/impermanence"; # TODO
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    # Users pkgs(flakes)
    byedpi.url = "github:Gidrex/byedpi-nix";
    catppuccin.url = "github:catppuccin/nix";
    ayugram-desktop.url = "github:kaeeraa/ayugram-desktop/release?submodules=1";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, byedpi, ayugram-desktop, ... }: 
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        rei = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./configuration.nix
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gidrex = { config, lib, pkgs, ... }: {
                imports = [
                  ./home.nix
                  catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
            {
              environment.systemPackages = [
                byedpi.packages.${system}.default
              ];
            }
          ];
        };
      };
    };
}
