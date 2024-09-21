{ pkgs, ... }:

let
  yaziPluginsRep = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "49137feda8e140ebd7870292030d89c221cacce8";
    sha256 = "3F7RIg2CZH/jo+XhG0n4Zfspgi/77Hve421j0p3Og+Q=";
  };
in
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    plugins = {
      full-border = yaziPluginsRep + "/full-border.yazi";
      max-preview = yaziPluginsRep + "/max-preview.yazi";
    };

    initLua = ''
      -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
        require("full-border"):setup { type = ui.Border.ROUNDED, }
    '';
  };
}
