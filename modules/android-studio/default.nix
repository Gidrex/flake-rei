let
  nixpkgs-24-05 = import (fetchTarball {
    url = "https://nixos.org/channels/nixos-24.05/nixexprs.tar.xz";
  }) { };
in
{
  environment.systemPackages = [
    nixpkgs-24-05.android-studio
  ];
}
