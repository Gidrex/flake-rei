{ pkgs, lib, ... }:
let
  prismLauncherThemes = builtins.fetchGit {
    url = "https://github.com/PrismLauncher/Themes.git";
    rev = "main";
    sha256 = lib.fakeSha256;
  };
in {
  home.packages = with pkgs; [ prismlauncher ];
 home.file.".local/share/PrismLauncher/Themes".source = prismLauncherThemes;
}
