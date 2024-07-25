let
  nixpkgs-24-05 = import (fetchTarball {
    url = "https://nixos.org/channels/nixos-24.05/nixexprs.tar.xz";
    # sha256 = "0gy2wvfwwi2jss5prhxq5c1rw321mi82c0mnki5m404j2zzzas6f";
    sha256 = "0w5kza4qrnlhsp1ls385zmf6cbkfwcxiriz69bi29zjhn2rl9gh5";
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
