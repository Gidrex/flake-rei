{ pkgs, lib, ... }:
{
  imports = [ ../../hm-modules/wayland/waybar/hypr-laptop ];
  programs = {
    # Ricing
    waybar.enable = true;
    wlogout.enable = true;
    # hyprland.enable = true; # TODO
    foot = {
      enable = true;
      settings.main.font = "SauceCodePro Nerd Font:size=16";
    };

    nushell.extraConfig = ''
      def rb [] {
        ~/flake-rei/assets/scripts/backup.sh
        home-manager switch --flake ~/flake-rei/#laptop-hypr
      }
    '';

    # Utility
    pandoc.enable = true;

    yt-dlp = {
      enable = true;
      settings = {
        downloader = "aria2c";
        downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        format = "mp4";
      };
    };

    # Apps
    chromium.enable = true;
    zathura.enable = true;
    onlyoffice = {
      # enable = true;
      settings.position = "@Rect(0 0 2160 1410)";
    };

    # Dev
    bun.enable = true;
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = builtins.toString ../../assets/scripts/swaylock_fancy.sh;
      }
    ];
  };

  home.packages = with pkgs; [
    # Rise
    grimblast
    hyprpaper

    # apps
    logseq

  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      # Zen Browser
      (lib.genAttrs [
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/xhtml+xml"
        "application/x-extension-xhtml"
        "application/x-extension-xht"
      ] (_: "zen.desktop"))
      //

        # Feh for images
        (lib.genAttrs [
          "image/png"
          "image/jpeg"
          "image/jpg"
          "image/gif"
          "image/bmp"
          "image/webp"
          "image/tiff"
          "image/svg+xml"
        ] (_: "feh.desktop"))
      // {

        # Zathura
        "application/pdf" = "qpdfview.desktop";
        "application/x-pdf" = "qpdfview.desktop";
        "image/vnd.djvu" = "org.pwmt.zathura-djvu.desktop";
        "application/postscript" = "org.pwmt.zathura-ps.desktop";
        "application/x-cbr" = "org.pwmt.zathura-cb.desktop";

        # Others
        "text/html" = "chromium-browser.desktop";
      };
  };

  home.sessionVariables.FLAKE_MACHINE = "laptop-hypr";
}
