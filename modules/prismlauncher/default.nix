{ pkgs, config, lib, ... }:
let
  Themes = pkgs.fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "Themes";
    rev = "main";
    sha256 = "Jzpb9fgyPYa1NxgFBy8HnHtfy8nORNS4jzMUzNEDFJ8=";
  };

in {
  home.packages = with pkgs; [ prismlauncher ];

  home.activation.copyPrismLauncherThemes = lib.hm.dag.entryAfter ["home.file"] "copyThemes" ''
    cp -r ${Themes}/icons "${config.home.homeDirectory}/.local/share/PrismLauncher/"
    cp -r ${Themes}/themes "${config.home.homeDirectory}/.local/share/PrismLauncher/"
  '';
}
