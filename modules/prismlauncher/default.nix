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
    TARGET_DIR="${config.home.homeDirectory}/.local/share/PrismLauncher"
    mkdir -p "$TARGET_DIR"

    if [ ! -d "$TARGET_DIR/icons" ]; then
      cp -r ${Themes}/icons "$TARGET_DIR/"
    fi

    if [ ! -d "$TARGET_DIR/themes" ]; then
      cp -r ${Themes}/themes "$TARGET_DIR/"
    fi
  '';
}
