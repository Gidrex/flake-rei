{
  description = "Gidrex flake configuration for working machines.";

  inputs = {
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # Build system (NixOS only)
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Theming
    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    # Zellij plugins
    zjstatus.url = "github:dj95/zjstatus";

    # Yazi plugins
    open-with-cmd.url = "github:Ape/open-with-cmd.yazi";
    open-with-cmd.flake = false;
    close-and-restore-tab.url =
      "github:MasouShizuka/close-and-restore-tab.yazi";
    close-and-restore-tab.flake = false;
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      # Clean yazi plugins from docs
      cleanPlugin = src:
        nixpkgs.lib.cleanSourceWith {
          src = src;
          filter = path: type:
            let baseName = baseNameOf path;
            in !(builtins.any (suffix: nixpkgs.lib.hasSuffix suffix baseName) [
              ".md"
              "LICENSE"
              ".png"
              ".jpg"
            ] || baseName == "README"
              || nixpkgs.lib.hasInfix "LICENSE" baseName # exclude this files
              || (type == "directory" && builtins.pathExists path
                && builtins.length (builtins.attrNames (builtins.readDir path))
                == 0)); # empty dirs
        };

      # Module arguments
      moduleArgs = {
        # inherit (inputs) catppuccin-foot;
        yazi-plugins = builtins.mapAttrs (_: cleanPlugin) {
          inherit (inputs) open-with-cmd close-and-restore-tab;
        };
      };

      # Common modules
      commonModules = [
        ./home.nix
        ./hm-modules/termTools/yazi
        ./hm-modules/termTools/fish
        ./hm-modules/termTools/nushell
        ./hm-modules/termTools/helix
        ./hm-modules/termTools/zellij
        ./hm-modules/termTools/less.nix

        ./hm-modules/wayland/wlogout

        inputs.catppuccin.homeModules.catppuccin

        { _module.args = moduleArgs; }
      ];

      pkgs = import nixpkgs {
        system = "x86_64-linux";

        config = {
          allowunfree = false;
          allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [ "unrar" "obsidian" ];
        };

        overlays = [
          (final: prev: {
            zjstatus =
              inputs.zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
            tgt =
              inputs.tgt.packages.${prev.stdenv.hostPlatform.system}.default;
          })
        ];
      };

      # Machine configurations
      machines = {
        laptop-hypr = ./machines/laptop-hypr; # perfomance station
        nixos-icelake = ./machines/nixos-icelake; # Ice Lake NixOS laptop
        clean = ./machines/clean; # clean setup, only cli tools
        clean-niri = ./machines/clean-niri; # clean setup for niri
      };

    in {
      # NixOS builder
      nixosConfigurations = {
        nixos-icelake = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/nixos-icelake/configuration.nix
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                (final: prev: {
                  zjstatus =
                    inputs.zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
                })
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.gidrex = {
                  imports = commonModules ++ [ machines.nixos-icelake ];
                };
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      # Home Manager builder
      homeConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames machines)
        (name:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = commonModules ++ [ machines.${name} ];
          });
    };
}
