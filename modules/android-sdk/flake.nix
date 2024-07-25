{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  inputs.android-nixpkgs.url = "path:/path/to/android-nixpkgs";

  outputs = { self, nixpkgs, android-nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
  in {
    defaultPackage.x86_64-linux = pkgs.mkShell {
      buildInputs = with pkgs; [ android-studio ];

      shellHook = ''
        echo "Welcome to the Nix shell!"
      '';
    };

    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [ android-studio ];

      shellHook = ''
        echo "Welcome to the Nix development shell!"
      '';
    };

    androidSdk = android-nixpkgs.sdk (sdkPkgs: with sdkPkgs; [
      cmdline-tools-latest
      build-tools-34-0-0
      platform-tools
      platforms-android-34
      emulator
    ]);
  };
}
