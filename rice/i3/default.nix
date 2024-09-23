{ pkgs, ... }:
{
  # i3 + xfce
  services.xserver = {
    windowManager.i3.enable = true;
    windowManager.i3.extraPackages = with pkgs; [ kitty i3status i3blocks ];
    desktopManager.xterm.enable = false;
  };
}
