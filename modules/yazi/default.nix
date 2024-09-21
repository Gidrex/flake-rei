{ pkgs, ... }:

let
  yaziPluginsRep = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "49137feda8e140ebd7870292030d89c221cacce8";
    sha256 = "3F7RIg2CZH/jo+XhG0n4Zfspgi/77Hve421j0p3Og+Q=";
  };

  pluginPath = pluginName: yaziPluginsRep + "/${pluginName}.yazi";

in
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    plugins = {
      full-border = pluginPath "full-border";
      max-preview = pluginPath "max-preview";
    };

    initLua = ''
      require("full-border"):setup { type = ui.Border.ROUNDED, }
    '';

    keymap = {
      manager.prepend_keymap = [
        { on = "T"; run = "plugin --sync max-preview"; desc = "Maximize or restore preview"; }
      ];
    };
  };
}
