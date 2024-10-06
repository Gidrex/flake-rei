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

    mkdir -p "$PRISM_DIR/catpacks"
    if [ -w "$PRISM_DIR" ]; then
      cp -r ${Themes}/icons "$PRISM_DIR/"
      cp -r ${Themes}/themes "$PRISM_DIR/"
      cp -r ${Themes}/cats/* "$PRISM_DIR/catpacks/"
    else
      echo "Permission denied: Cannot write to $PRISM_DIR"
      exit 1
    fi
  '';

  updateConfig = ''
    PRISM_DIR="${config.home.homeDirectory}/.local/share/PrismLauncher"
    MY_CONFIG=./myprism.cfg
    TARGET_CONFIG="$PRISM_DIR/prismlauncher.cfg"

    if [ -w "$TARGET_CONFIG" ]; then
      awk -F '=' 'NR==FNR { a[$1]=$2; next } $1 in a { $2=a[$1] }1' OFS='=' "$MY_CONFIG" "$TARGET_CONFIG" > "$TARGET_CONFIG.tmp" && mv "$TARGET_CONFIG.tmp" "$TARGET_CONFIG"
    else
      echo "Permission denied: Cannot write to $TARGET_CONFIG"
      exit 1
    fi
  '';

in {
  home.packages = with pkgs; [ prismlauncher ];

  home.activation = {
    copyPrismLauncherThemes = copyThemes;
    updatePrismLauncherConfig = updateConfig;
  };
}
