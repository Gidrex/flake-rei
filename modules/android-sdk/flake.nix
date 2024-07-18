{
  description = "Packages for Android development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, devshell, flake-utils }:
    let
      sdkPkgsFor = pkgs: import ./default.nix {
        inherit pkgs;
        channel = builtins.readFile ./channel;
      };
    in
    {

      hmModules.android = import ./hm-module.nix;

      hmModule = self.hmModules.android;

      overlays.default = final: prev:
        let
          android = sdkPkgsFor final;
        in
        {
          androidSdkPackages = android.packages;
          androidSdk = android.sdk;
        };

      templates.default = {
        path = ./template;
        description = "Android application or library";
      };
    }
    //
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            overlays = [
              (devshell.overlay)
              (self.overlay)
            ];
            allowInsecurePredicate = pkg: pkg.pname == "python";
          };
        };

        sdkPkgs = sdkPkgsFor pkgs;
      in
      {
        inherit (sdkPkgs) sdk;

        apps = {
          format = {
            type = "app";
            program = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
        };

        checks = {
          lint = with pkgs; runCommandLocal "lint" { } ''
            cd ${./.}
            ${nixpkgs-fmt}/bin/nixpkgs-fmt --check *.nix pkgs/android/*.nix template/*.nix nix-android-repo/*.nix
            echo "checked" > $out
          '';

          sdk = self.sdk.${system} (sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            build-tools-34-0-0
            emulator
            ndk-26-1-10909125
            platform-tools
            platforms-android-34
            tools
          ]);
        };

        packages = flake-utils.lib.flattenTree sdkPkgs.packages;
      });
}
