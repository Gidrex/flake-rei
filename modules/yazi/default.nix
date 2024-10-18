{ pkgs, ... }:

let
  yaziPluginsRep = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "49137feda8e140ebd7870292030d89c221cacce8";
    sha256 = "3F7RIg2CZH/jo+XhG0n4Zfspgi/77Hve421j0p3Og+Q=";
  };

  pluginsList = [ /*"full-border"*/ "max-preview" "jump-to-char" "chmod" "smart-filter" "no-status" "hide-preview" ];
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
      };

      reveal = [
        { run = "xdg-open \"$(dirname '$1')\""; desc = "Reveal"; for = "linux"; }
        { run = "${pkgs.exiftool}/bin/exiftool \"$1\"; echo 'Press enter to exit'; read _"; block = true; desc = "Show EXIF"; for = "unix"; }
      ];
    };

    initLua = ''
      -- require("full-border"):setup { type = ui.Border.ROUNDED, }
      require("no-status"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        { on = "T"; run = "plugin --sync max-preview"; desc = "Maximize or restore preview"; }
        { on = "f"; run  = "plugin jump-to-char"; desc = "Jump to char"; }
        { on = "F"; run  = "plugin smart-filter"; desc = "Smart filter"; }
        { on = [ "c" "m" ]; run  = "plugin chmod"; desc = "Chmod on selected files"; }
        { on = [ "g" "r" ]; run = ''shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm''; desc = "back to the root of repository"; }
        { on   = [ "e" "t" ]; run  = "plugin --sync hide-preview"; desc = "Hide or show preview"; }
        { on = [ "e" "d" ]; run  = ''shell 'dragon -T "$@"' --confirm''; desc = "Drag & Drop file"; }
        { on = ["e" "e" ]; run = "shell '$1'"; desc = "Open selected file with custom command"; }
      ];
    };
  };
}
