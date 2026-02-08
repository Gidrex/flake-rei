{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) concatStringsSep genList listToAttrs;
in
{
  programs.fish = {
    enable = true;
    plugins =
      with pkgs.fishPlugins;
      map
        (plugin: {
          name = plugin.pname;
          src = plugin.src;
        })
        [
          tide
          colored-man-pages
        ];

    functions =
      (lib.mapAttrs
        (name: fullCmd: {
          body = "${fullCmd} $argv";
          wraps = lib.head (lib.splitString " " (lib.last (lib.splitString "/" fullCmd)));
        })
        {
          # Simple fuctions (instead of using alias)
          ls = "${pkgs.eza}/bin/eza -D1 --color=always --icons=always $argv | psub) (${pkgs.eza}/bin/eza -f1 --color=always --icons=always $argv | psub) | column -t -s \t";
          la = "${pkgs.eza}/bin/eza -al";
          lt = "${pkgs.eza}/bin/eza -T";
          md = "mkdir -p";
          h = "${pkgs.helix}/bin/hx";
          zl = "zellij";
          zln = "zellij --session";
        }
      )
      // (lib.mapAttrs (_: body: { inherit body; }) {
        gd = builtins.readFile ./gd_function.fish;
        e = "$EDITOR $argv";

        # zellij
        zla = "zellij attach $(${pkgs.zellij}/bin/zellij ls -s | ${pkgs.fzf}/bin/fzf) $argv";
        zlk = "zellij kill-session $(${pkgs.zellij}/bin/zellij ls -s | ${pkgs.fzf}/bin/fzf) $argv";

        # my custom scripts
        nt = "rclone copy gdrive:notes/ ~/Notes/ -u -P --fast-list --checkers 32 --transfers 16 && $EDITOR ~/Notes/ && rclone sync ~/Notes/ gdrive:notes/ -u --fast-list --checkers 32 --transfers 16 > /dev/null 2>&1 & disown";
        hm = "home-manager switch --flake ~/flake-rei/#$FLAKE_MACHINE";
      })
      // listToAttrs (
        map (dots: {
          name = concatStringsSep "" (genList (_: ".") dots);
          value = {
            body = "cd ${concatStringsSep "/" (genList (_: "..") (dots - 1))} $argv";
            wraps = "cd";
          };
        }) (genList (i: i + 2) 5)
      );

    # apply per every term session
    interactiveShellInit = ''
      set -g fish_greeting ""
      set -g fish_key_bindings fish_hybrid_key_bindings

      ${pkgs.rip2}/bin/rip completions fish | source

      function helixing
        set -l selection (${pkgs.fd}/bin/fd . --type file --type symlink -E '*.{png,jpg,jpeg,webp,docx,svg,pdf}' | ${pkgs.fzf}/bin/fzf --height=20 --layout=reverse --walker=file,hidden,follow -0 -1)
        test -n "$selection" && ${pkgs.helix}/bin/hx "$selection" || echo ""
      end

      ${lib.optionalString config.programs.zoxide.enable "bind -M insert \ez 'commandline -f cancel; ${pkgs.zoxide}/bin/z $(${pkgs.zoxide}/bin/zoxide query -l | ${pkgs.fzf}/bin/fzf --height=20 --layout=reverse); commandline -f repaint'"}
      ${lib.optionalString config.programs.zoxide.enable "bind -M insert \et 'commandline -f cancel; ${pkgs.zoxide}/bin/z ..; commandline -f repaint'"}
      ${lib.optionalString config.programs.helix.enable "bind -M insert \ee 'commandline -f cancel; helixing; commandline -f repaint'"}
      ${lib.optionalString config.programs.yazi.enable "bind -M insert \ey 'commandline -f cancel; ${pkgs.yazi}/bin/yazi; commandline -f repaint'"}
      ${lib.optionalString config.programs.lazygit.enable "bind -M insert \ex 'commandline -f cancel; ${pkgs.lazygit}/bin/lazygit; commandline -f repaint'"}
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

  xdg.configFile."fish/completions/gd.fish".text = (builtins.readFile ./gd_completion.fish);
}
