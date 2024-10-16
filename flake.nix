{
  description = "Gidrex NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # impermanence.url = "github:nix-community/impermanence"; # TODO
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # }; # TODO

    catppuccin.url = "github:catppuccin/nix";

    # Users pkgs(flakes)
    byedpi.url = "github:Gidrex/byedpi-nix";
    ayugram-desktop.url = "github:kaeeraa/ayugram-desktop/release?submodules=1";
    zjstatus.url = "github:dj95/zjstatus";
    
  };

  outputs = { 
    nixpkgs, home-manager, catppuccin, # system affecting
    byedpi, ayugram-desktop, zjstatus, # packages
    ... }: 
    let
      system = "x86_64-linux";
      name = "gidrex";
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
              home-manager.users.${name} = { config, lib, pkgs, ... }: {
                imports = [
                  ./home.nix
                  catppuccin.homeManagerModules.catppuccin
                ];
                home.username = name;
                home.homeDirectory = "/home/${name}";
              };
            }
            {
              environment.systemPackages = [
                byedpi.packages.${system}.default
                ayugram-desktop.packages.${system}.default
              ];

              nixpkgs.overlays = [
                (final: prev: {
                  zjstatus = zjstatus.packages.${prev.system}.default;
                })
              ];
            }
          ];
        };
      };
    };
}
