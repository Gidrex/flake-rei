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
      exec = "logseq";
      icon = "https://github.com/logseq/logseq/blob/master/resources/icon.png";
      terminal = false; 
      type = "Application";
      categories = [ "Utility" ];
      mimeType = [ "application/x-logseq" ];
      startupNotify = true;
    };
  };
}
