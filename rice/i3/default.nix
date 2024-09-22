{ pkgs, ... }:
{
  # i3 + xfce

  environment.systemPackages = with pkgs; [
    libexecinfo
    i3 i3lock-fancy
    gxkb parcellite
  ];

  services = {
    xserver = {
      windowManager.i3.enable = true;
      windowManager.i3.extraPackages = with pkgs; [ kitty i3status i3lock i3blocks ];
      desktopManager.xterm.enable = false;
    };
  };
}
