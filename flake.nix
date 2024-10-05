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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Users pkgs(flakes)
    byedpi.url = "github:Gidrex/byedpi-nix";
    catppuccin.url = "github:catppuccin/nix";
    ayugram-desktop.url = "github:kaeeraa/ayugram-desktop/release?submodules=1";
    bluetui.url = "github:pythops/bluetui";
  };

  outputs = { nixpkgs, home-manager, catppuccin, byedpi, ayugram-desktop, bluetui, ... }: 
    let
      system = "x86_64-linux";
      username = "gidrex";
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
              home-manager.users.${username} = { config, lib, pkgs, ... }: {
                imports = [
                  ./home.nix
                  catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
            {
              environment.systemPackages = [
                byedpi.packages.${system}.default
                ayugram-desktop.packages.${system}.default
                bluetui.packages.${system}.default
              ];
            }
          ];
        };
      };
    };
}
