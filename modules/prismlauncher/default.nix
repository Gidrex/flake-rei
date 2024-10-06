{ pkgs, ... }:
let
  prismLauncherThemes = builtins.fetchGit {
    url = "https://github.com/PrismLauncher/Themes.git";
    rev = "main";
    sha256 = "Jzpb9fgyPYa1NxgFBy8HnHtfy8nORNS4jzMUzNEDFJ8=";
  };
in {
  home.packages = with pkgs; [ prismlauncher ];
 home.file.".local/share/PrismLauncher/Themes".source = prismLauncherThemes;
}
