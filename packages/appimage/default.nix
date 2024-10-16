{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ./logseq.nix)
  ];

  environment.systemPackages = with pkgs; [
    logseq-appimage
  ];
}
