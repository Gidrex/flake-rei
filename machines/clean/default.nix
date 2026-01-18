{ ... }:
{
  catppuccin.enable = true;
  programs = {
    fish.enable = true;
    foot = {
      enable = true;
      settings.main.font = "JetBrainsMono Nerd Font Mono:size=9";
    };
  };

  home.packages = [ ];

  home.sessionVariables.FLAKE_MACHINE = "clean";
  home.stateVersion = "25.05";
}
