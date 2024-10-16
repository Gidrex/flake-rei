{ pkgs, ... }:
let
  # Icons
  logseq-icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/logseq/logseq/refs/heads/master/resources/icon.png";
    sha256 = "1jg24pi88nl8ynk2zbmz4qkl2al38w28kjv8drddgi8vvqh76c77";
  };
  zen-icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/zen-browser/desktop/6d0753c5e9e054a420c28dc207220c5ff4694a9d/docs/assets/zen-black.svg";
    sha256 = "1jg24pi88nl8ynk2zbmz4qkl2al38w28kjv8drddgi8vvqh76c77";
  };

  # Packages
  logseq = pkgs.callPackage ./logseq.nix {};
  zenBrowser = pkgs.callPackage ./zen-browser.nix {};

  # home-manager
in
{
  home.packages = with pkgs; [
    logseq
    zenBrowser
  ];

  xdg.desktopEntries = {
    logseq = {
      name = "Logseq";
      genericName = "Knowledge Management Tool";
      comment = "Open-source knowledge management and collaboration tool";
      exec = "${logseq}/bin/logseq";
      icon = "${logseq-icon}";
      terminal = false; 
      type = "Application";
      categories = [ "Utility" ];
      mimeType = [ "application/x-logseq" ];
      startupNotify = true;
    };

    zenbrowser = {
      name = "Zen Browser";
      genericName = "Privacy-Focused Web Browser";
      comment = "Beautifully designed, privacy-focused, and packed with features.";
      exec = "${zenBrowser}/bin/zen-generic";
      icon = "${zen-icon}";
      terminal = false; 
      type = "Application";
      categories = [ "Network" "WebBrowser" ];
      mimeType = [ "application/x-zenbrowser" ];
      startupNotify = true;
    };
  };
}
