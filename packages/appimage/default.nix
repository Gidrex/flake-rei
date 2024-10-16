{ pkgs, ... }:
let
  logseq-icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/logseq/logseq/refs/heads/master/resources/icon.png";
    sha256 = "1jg24pi88nl8ynk2zbmz4qkl2al38w28kjv8drddgi8vvqh76c77";
  };
in
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
      icon = "${loseq-icon}";
      terminal = false; 
      type = "Application";
      categories = [ "Utility" ];
      mimeType = [ "application/x-logseq" ];
      startupNotify = true;
    };
  };
}
