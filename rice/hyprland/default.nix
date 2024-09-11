{ pkgs, ... }:
{

  home.packages = with pkgs; [
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

  services.xserver.enable = false;
  services.dbus.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true; # enable when configure extraConfig
    # nvidiaPatches = true;
    # extraConfig = builtins.readFile ../../config/hyprland.conf;
  };

} 
