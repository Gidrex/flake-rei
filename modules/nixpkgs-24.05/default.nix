let
  nixpkgs-24-05 = import (fetchTarball {
    url = "https://nixos.org/channels/nixos-24.05/nixexprs.tar.xz";
    # sha256 = "0gy2wvfwwi2jss5prhxq5c1rw321mi82c0mnki5m404j2zzzas6f";
    sha256 = "5571fe5cebc7f865d63c7228e25532223a1ad7e422b772a4cf1d769e6f789297";
    }) { 
    system = "x86_64-linux"; 
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with nixpkgs-24-05; [
    android-studio
  ];
}
