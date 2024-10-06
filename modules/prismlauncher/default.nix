{ pkgs, ... }:
let
  prismLauncherThemes = builtins.fetchGit {
    url = "https://github.com/PrismLauncher/Themes.git";
    rev = "main";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
in {
  home.packages = with pkgs; [ prismlauncher ];
 home.file.".local/share/PrismLauncher/Themes".source = prismLauncherThemes;
}
