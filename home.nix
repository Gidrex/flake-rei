{  pkgs, config, ... }:
let
  androidSdkModule = import ((builtins.fetchGit {
    url = "https://github.com/tadfisher/android-nixpkgs.git";
    ref = "main";  # Or "stable", "beta", "preview", "canary"
  }) + "/hm-module.nix");

in
{
  imports = [
    ./modules/neovim
    ./modules/tmux
    ./modules/fish
    ./modules/zellij
    ./modules/android-sdk
    # ./rice/hyprland
    androidSdkModule
    # ./rice/sway
  ]; 


  android-sdk.enable = true;

  # Optional; default path is "~/.local/share/android".
  android-sdk.path = "${config.home.homeDirectory}/.android/sdk";

  android-sdk.packages = sdkPkgs: with sdkPkgs; [
    build-tools-34-0-0
    cmdline-tools-latest
    emulator
    platforms-android-34
    sources-android-34
  ];

  home.packages = with pkgs; [
    # theming
    tokyo-night-gtk
    catppuccin
    catppuccin-kvantum

    # Apps
    spicetify-cli spotifywm

    # LSP Servers
    pyright
    cmake-language-server
    nil
    rust-analyzer
    ansible-language-server
    nodePackages_latest.dockerfile-language-server-nodejs
    nodePackages.vim-language-server
    lua-language-server
    buf-language-server
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "alacritty";
  };

  # Theming
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "lavender";

  # excludes
  programs.zellij.catppuccin.enable = false;

  programs = {
    firefox.enable = true;
    gpg.enable = true;
    zoxide.enable = true;
    alacritty.enable = true;
    alacritty.catppuccin.enable = false;
    mangohud.enable = true;
    # looking-glass-client.enable = true;
    yazi.enable = true;
    lazygit.enable = true;
    btop.enable = true;
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
  };

  programs.home-manager.enable = true;
  home.username = "gidrex";
  home.homeDirectory = "/home/gidrex";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "24.05";
}
