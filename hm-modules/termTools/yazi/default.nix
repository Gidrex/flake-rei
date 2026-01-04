{ pkgs, lib, config, yazi-plugins, ... }:
let
  # Plugin helpers
  mkPreviewer = run: name: { inherit name run; };
  mkPreloader = run: name: {
    inherit name run;
    multi = false;
  };

  # Eza ignore patterns
  ezaIgnore = [ "__pycache__" "*.egg-info" ];
  mkIgnoreGlob = patterns: "-I '${lib.concatStringsSep "|" patterns}'";

in {
  imports = [ ./keymaps.nix ];

  home.packages = with pkgs;
    lib.mkIf config.programs.yazi.enable [
      trash-cli # requirements for boydaihungst/restore.yazi
    ];

  programs.yazi = {
    shellWrapperName = "y";

    # Plugins init
    plugins = {
      inherit (pkgs.yaziPlugins)
        chmod full-border toggle-pane piper relative-motions restore mediainfo
        duckdb;
      inherit (yazi-plugins) open-with-cmd close-and-restore-tab;
    };

    settings = {
      concurrency = 2;
      preview = {
        enabled = true;
        image_preloader = false;
        image_delay = 0;
      };
      mgr.ratio = [ 1 2 5 ];
      plugin.prepend_preloaders = (map (mkPreloader "duckdb") [
        "*.csv"
        "*.tsv"
        "*.json"
        "*.parquet"
        "*.txt"
        "*.xlsx"
      ])
      # preview for images, video, audio
        ++ (map (mkPreloader "mediainfo") [
          "{audio,video,image}/*"
          "application/subrip"
          "application/postscript"
        ]);

      plugin.prepend_previewers =
        # preview with render fancy tables
        (map (mkPreviewer "duckdb") [
          "*.csv"
          "*.tsv"
          "*.json"
          "*.parquet"
          "*.txt"
          "*.xlsx"
          "*.db"
          "*.duckdb"
        ]) ++ (map (name: {
          inherit name;
          run = "mediainfo";
        }) [
          "{audio,video,image}/*"
          "application/subrip"
          "application/postscript"
        ]) ++ [
          {
            mime = "inode/directory";
            run = "piper -- ${pkgs.eza}/bin/eza --tree --level=3 --color=always --icons=always --group-directories-first --no-quotes ${mkIgnoreGlob ezaIgnore} {}";
          }
          {
            name = "*.md";
            run = ''
              piper -- CLICOLOR_FORCE=1 ${pkgs.glow}/bin/glow -w=$w -s=dark "$1"
            '';
          }
        ];
      tasks.image_alloc = 1073741824; # 1 Gb
    };

    initLua = ''
      require("relative-motions"):setup({
        show_numbers = "relative_absolute",
        show_motion = true
      })

      require("duckdb"):setup({
        mode = "summarized",
        cache_size = 1000,
        row_id = "dynamic",
        minmax_column_width = 21,
        column_fit_factor = 10.0
      })

      require("full-border"):setup { type = ui.Border.ROUNDED }
    '';
  };

  xdg.configFile."yazi/vfs.toml".text = ''
    [services.cloud]
    type = "rclone"
    remote = "gdisk"
  '';
}
# Doc
# https://github.com/wylie102/duckdb.yazi
