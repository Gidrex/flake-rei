{ pkgs, ... }:
{

  home.packages = with pkgs; [
    hyprland 
    hyprpaper
    wlr-randr
    xwayland
    slurp
    wl-clipboard
    swayidle
    dunst
    hyprshot
    wofi
    # kanshi # >1 display
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ../../config/hypr/hyprland.conf;
  };
} 
