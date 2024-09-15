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
	extraConfig = "set -g @plugin 'jabirali/tmux-tilish'";
      }
      {
	plugin = resurrect;
	extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
	plugin = continuum;
	extraConfig = "
      set -g @plugin 'tmux-plugins/tmux-continuum'
      # autosave
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10' # minutes 
	  ";
      }

    ];
    extraConfig = ''
    set-option -gas terminal-overrides "*:Tc" # true color support
    set-option -gas terminal-overrides "*:RGB" # true color support
    set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
    set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

    bind -r C-h select-window -t :-
    bind -r C-l select-window -t :+

    resurrect_dir="~/.local/share/tmux/resurrect"

    set -g @plugin 'tmux-plugins/tmux-resurrect'
    set -g @resurrect-strategy-vim 'session'
    set -g @resurrect-strategy-nvim 'session'
    set -g @resurrect-processes 'vim nvim hx cat less more tail watch'
    set -g @resurrect-dir $resurrect_dir
    set -g @resurrect-hook-post-save-all '~/.tmux/post_save.sh $resurrect_dir/last'
    '';
  };

  # Create module script
  home.file.".tmux/post_save.sh" = {
    text = ''
      #!/bin/bash
      sed -ie "s| --cmd .*-vim-pack-dir||g" $1
      sed -i 's|fish	:\[fish\] <defunct>|fish	:|g' $1
      sed -i ':a;N;$!ba;s|\[fish\] <defunct>\n||g' $1
      sed -i "s|/run/current-system/sw/bin/||g" $1
      sed -i "s| $HOME| ~|g" $1
      sed -ie "s|:bash .*/tmp/nix-shell-.*/rc|:nix-shell|g" $1
    '';
    executable = true;
  };
}
