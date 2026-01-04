{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkDefault mkForce strings;
  inherit (strings) toUpper toLower;
  inherit (builtins) pathExists substring stringLength;

  username = "gidrex";
  Username = toUpper (substring 0 1 username) + toLower
    (substring 1 (stringLength username - 1) username); # gidrex -> Gidrex
  name = "Alexander";
  mail = "Desench@proton.me";

in {
  nix = {
    package = mkDefault pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Programs
  programs = {
    zoxide.enable = true;
    home-manager.enable = true;
    nix-your-shell.enable = true;
    fish.enable = true;
    helix.enable = true;
    yazi = {
      enable = true;
      package = pkgs.yazi;
    };
    zellij.enable = true;
    # less.enable = true;

    fastfetch.enable = true;
    lazygit = {
      enable = true;
      settings.gui.nerdFontsVersion = "3";
    };

    imv = {
      settings.options = {
        list_files_at_exit = true;
        overlay_font = "Monospace:14";
      };
    };

    aria2 = {
      enable = true;
      settings = {
        # enable-rpc = true;
        # rpc-listen-all = false;
        # rpc-listen-port = 6800;
        max-concurrent-downloads = 5;
        continue = true;
        max-connection-per-server = 16;
        min-split-size = "10M";
        split = 10;
      };
    };

    btop = {
      enable = true;
      settings = {
        color_theme = mkForce "horizon";
        show_gpu_info = true;
        vim_keys = true;
        proc_sorting = "memory";
        proc_gradient = false;
        proc_per_core = false;
        graph_symbol = "block";
        graph_symbol_cpu = "braille";
        graph_symbol_net = "braille";
        show_battery = false;
      };
    };

    fzf = {
      enable = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
    };

    fd = {
      enable = true;
      extraOptions = [ "--absolute-path" ];
      ignores = [ ".git/" ];
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--colors=line:style:bold"
        "--colors=match:fg:yellow"
        "--colors=match:style:bold"
        "--colors=path:fg:cyan"
        "--colors=path:style:bold"
        "--smart-case"
        "--hidden"
        "--follow"
        "--heading"
        "--with-filename"
      ];
    };

    eza = {
      enable = true;
      icons = "auto";
      git = true;
      extraOptions = [ "--oneline" "--group-directories-first" ];
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "${Username}";
        user.email = "${mail}";
        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autostash = true;
        rebase.autosquash = true;
        push.autoSetupRemote = true;
        commit.gpgsign = false;
        rerere.enabled = true;
        user.signingkey = "~/.ssh/id_rsa.pub";
        core.whitespace = "trailing-space,space-before-tab";
        core.editor = "hx";
        safe = mkIf (pathExists "/opt/flutter") { directory = "/opt/flutter"; };
      };
    };

    # not included: optionaly
    zathura.options = {
      font = "SauceCodePro Nerd Font Mono 14";
      selection-clipboard = "clipboard";
      statusbar-home-tilda = true;
      guioptions = "";
    };

    onlyoffice.settings = {
      UITheme = "theme-dark";
      editorWindowMode = false;
      maximized = true;
      titlebar = "none";
    };

    pandoc.defaults = {
      metadata.author = "${name}";
      pdf-engine = "xelatex";
      citeproc = true;
    };

    foot.settings = {
      main = {
        shell = mkIf config.programs.fish.enable "${pkgs.fish}/bin/fish";
        pad = "0x0";
        dpi-aware = "yes";
      };
      cursor = {
        style = "beam";
        blink = "no";
      };
      scrollback.lines = 10000;
      mouse.hide-when-typing = "yes";
    };

    ghostty = {
      installVimSyntax = true;
      settings = {
        font-size = 14;
        shell-integration = mkIf config.programs.fish.enable "fish";
        window-padding-x = 0;
        window-padding-y = 0;
        cursor-style = "bar";
        cursor-style-blink = false;
        scrollback-limit = 10000;
        mouse-hide-while-typing = true;
      };
    };
  };

  # global theaming if enabled
  catppuccin = {
    flavor = "mocha";
    accent = "blue";
    gtk = {
      icon.enable = true;
      icon.accent = "sky";
    };
  };

  qt = {
    platformTheme.name = mkIf config.catppuccin.enable "kvantum";
    style.name = "kvantum";
    style.package = pkgs.libsForQt5.qtstyleplugins;
  };

  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs;
      [
        # utility
        unrar
        nix-prefetch-github
        rip2
        glow
        ripdrag
        ueberzugpp
        poppler
        chafa
        mediainfo
        hexyl
        duckdb
        libqalculate

        # fancy
        gum

        # web
        bind.dnsutils # provides dig and host
        speedtest-cli
        ipfetch

        # dev
        lazydocker
        mosquitto
        deno

        # apps
        feh

        # fonts
      ] ++ (with nerd-fonts; [
        arimo
        caskaydia-mono
        symbols-only
        sauce-code-pro
        jetbrains-mono
      ]) ++ [ times-newer-roman ];

    sessionVariables = builtins.listToAttrs (map (name: {
      inherit name;
      value = mkIf config.programs.helix.enable "hx";
    }) [ "EDITOR" "VISUAL" ]) // {

      SHELL = mkIf config.programs.fish.enable "fish";
      TERM = mkIf config.programs.foot.enable "foot";

      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    };

    sessionPath = [
      "$HOME/.volta/bin"
      "$HOME/.cargo/bin"
      "$HOME/go/bin"
      "$HOME/.local/bin"
      "$HOME/.nix-profile/bin"
      "$HOME/.npm-global/bin"
      "/usr/bin"
      "/opt/flutter/bin"
    ];

    username = "${username}";
    homeDirectory = "/home/${username}";

    enableNixpkgsReleaseCheck = false;
    stateVersion = "25.05";
  };

  xdg.configFile."glow/glow.yml".text = ''
    style: "tokyo-night"
    width: 130
    mouse: false
  '';

  news.display = "silent";
}
