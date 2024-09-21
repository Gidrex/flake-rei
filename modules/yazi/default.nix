{ pkgs, lib, ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    plugins = {
      full-border = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        sha256 = lib.fakeSha256;
      } + "/full-border.yazi";
    };

    initLua = ''
      -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
        require("full-border"):setup { type = ui.Border.PLAIN, }
    '';
  };
}
