{ pkgs, ... }:
let inherit (builtins) concatStringsSep genList listToAttrs;

in {
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins;
      map (plugin: {
        name = plugin.pname;
        src = plugin.src;
      }) [ tide colored-man-pages ];

    functions.gd = (builtins.readFile ./gd_function.fish);

    shellAliases =
      # alias for .. , ... , .... and others
      listToAttrs (map (dots: {
        name = concatStringsSep "" (genList (_: ".") dots);
        value = "cd ${concatStringsSep "/" (genList (_: "..") (dots - 1))}";
      }) (genList (i: i + 2) 5)) //

      # Base aliaeses
      {
        ls = "eza";
        la = "ls -al";
        md = "mkdir -p";
        h = "hx";

        # zellij
        zl = "zellij";
        zla = "zellij attach $(zellij ls -s | fzf)";
        zln = "zellij --session";
        zlk = "zl kill-session $(zellij ls -s | fzf)";

        # flake scripts
        rbn = "FLAKE_BACKUP=0 ~/flake-rei/assets/scripts/flake_rebuild.sh";
        rb = "FLAKE_BACKUP=1 ~/flake-rei/assets/scripts/flake_rebuild.sh";
        hm = "home-manager switch --flake ~/flake-rei/#$FLAKE_MACHINE";

        # my custom scripts
        nt =
          "rclone copy gdrive:notes/ ~/Notes/ -u -P --fast-list --checkers 32 --transfers 16 && $EDITOR ~/Notes/ && rclone sync ~/Notes/ gdrive:notes/ -u --fast-list --checkers 32 --transfers 16 > /dev/null 2>&1 & disown";
      };

    # apply per every term session
    interactiveShellInit = ''
      function fish_greeting
      end
      fish_hybrid_key_bindings
      rip completions fish | source

      function helixing
        set -l selection (fd . --type file --type symlink -E '*.{png,jpg,jpeg,webp,docx,svg,pdf}' | fzf --height=20 --layout=reverse --walker=file,hidden,follow -0 -1)
        test -n "$selection" && hx "$selection" || echo ""
      end

      bind -M insert \ez 'commandline -f cancel; z $(zoxide query -l | fzf --height=20 --layout=reverse); commandline -f repaint'
      bind -M insert \et 'commandline -f cancel; z ..; commandline -f repaint'
      bind -M insert \eh 'commandline -f cancel; helixing; commandline -f repaint'
      bind -M insert \ey 'commandline -f cancel; yazi; commandline -f repaint'
      bind -M insert \ea 'commandline -f cancel; claude "/resume"; commandline -f repaint'
      bind -M insert \ex 'commandline -f cancel; lazygit; commandline -f repaint'
    '';
    loginShellInit = ''
      tide configure --auto --style=Classic --prompt_colors='16 colors' --show_time=No --classic_prompt_separators=Round --powerline_prompt_heads=Round --powerline_prompt_tails=Round --powerline_prompt_style='Two lines, character' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
    '';

  };

  catppuccin.fish.enable = true;

  programs = {
    zellij.enableFishIntegration = false;
    zoxide.enableFishIntegration = true;
    yazi.enableFishIntegration = true;
  };

  xdg.configFile."fish/completions/gd.fish".text =
    (builtins.readFile ./gd_completion.fish);
}
