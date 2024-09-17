{  pkgs, ... }:
{
  imports = [
    ./modules/neovim
    ./modules/tmux
    ./modules/fish
    ./modules/zellij
    # ./rice/hyprland
    # ./modules/android-sdk # broken
    # ./rice/sway
  ];

  # Theming
  catppuccin.flavor = "mocha";
  catppuccin.accent = "lavender";
  gtk.catppuccin.enable = true;
  #   Excludes
  programs.zellij.catppuccin.enable = false;

  # Programs
  programs = {
    firefox.enable = true;
    gpg.enable = true;
    zoxide.enable = true;
    alacritty.enable = true;
    alacritty.catppuccin.enable = false;
    mangohud.enable = true;
    # looking-glass-client.enable = true;
    yazi = {
      enable = true;
      shellWrapperName = "y";
    };
    lazygit.enable = true;
    btop = {
      enable = true;
      extraConfig = ''
      color_theme = "Default"
      '';
    };
    direnv.enable = true;

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
    spotifyd = {
      enable = true;
      settings.global = {
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
    };
    udiskie = {
      enable = true;
      tray = "auto";
      automount = true;
    };
    polybar = {
      enable = true;
      script = "polybar bar &amp;";
    };
  };

  # home-manager options
  programs.home-manager.enable = true;
  home = { 
    packages = with pkgs; [
      # theming
      tokyo-night-gtk
      catppuccin
      catppuccin-kvantum
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "alacritty";
      CHROME_EXECUTABLE = "/run/current-system/sw/bin/chromium";
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
    sessionPath = [
      "$HOME/.cargo/bin"
    ];
    
    username = "gidrex";
    homeDirectory = "/home/gidrex";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };
}
