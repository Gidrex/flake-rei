{ pkgs, ... }:

let
  ripdrag = "${pkgs.ripdrag}/bin/ripdrag";

  # Bind func
  mkBind = on: run: desc: { inherit on run desc; };

  # Create relative motion keybindings
  relative-motions = map (num: {
    on = toString num;
    run = "plugin relative-motions ${toString num}";
    desc = "Move ${toString num} steps";
  }) (pkgs.lib.range 1 9);

  # Create tab switching keybindings
  tab-switching = map (num: {
    on = [ "<C-${toString num}>" ];
    run = "tab_switch ${toString (num - 1)}";
    desc = "Switch to tab ${toString num}";
  }) (pkgs.lib.range 1 9);

in
{
  programs.yazi.keymap.mgr.prepend_keymap = [
    (mkBind [ "g" "t" ] "cd ~/gdrive/" "Go to rclone gdrive mount")

    # File operations
    (mkBind [ "e" "D" ] ''shell '${ripdrag} "$@" -x 2>/dev/null &' --confirm''
      "Drag & Drop file with list of selected files"
    )
    (mkBind [
      "e"
      "d"
    ] ''shell '${ripdrag} "$@" -A 2>/dev/null &' --confirm'' "Drag & Drop file all select files as one")
    (mkBind [ "e" "o" ] "shell 'onlyoffice-desktopeditors \"$@\"'" "Open file in onlyoffice")
    (mkBind [ "e" "g" ] "shell --block 'glow -t \"$@\"'" "Open file with glow")

    (mkBind [ "u" ] "plugin restore" "Restore last deleted files/folders")
    (mkBind [ "c" "m" ] "plugin chmod" "Chmod on selected files")
    (mkBind "O" "plugin open-with-cmd block" "Open with command in the terminal")
    (mkBind [ "<C-c>" ] "plugin close-and-restore-tab close_to_right" "Close current tab")
    (mkBind [ "<C-t>" ] "plugin close-and-restore-tab restore" "Restore closed tab")

    # UI controls
    (mkBind [ "T" "t" ] "plugin toggle-pane min-preview" "Hide or show preview")
    (mkBind [ "T" "T" ] "plugin toggle-pane max-preview" "Maximize or restore the preview pane")

    # DuckDB operations
    (mkBind [ "g" "o" ] "plugin duckdb -open" "Open with duckdb")
    (mkBind [ "g" "u" ] "plugin duckdb -ui" "Open with duckdb ui")
    (mkBind "H" "plugin duckdb -1" "Scroll one column to the left")
    (mkBind "L" "plugin duckdb +1" "Scroll one column to the right")
  ]
  ++ relative-motions
  ++ tab-switching;
}
