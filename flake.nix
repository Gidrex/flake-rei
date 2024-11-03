{
  description = "Gidrex NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
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
    ayugram-desktop.url = "github:kaeeraa/ayugram-desktop/release?submodules=1";
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };   

  outputs = { 
    nixpkgs, home-manager, catppuccin, # system affecting
    ayugram-desktop, prismlauncher, zen-browser, # packages
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
              environment.systemPackages = [
                ayugram-desktop.packages.${system}.default
                prismlauncher.packages.${system}.default
                zen-browser.packages."${system}".default
              ];
            }
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
          ];
        };
      };
    };
}
