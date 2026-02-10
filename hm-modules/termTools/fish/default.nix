{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) concatStringsSep genList listToAttrs;

  # Universal mapper for functions
  mkFunc =
    name: val:
    let
      isDots = lib.hasPrefix "." name;
      spec = if lib.isString val then { body = val; } else val;
      # Automatically add $argv if not present in the body
      finalBody = if lib.hasInfix "$argv" spec.body then spec.body else "${spec.body} \$argv";
    in
    {
      inherit name;
      value =
        (lib.filterAttrs (n: v: n != "description") spec)
        // {
          body = finalBody;
        }
        // (lib.optionalAttrs isDots { wraps = "cd"; });
    };
in
{
  programs.fish = {
    enable = true;
    shellAliases = lib.mkForce { };

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
      listToAttrs (
        lib.mapAttrsToList mkFunc {
          # Wrappers
          ls = {
            body = "__eza_cols";
            wraps = "eza";
          };
          la = {
            body = "__eza_cols -al";
            wraps = "eza";
          };
          lt = {
            body = "__eza_cols -T";
            wraps = "eza";
          };
          md = {
            body = "mkdir -p";
            wraps = "mkdir";
          };
          h = {
            body = "${pkgs.helix}/bin/hx";
            wraps = "hx";
          };
          zl = {
            body = "zellij";
            wraps = "zellij";
          };
          zln = {
            body = "zellij --session";
            wraps = "zellij";
          };

          # Direct commands
          e = "$EDITOR";
          gd = builtins.readFile ./gd_function.fish;

          zla = "zellij attach $(${pkgs.zellij}/bin/zellij ls -s | ${pkgs.fzf}/bin/fzf)";
          zlk = "zellij kill-session $(${pkgs.zellij}/bin/zellij ls -s | ${pkgs.fzf}/bin/fzf)";
          nt = "rclone copy gdrive:notes/ ~/Notes/ -u -P --fast-list --checkers 32 --transfers 16 && $EDITOR ~/Notes/ && rclone sync ~/Notes/ gdrive:notes/ -u --fast-list --checkers 32 --transfers 16 > /dev/null 2>&1 & disown";
          hm = "home-manager switch --flake ~/flake-rei/#$FLAKE_MACHINE";

          # Logic
          __eza_cols = "if contains -- -T \$argv; or contains -- --tree \$argv; or test (count \$argv) -gt 1; ${pkgs.eza}/bin/eza --icons=always \$argv; else; CLICOLOR_FORCE=1 paste (${pkgs.eza}/bin/eza --only-dirs -1 --color=always --icons=always \$argv | psub) (${pkgs.eza}/bin/eza --only-files -1 --color=always --icons=always \$argv | psub) | column -t -s \\t; end";

          helixing = ''
            set -l selection (${pkgs.fd}/bin/fd . --type file --type symlink -E '*.{png,jpg,jpeg,webp,docx,svg,pdf}' | ${pkgs.fzf}/bin/fzf --height=20 --layout=reverse --walker=file,hidden,follow -0 -1)
            test -n "$selection" && ${pkgs.helix}/bin/hx "$selection" || echo ""
          '';
        }
      )
      // listToAttrs (
        map (
          dots:
          mkFunc (concatStringsSep "" (genList (_: ".") dots))
            "cd ${concatStringsSep "/" (genList (_: "..") (dots - 1))}"
        ) (genList (i: i + 2) 5)
      );

    interactiveShellInit = ''
      set -g fish_greeting ""
      set -g fish_key_bindings fish_hybrid_key_bindings
      ${lib.optionalString config.programs.zoxide.enable "bind -M insert \\ez 'commandline -f cancel; z $(${pkgs.zoxide}/bin/zoxide query -l | ${pkgs.fzf}/bin/fzf --height=20 --layout=reverse); commandline -f repaint'"}
      ${lib.optionalString config.programs.zoxide.enable "bind -M insert \\et 'commandline -f cancel; z ..; commandline -f repaint'"}
      ${lib.optionalString config.programs.helix.enable "bind -M insert \\ee 'commandline -f cancel; helixing; commandline -f repaint'"}
      ${lib.optionalString config.programs.yazi.enable "bind -M insert \\ey 'commandline -f cancel; ${pkgs.yazi}/bin/yazi; commandline -f repaint'"}
      ${lib.optionalString config.programs.lazygit.enable "bind -M insert \\ex 'commandline -f cancel; ${pkgs.lazygit}/bin/lazygit; commandline -f repaint'"}
    '';

    loginShellInit = "tide configure --auto --style=Classic --prompt_colors='16 colors' --show_time=No --classic_prompt_separators=Round --powerline_prompt_heads=Round --powerline_prompt_tails=Round --powerline_prompt_style='Two lines, character' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_spacing=Sparse --icons='Many icons' --transient=Yes";

    completions = {
      gd = builtins.readFile ./gd_completion.fish;
      rip = builtins.readFile (
        pkgs.runCommand "rip-completions" { } "${pkgs.rip2}/bin/rip completions fish > $out"
      );
    };
  };

  catppuccin.fish.enable = true;

  programs = {
    zellij.enableFishIntegration = false;
    zoxide.enableFishIntegration = true;
    yazi.enableFishIntegration = true;
    eza.enableFishIntegration = false;
  };
}
