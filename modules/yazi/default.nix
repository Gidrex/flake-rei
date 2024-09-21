{ pkgs, yazi, nixpkgs, ... }:

let
  yaziPluginsRep = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "49137feda8e140ebd7870292030d89c221cacce8";
    sha256 = "3F7RIg2CZH/jo+XhG0n4Zfspgi/77Hve421j0p3Og+Q=";
  };

  pluginsList = [ "full-border" "max-preview" "jump-to-char" ];
  plugins = builtins.listToAttrs (map (pluginName: { name = pluginName; value = yaziPluginsRep + "/${pluginName}.yazi"; }) pluginsList);

in
{
  programs.yazi.package = yazi.packages.${nixpkgs.system}.default;
  nix.settings.extra-substituters = [ "https://yazi.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  nixpkgs.overlays = [ yazi.overlays.default ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = plugins;

    initLua = ''
      require("full-border"):setup { type = ui.Border.ROUNDED, }
    '';
    keymap = {
      manager.prepend_keymap = [
        { on = "T"; run = "plugin --sync max-preview"; desc = "Maximize or restore preview"; }
        { on = "f"; run  = "plugin jump-to-char"; desc = "Jump to char"; }
      ];
    };
  };
}
