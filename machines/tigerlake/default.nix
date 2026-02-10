{ pkgs, ... }:
{
  catppuccin.enable = true;
  programs = {
    fish.enable = true;
    foot = {
      enable = true;
      settings.main.font = "JetBrainsMono Nerd Font Mono:size=14";
    };
  };

  home.packages = with pkgs; [ scanmem ];

  home.sessionVariables.FLAKE_MACHINE = "tigerlake";
  home.stateVersion = "25.05";
}
