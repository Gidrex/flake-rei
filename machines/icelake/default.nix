{ ... }:
{
  catppuccin.enable = true;
  programs = {
    fish.enable = true;
    foot = {
      enable = true;
      settings.main.font = "JetBrainsMono Nerd Font Mono:size=11";
    };
  };

  # home.packages = with pkgs; [ ];

  home.sessionVariables.FLAKE_MACHINE = "icelake";
  home.stateVersion = "25.05";
}
