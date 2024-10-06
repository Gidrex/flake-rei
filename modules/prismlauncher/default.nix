{ pkgs, config, ... }:
let
  Themes = pkgs.fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "Themes";
    rev = "main";
    sha256 = "Jzpb9fgyPYa1NxgFBy8HnHtfy8nORNS4jzMUzNEDFJ8=";
  };

  copyThemes = ''
    PRISM_DIR="${config.home.homeDirectory}/.local/share/PrismLauncher"

    cp -rn ${Themes}/{icons,themes} "$PRISM_DIR/"
    cp -rn ${Themes}/cats/* "$PRISM_DIR/catpacks/"
  '';

  updateConfig = ''
    PRISM_DIR="${config.home.homeDirectory}/.local/share/PrismLauncher"
    MY_CONFIG=./myprism.cfg
    TARGET_CONFIG="$PRISM_DIR/prismlauncher.cfg"

    awk -F '=' 'NR==FNR { a[$1]=$2; next } $1 in a { $2=a[$1] }1' OFS='=' "$MY_CONFIG" "$TARGET_CONFIG" > "$TARGET_CONFIG.tmp"
    mv "$TARGET_CONFIG.tmp" "$TARGET_CONFIG"
  '';

in {
  home.packages = with pkgs; [ prismlauncher ];

  home.activation = {
    copyPrismLauncherThemes = copyThemes;
    updatePrismLauncherConfig = updateConfig;
  };
}
