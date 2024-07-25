let
  nixpkgs-24-05 = import (fetchTarball {
    url = "https://nixos.org/channels/nixos-24.05/nixexprs.tar.xz";
    sha256 = "0w5kza4qrnlhsp1ls385zmf6cbkfwcxiriz69bi29zjhn2rl9gh5";
    }) { 
    system = "x86_64-linux"; 
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with nixpkgs-24-05; [
    android-studio
    cmdline-tools-latest
    build-tools-34-0-0
    platform-tools
    platforms-android-34
    emulator
  ];
}
