{  pkgs, ... }: {
home.username = "gidrex";
home.homeDirectory = "/home/gidrex";

imports = [
  ./modules/neovim
  ./modules/tmux
  ./modules/git
  ./modules/fish
  ./modules/zellij
  # ./modules/android-sdk
  # ./rice/hyprland
  # ./rice/sway
]; 

home.packages = with pkgs; [
  # theming
  catppuccin
  tokyo-night-gtk

  # android-studio

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

programs = {
  firefox.enable = true;
  gpg.enable = true;
  zoxide.enable = true;
  alacritty.enable = true;
  mangohud.enable = true;
  # looking-glass-client.enable = true;
  yazi.enable = true;
  lazygit.enable = true;
  btop.enable = true;

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
    config.theme = "Nord";
    config.pager = "less -FR";
    config.color = "always";
  };
};

services = {
  spotifyd.enable = true;
  spotifyd.settings.global = {
    device_name = "nix";
    username = "Gidrex";
    password_cmd = "pass show spotifyd";
    backend = "alsa";
    dbus_type = "session"; # system for no graphic
    bitrate = 320;
    volume_normalisation = true;
    autoplay = true;
    # proxy = "http://127.0.0.1:1089";
  };

  udiskie = {
    enable = true;
    tray = "auto";
    automount = true;
  };
};

programs.home-manager.enable = true;
home.enableNixpkgsReleaseCheck = false;
home.stateVersion = "24.05";
}
