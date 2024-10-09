{ pkgs, config, ... }:

let
  sessionTree = pkgs.fetchurl {
    url = "https://github.com/laperlej/zellij-sessionizer/releases/download/v0.4.0/zellij-sessionizer.wasm";
    sha256 = "8ZQ1br0moNAaj/eSBSKbz3hP6sYTTix0uNQXk77C0Hc=";
  };

in
  {
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;

    settings = {
      # session.hide_status_bar = true; # what?
      default_layout = "compact";
      pane_frames = false;
      mouse_mode = true;
      auto_layout = false;

      theme = "Catppuccin";
      themes.Catppuccin = {
        fg = "#D9E0EE";
        bg = "#1E1E2E";
        black = "#1E1E2E";
        red = "#f0658f";
        green = "#ABE9B3";
        yellow = "#FAE3B0";
        orange = "#FAB387";
        blue = "#96CDFB";
        magenta = "#DDB6F2";
        cyan = "#89DCEB";
        white = "#C3BAC6";
        bright_black = "#585B70";
        bright_red = "#F28FAD";
        bright_green = "#ABE9B3";
        bright_yellow = "#FAE3B0";
        bright_blue = "#96CDFB";
        bright_magenta = "#DDB6F2";
        bright_cyan = "#89DCEB";
        bright_white = "#D9E0EE";
      };
    };
  };

  # Plugins setup
  home = {
    activation.makeDir = ''mkdir -p ${config.home.homeDirectory}/.config/zellij/plugins'';
    file.".config/zellij/plugins/zellij-session-tree.wasm".source = sessionTree;
  };
}

