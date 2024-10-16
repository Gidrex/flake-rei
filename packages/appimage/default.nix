{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (callPackage ./logseq.nix {})
  ];
  xdg.desktopEntries = {
    logseq = {
      name = "Logseq";
      genericName = "Knowledge Management Tool";
      comment = "Open-source knowledge management and collaboration tool";
      exec = "${pkgs.logseq-appimage}/bin/logseq";
      icon = "${pkgs.logseq-appimage}/share/icons/hicolor/512x512/apps/logseq.png";
      terminal = false;
      type = "Application";
      categories = [ "Utility" ];
      mimeType = "application/x-logseq";
      startupNotify = true;
    };
  };
}
