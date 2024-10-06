{ pkgs, ... }:
let
  Themes = builtins.fetchGit {
    url = "https://github.com/PrismLauncher/Themes.git";
    rev = "0a1fcdba369fa1cccdfdc83aa495b9b239e869b0";
    sha256 = "Jzpb9fgyPYa1NxgFBy8HnHtfy8nORNS4jzMUzNEDFJ8=";
  };
in {
  home.packages = with pkgs; [ prismlauncher ];
 home.file.".local/share/PrismLauncher/Themes".source = Themes;
}
