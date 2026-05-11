{ pkgs, ... }:
{
  catppuccin.enable = true;
  programs = {
    fish.enable = true;
    foot = {
      enable = true;
      settings.main.font = "GeistMonoNerdFontMono:size=14";
    };
  };

  home.packages = with pkgs; [ scanmem ];

  home.sessionVariables.FLAKE_MACHINE = "tigerlake";
  home.stateVersion = "26.05";
}
