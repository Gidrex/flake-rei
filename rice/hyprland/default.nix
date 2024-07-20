{ pkgs, ... }:
{

home.packages = with pkgs; [
  # hyprpaper
  wlr-randr
  xwayland
  slurp
  # wl-clipboard
  # swayidle
  dunst
  # kanshi # >1 display
];

wayland.windowManager.hyprland = {
  enable = true;
  systemd.enable = true; # enable when configure extraConfig
  # nvidiaPatches = true;
  # extraConfig = builtins.readFile ../../config/hyprland.conf;
};

} 
