{ pkgs, config, ... }:
let
  Themes = pkgs.fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "Themes";
    rev = "main";
    sha256 = "Jzpb9fgyPYa1NxgFBy8HnHtfy8nORNS4jzMUzNEDFJ8=";
  };

in {
  home.packages = with pkgs; [ prismlauncher ];

  home.activation.copyPrismLauncherThemes = ''
    cp -r ${Themes}/icons "${config.home.homeDirectory}/.local/share/PrismLauncher/"
    cp -r ${Themes}/themes "${config.home.homeDirectory}/.local/share/PrismLauncher/"
    cp -r ${Themes}/cats/* "${config.home.homeDirectory}/.local/share/PrismLauncher/catpacks"
  '';
}
