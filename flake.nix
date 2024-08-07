{
  description = "Gidrex NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence"; # TODO
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    byedpi.url = "git@github.com:Gidrex/byedpi-nix.git";
  };

  outputs = { nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      rei = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gidrex = {
              imports = [ ./home.nix ];
            };
          }
        ];
      };
    };
  };
}

