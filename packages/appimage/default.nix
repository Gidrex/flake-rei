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
      exec = "${pkgs.logseq}/bin/logseq";  # Указываем logseq из callPackage
      icon = "${pkgs.logseq}/share/icons/hicolor/512x512/apps/logseq.png";  # Иконка оттуда же
      terminal = false;
      type = "Application";
      categories = [ "Utility" ];
      mimeType = "application/x-logseq";
      startupNotify = true;
    };
  };
}
