{ pkgs, config, ... }:
let
  Themes = pkgs.fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "Themes";
    rev = "main";
    sha256 = "Jzpb9fgyPYa1NxgFBy8HnHtfy8nORNS4jzMUzNEDFJ8=";
  };

  rustCompareFiles = pkgs.rustPlatform.buildRustPackage {
    pname = "compare-files";
    version = "0.1.0";
    src = ./compare;
    cargoSha256 = "0000000000000000000000000000000000000000000000000000";
  };

in {
  home.packages = with pkgs; [ prismlauncher ];

  home.activation.copyPrismLauncherThemes = ''
    PRISM_DIR="${config.home.homeDirectory}/.local/share/PrismLauncher"

    cp -rn ${Themes}/icons "$PRISM_DIR/"
    cp -rn ${Themes}/themes "$PRISM_DIR/"
    cp -rn ${Themes}/cats/* "$PRISM_DIR/catpacks/"
  '';
}
