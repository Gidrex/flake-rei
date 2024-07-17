{ pkgs, ... }: 
{
programs.tmux = {
  enable = true;
  baseIndex = 1;
  clock24 = true;
  keyMode = "vi";
  shortcut = "a";
  terminal = "screen-256color";
  mouse = true;
  historyLimit = 5000;
  disableConfirmationPrompt = true;
  customPaneNavigationAndResize = true;
  tmuxinator.enable = true;

  plugins = with pkgs.tmuxPlugins; [
  {
    plugin = catppuccin;
    extraConfig = ''
      set -g @plugin 'catppuccin/tmux'
      set -g @tilish-navigate 'on'
    '';
  }
  {
    plugin = tilish;
    extraConfig = ''
      set -g @plugin 'jabirali/tmux-tilish'
    '';
  }
  {
    plugin = net-speed;
    extraConfig = ''
      set -g @plugin 'tmux-plugins/tmux-net-speed'
      # set -g status-right 'Up: #{net_speed_up} Down: #{net_speed_down}'
    '';
  }
  {
    plugin = resurrect;
    extraConfig = ''
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      '';
  }
  {
    plugin = continuum;
    extraConfig = ''
      set -g @plugin 'tmux-plugins/tmux-continuum'

      # autosave
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10' # minutes 
      '';
  }

  ];
  extraConfig = ''
    set-option -gas terminal-overrides "*:Tc" # true color support
    set-option -gas terminal-overrides "*:RGB" # true color support
    set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
    set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

    bind -r C-h select-window -t :-
    bind -r C-l select-window -t :+
    '';
};
}
