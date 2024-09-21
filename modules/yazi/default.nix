{ pkgs, ... }:
{
    yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins = {
        full-border = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "main";
          sha256 = "3F7RIg2CZH/jo+XhG0n4Zfspgi/77Hve421j0p3Og+Q=";
        } + "/full-border.yazi";
      };
      initLua = ''
      -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
        require("full-border"):setup { type = ui.Border.ROUNDED, }
      '';
    };
}
