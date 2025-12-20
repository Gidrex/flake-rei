{ pkgs, lib, config, ... }:
let
  mkBind = key: mode: {
    bind = {
      _args = [ key ];
      SwitchToMode._args = [ mode ];
    };
  };

  mkMode = mode: binds: { ${mode}._children = binds; };

in {
  catppuccin.zellij.flavor = "macchiato";

  imports = [ ./plugins/zjstatus.nix ];

  home.packages = lib.mkIf config.programs.zellij.enable (with pkgs; [
    tmate
    sesh

  ]);

  programs.zellij.settings = {
    show_startup_tips = false;
    mouse_mode = false;
    default_layout = "custom";
    ui = { pane_frames = { rounded_corners = true; }; };

    # binds
    keybinds._children = [
      { unbind._args = [ "Ctrl b" "Ctrl o" "Ctrl s" "Ctrl g" ]; }
      (mkMode "locked" [ (mkBind "Ctrl Enter" "Normal") ])
      (mkMode "scroll" [ (mkBind "Ctrl d" "Normal") ])
      (mkMode "normal" ([
        (mkBind "Ctrl i" "Session")
        (mkBind "Ctrl d" "Scroll")
        (mkBind "Ctrl Enter" "Locked")
      ]
      # alt + [1:9] for switch tabs
        ++ (lib.genList (i:
          let tabNum = i + 1;
          in {
            bind = {
              _args = [ "Alt ${toString tabNum}" ];
              GoToTab._args = [ tabNum ];
            };
          }) 9)))
    ];

  } // lib.optionalAttrs config.programs.fish.enable {
    default_shell = "fish";
  };
}
