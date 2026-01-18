{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./lsp.nix

  ];

  programs.helix = {
    ignores = [
      ".build/"

      # image
      "*.png"
      "*.jpg"
      "*.jpeg"
      "*.svg"
      "*.webp"

      # doc
      "*.docx"
      "*.pdf"
    ]; # .ignore and .git/ already included

    settings = {
      theme = lib.mkDefault "catppuccin_mocha";

      editor = {
        line-number = "relative";
        bufferline = "never";
        default-line-ending = "lf";
        cursorline = true;
        auto-info = true;
        color-modes = true;
        # rulers = [ 120 ];
        mouse = false;
        continue-comments = false;
        completion-replace = true;
        insert-final-newline = false;
        popup-border = "popup";

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        soft-wrap = {
          enable = true;
          # max-wrap = 120;
          wrap-at-text-width = false;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-modification-indicator"
            "read-only-indicator"
          ];
          center = [
            "version-control"
            "file-name"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
          ];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "-- INSERT --";
            select = "-- SELECT --";
          };
        };

        indent-guides = {
          render = true;
          character = "▏";
        };
      };
      keys = {
        normal = {
          S-z = lib.mkIf config.programs.lazygit.enable [
            ":new"
            ":insert-output ${pkgs.lazygit}/bin/lazygit"
            ":buffer-close!"
            ":redraw"
          ];
          C-y = lib.mkIf config.programs.yazi.enable [
            ":sh rm -f /tmp/yazi-path"
            ":insert-output ${pkgs.yazi}/bin/yazi %{buffer_name} --chooser-file=/tmp/yazi-path"
            ":open %sh{cat /tmp/yazi-path}"
            ":redraw"
            ":reload-all"
            ":set mouse false"
            ":set mouse true"
          ];
          A-w = ":w";
          A-q = ":q";
          space.space = ":reload-all";
          space.q = ":pipe ${pkgs.libqalculate}/bin/qalc -s 'maxdeci 2' -t -f /dev/stdin";
        };
      };
    };
  };
}
