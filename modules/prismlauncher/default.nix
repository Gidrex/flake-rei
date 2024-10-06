{ pkgs, config, ... }:
let
  Themes = pkgs.fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "Themes";
    rev = "main";
    sha256 = "Jzpb9fgyPYa1NxgFBy8HnHtfy8nORNS4jzMUzNEDFJ8=";
  };

  # Custom Rust script for manage cfg
  rustCompareFiles = pkgs.rustPlatform.buildRustPackage {
    pname = "compare-files";
    version = "0.1.0";
    src = ./compare;
    cargoSha256 = "BCS/3e9gZeoc2hJ+goA5H13lrEjBACFTYIzx0bcNwkM=";
  };
  runCompareFiles = pkgs.writeShellScriptBin "run-compare-files" ''
    #!/usr/bin/env bash
    FILE1="$1"
    FILE2="$2"

    if [ -z "$FILE1" ] || [ -z "$FILE2" ]; then
    exit 1
    fi

    ${rustCompareFiles}/bin/compare-files "$FILE1" "$FILE2"
    '';

in {
  home.packages = with pkgs; [ prismlauncher ];

  home.activation.copyPrismLauncherThemes = ''
    PRISM_DIR="${config.home.homeDirectory}/.local/share/PrismLauncher"

    cp -rn ${Themes}/icons "$PRISM_DIR/"
    cp -rn ${Themes}/themes "$PRISM_DIR/"
    cp -rn ${Themes}/cats/* "$PRISM_DIR/catpacks/"

    ${rustCompareFiles}/bin/compare-files ~/flake-rei/modules/prismlauncher/myprism.cfg "$PRISM_DIR/prismlauncher.cfg"
  '';
}
