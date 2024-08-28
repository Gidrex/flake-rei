{ config, pkgs, ... }:

let
  androidSdkModule = import ((builtins.fetchGit {
    url = "https://github.com/tadfisher/android-nixpkgs.git";
    ref = "main";  # Or "stable", "beta", "preview", "canary"
  }) + "/hm-module.nix");

in
{
  imports = [ androidSdkModule ];

  android-sdk.enable = true;

  # Optional; default path is "~/.local/share/android".
  android-sdk.path = "${config.home.homeDirectory}/.android/sdk";

  android-sdk.packages = sdkPkgs: with sdkPkgs; [
    build-tools-34-0-0
    cmdline-tools-latest
    emulator
    platforms-android-34
    sources-android-34
  ];
}
