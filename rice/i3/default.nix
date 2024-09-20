{ pkgs, ... }:
{
  # i3 + xfce

  environment.systemPackages = with pkgs; [
    libexecinfo
    i3 i3lock-fancy
    gxkb parcellite
  ];

  services = {
    displayManager.defaultSession = "none+i3";
    xserver = {
      windowManager.i3.enable = true;
      windowManager.i3.extraPackages = with pkgs; [ kitty i3status i3lock i3blocks ];
      desktopManager.xterm.enable = false;
    };

    picom = {
      enable = true;
      # inactiveOpacity = 0.98;
      activeOpacity = 1;
      fade = false;
      vSync = true;
      shadow = true;
      fadeDelta = 4;
      fadeSteps = [0.02 0.5];
      backend = "glx";
      opacityRules = [
        "94:class_g = 'Thunar'"
        "90:class_g = 'Spotube'"
        "96:class_g = 'Alacritty'"
        "96:class_g = 'kitty'"
        "96:class_g = 'zen-alpha'"
        "96:class_g = 'Navigator.zen-alpha'"
        "96:class_g = 'vesktop'"
      ];
    };
  };

}
