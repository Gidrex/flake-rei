{ pkgs, ... }:

let
  yaziPluginsRep = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "49137feda8e140ebd7870292030d89c221cacce8";
    sha256 = "3F7RIg2CZH/jo+XhG0n4Zfspgi/77Hve421j0p3Og+Q=";
  };

  pluginsList = [ "full-border" "max-preview" "jump-to-char" "chmod" "smart-filter" "no-status" /* "mime-ext" */ ];
  plugins = builtins.listToAttrs (map (pluginName: { name = pluginName; value = yaziPluginsRep + "/${pluginName}.yazi"; }) pluginsList);

in
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = plugins;

    settings = {
      concurrency = 2;
      preview = {
        enabled = true;
        image_preloader = false;
        image_delay = 0;
        command = ''
          if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
            onefetch --no-art --no-color-palette --no-title --number-of-authors 0
          fi
        '';
      };
      # plugin.prepend_fetchers = [{
      #   id = "mime";
      #   if = "!mime"; # error, because "if" is nix lang operator :( 
      #   name = "*";
      #   run = "mime-ext";
      #   prio = "high";
      # }];
    };

    initLua = ''
      require("full-border"):setup { type = ui.Border.ROUNDED, }
      require("no-status"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        { on = "T"; run = "plugin --sync max-preview"; desc = "Maximize or restore preview"; }
        { on = "f"; run  = "plugin jump-to-char"; desc = "Jump to char"; }
        { on = "F"; run  = "plugin smart-filter"; desc = "Smart filter"; }
        { on = [ "c" "m" ]; run  = "plugin chmod"; desc = "Chmod on selected files"; }
      ];
    };
  };
}
