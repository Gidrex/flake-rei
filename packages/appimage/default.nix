{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./logseq.nix {})
  ];

}
