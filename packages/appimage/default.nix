{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (callPackage ./logseq.nix {})
  ];

}
