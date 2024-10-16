{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./logseq.nix {})
  ];

}
