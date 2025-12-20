{ config, lib, pkgs, ... }:

{
  # Enable niri compositor
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Required services for niri
  services = {
    # Display manager for niri
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.niri}/bin/niri --session";
          user = "gidrex";
        };
      };
    };

    # Hardware acceleration
    xserver.videoDrivers = [ "intel" ];

    # Required for Wayland compositors
    dbus.enable = true;
    udev.enable = true;

    # Audio support
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  # XDG portal for niri
  xdg.portal = {
    enable = true;
    wlr.enable = false; # Disable wlr portal as niri doesn't use wlroots
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config = { common = { default = [ "gtk" ]; }; };
  };

  # Security for Wayland
  security = { polkit.enable = true; };

  # Environment variables for niri
  environment = {
    sessionVariables = {
      # Wayland
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";

      # Enable Wayland support in applications
      QT_QPA_PLATFORM = "wayland;xcb";
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";

      # Intel GPU optimizations
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";

      # Fix Java applications
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    # System packages for niri
    systemPackages = with pkgs; [
      # Niri and related tools
      niri

      # Wayland utilities
      wayland
      wayland-protocols
      wayland-utils

      # Terminal for niri sessions
      foot

      # Application launcher
      fuzzel

      # Notification daemon
      mako

      # Screen capture
      grim
      slurp
      wl-clipboard

      # Status bar (if desired)
      waybar

      # File manager
      nautilus

      # Basic applications
      firefox

      # Wallpaper setter for niri
      swaybg

      # Screen locker
      swaylock

      # Font packages  
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-emoji
    ];
  };

  # Fonts configuration
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Users configuration for niri
  users.users.gidrex = {
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "render" ];
  };

}
