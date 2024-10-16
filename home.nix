{  pkgs, ... }:
{
  imports = [
    ./modules/neovim
    ./modules/tmux
    ./modules/fish
    ./modules/zellij
    ./modules/yazi
    ./modules/picom
    ./modules/prismlauncher
    # ./rice/hyprland
    # ./rice/sway
  ];

  # Theming
  catppuccin.flavor = "mocha";
  catppuccin.accent = "lavender";
  gtk.catppuccin.enable = true;
  #   Excludes
  programs.zellij.catppuccin.enable = false;

  xdg = {
    enable = true;
    mimeApps.defaultApplications = {
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "DesktopEditors.ONLYOFFICE" ];
      "application/vnd.ms-excel" = [ "DesktopEditors.ONLYOFFICE" ];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "DesktopEditors.ONLYOFFICE" ];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "DesktopEditors.ONLYOFFICE" ];
    };
  };

  # Programs
  programs = {
    # firefox.enable = true;
    gpg.enable = true;
    zoxide.enable = true;
    alacritty.enable = true;
    alacritty.catppuccin.enable = false;
    mangohud.enable = true;
    looking-glass-client.enable = true;
    lazygit.enable = true;
    direnv.enable = true;

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
      extensions = with pkgs; [ gh-s gh-copilot ];
    };

    btop = {
      enable = true;
      extraConfig = ''color_theme = "Default"'';
    };

    fzf = {
      enable = true;
      # defaultOptions = [ "--preview 'bat {}'" ];
      defaultCommand = "fd --type f";
    };

    pandoc = {
      enable = true;
      defaults.metadata.author = "Alexander";
      defaults.pdf-engine = "xelatex";
      defaults.citeproc = true;
    };

    eza = {
      enable = true;
      icons = true;
      git = true;
      extraOptions = [ "--oneline" "--group-directories-first" ];
    };

    bat = {
      enable = true;
      config.style = "numbers";
      catppuccin.enable = true;
      # config.theme = "Nord";
      config.pager = "less -FR";
      config.color = "always";
    };

    git = {
      enable = true;
      userName = "Alexander";
      userEmail = "Desench@proton.me";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        rebase.autostash = true;
        rebase.autosquash = true;
        push.autoSetupRemote = true;
        commit.gpgsign = false;
        rerere.enabled = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_rsa.pub";
        core.whitespace = "trailing-space,space-before-tab";
        core.editor = "nvim";
      };
    };
  };

  # Services
  services = {
    spotifyd.enable = true;
    spotifyd.settings.global = {
      device_name = "nix";
      username = "Gidrex";
      password_cmd = "pass show spotifyd";
      backend = "alsa";
      dbus_type = "session"; # "system" for no graphic
      bitrate = 320;
      volume_normalisation = true;
      autoplay = true;
      proxy = "http://127.0.0.1:8889";
    };

    udiskie = {
      enable = true;
      tray = "auto";
      automount = true;
    };
  };

  # home-manager options
  programs.home-manager.enable = true;
  home = { 
    # Packages
    packages = with pkgs; [

      # theming
      tokyo-night-gtk
      catppuccin
      catppuccin-kvantum

      # Gaming
      mangohud

      # Utility
      flameshot pick-colour-picker

      # Apps
      ungoogled-chromium
      # libsForQt5.qtstyleplugin-kvantum libsForQt5.qt5ct
      webtorrent_desktop
      telegram-desktop vesktop 
      onlyoffice-bin_latest
      mysql-workbench dbeaver-bin sqlitebrowser
      drawio gimp krita
      obs-studio
      spotify-cli-linux spotifywm
      anydesk
      pavucontrol
      nemo-with-extensions
      steam

      # Open with
      feh gthumb qimgv # img
      evince zathura # pdf
      mpv # audio
      ark # zip
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "alacritty";
      CHROME_EXECUTABLE = "/run/current-system/sw/bin/chromium";
      # QT_QPA_PLATFORMTHEME = "qt5ct";
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/go/bin"
    ];

    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };
}
