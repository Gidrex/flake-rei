let
  nixpkgs-24-05 = import (fetchTarball {
    url = "https://nixos.org/channels/nixos-24.05/nixexprs.tar.xz";
    sha256 = "1nanlslf1mdnnpxl7i3c7dkdz2dm4mbl6d6xc2w1bx21jgsk5g37";
  }) { };
in
{
  environment.systemPackages = [
    nixpkgs-24-05.android-studio
  ];
}
