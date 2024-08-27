{
  description = "Gidrex NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # impermanence.url = "github:nix-community/impermanence"; # TODO
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    flake-utils.url = "github:numtide/flake-utils";
    byedpi.url = "github:Gidrex/byedpi-nix";
  };

  outputs = { nixpkgs, home-manager, catppuccin, byedpi, android-nixpkgs, ... }: let
    system = "x86_64-linux";
    # pkgs = import nixpkgs { system = system; };
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

                android-nixpkgs.hmModule
                {
                  inherit config lib pkgs;
                  android-sdk.enable = true;

                  # Optional; default path is "~/.local/share/android".
                  android-sdk.path = "${config.home.homeDirectory}/.android/sdk";

                  android-sdk.packages = sdk: with sdk; [
                    build-tools-34-0-0
                    cmdline-tools-latest
                    emulator
                    platforms-android-34
                    sources-android-34
                  ];
                }
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
