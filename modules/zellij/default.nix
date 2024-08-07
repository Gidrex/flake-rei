{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      session.hide_status_bar = true;
      default_layout = "compact";
      pane_frames = false;
      mouse_mode = false;
      scroll_buffer_size = 5000;
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
}
