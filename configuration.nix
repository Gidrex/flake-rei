{ config, pkgs, lib, ... }: 
{
  imports = [
    ./hardware-configuration.nix
    ./modules/byedpi
  ];

  # Global system
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelPackages = pkgs.pkgs.linuxPackages_xanmod_latest;
    kernelParams = [
      "hid_nintendo"
    ];
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 20;
      timeout = 5;
      grub.enable = true;
      grub.efiSupport = true;
      grub.device = "nodev";
    };
  };
  powerManagement = {
    enable = true;
  };

  # Nix
  nix.settings = {
    auto-optimise-store = true;
    flake-registry = null;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cache.garnix.io" ];

    trusted-substituters = [ "https://prismlauncher.cachix.org" ];
    trusted-public-keys = [ 
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
    ];
  };

  # Services
  services = {

    # Rice
    displayManager.defaultSession = "none+i3";
    displayManager.enable = true;
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      windowManager.i3.package = pkgs.i3-gaps;
      desktopManager.xterm.enable = false;
      displayManager.lightdm.background = ./assets/nix.png;
      displayManager.lightdm.enable = true;
      xkb = {
        layout = "us,ru";
        model = "pc105";
        options = "grp:alt_shift_toggle";
      };
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Android
    udev.packages = [ pkgs.android-udev-rules ];

    # Others
    openssh.enable = true;
    deluge.enable = true;
    blueman.enable = true;
    onlyoffice.enable = true;
    gnome.gnome-keyring.enable = true;
    postgresql.enable = true;
    joycond.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ pantum-driver ];
    };
    udisks2 = {
      enable = true; # auto mount flash usb
      mountOnMedia = true;
    };
    flatpak.enable = true;
    v2raya.enable = true;
  };

  # Networking
  networking = {
    # proxy.httpProxy = "http://127.0.0.1:8889";
    # proxy.allProxy = "socks5://localhost:1089";
    hostName = "rei";
    networkmanager.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    settings = {
      Policy.AutoEnable="true";
      ControllerMode = "bredr";
    };
  };


  # Locale
  time.timeZone = "Europe/Moscow";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "ru_RU.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8" ];
    glibcLocales = pkgs.glibcLocales.override {
      allLocales = lib.any (x: x == "all") config.i18n.supportedLocales;
      locales = config.i18n.supportedLocales;
    };
  };  

  # User
  users.users.gidrex = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Alexander";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" "docker" "vboxusers" "input" "plugdev" "libvirtd" "kvm" "adbusers" ];
  };
  programs.adb.enable = true;

  # Graphics
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelModules = ["nvidia" "i2c-dev" "nvidia-drm" "nvidia-modeset" "nvidia-uvm" "hidp" "hid_generic" "usbhid" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl mesa.drivers ];
    };

    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      dynamicBoost.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId =  "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };

  # Docker
  virtualisation = {
    docker.enable = true;
    docker.rootless.enable = true;
    docker.rootless.setSocketVariable = true;
    containers.enable = true;
  };
  users.extraGroups.docker.members = [ "username-with-access-to-socket" ];

  # Programs
  programs = {
    gamescope.enable = true;
    gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = false;
    };
    fish.enable = true;
    zsh.enable = true;
    command-not-found.enable = false;
    nix-ld.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ];
    };

    nh = {
      flake = "/home/gidrex/flake-rei";
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 5 --keep-since 7d"; # instead of nix.gc.automatic = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  # Screen lighting
  programs.light.enable = true;
  systemd.services.chmodBacklight = {
    description = "Set permissions for backlight brightness control";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/chmod a+wr /sys/class/backlight/intel_backlight/brightness";
      RemainAfterExit = true;
    };
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      times-newer-roman
      hack-font

      jetbrains-mono
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      twitter-color-emoji
      nerdfonts

      # unicode coverage
      unifont
      symbola

      # metric-compatible fonts
      gyre-fonts
      caladea
      carlito
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Hack" ];
        serif = [ "Hack" ];
        sansSerif = [ "Hack" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  # Packets
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron"
    ];
  };
  environment.systemPackages = with pkgs; [
    # --------------- Terminal tools --------------- #
    # musthave
    neovim tldr
    pciutils gnutls usbutils util-linux wget
    acpi sysstat
    htop
    coreutils-prefixed pinentry

    # term tools
    xsel ffmpeg killall xclip fzf xdragon
    file hexyl procs broot dig exiftool
    imagemagick pastel
    fd ripgrep procs jq dust
    nix-inspect nix-prefetch-github
    calc libqalculate
    wmctrl
    tailspin grc
    dpkg

    # web & security
    openssl
    cloak pass sshpass
    inetutils qv2ray
    speedtest-cli crow-translate
    ytfzf yt-dlp 
    git-filter-repo
    john
    zapret

    # fun
    fastfetch neofetch screenfetch starfetch ghfetch onefetch ipfetch
    cmatrix glava

    # university & documents
    zip unzip 
    rar unrar
    pandoc

    # dependencies
    alsa-utils ueberzugpp poppler chafa

    # github-copilot-cli
    # ---------------------------------------------- #

    # Shells
    kitty alacritty
    fish nushell
    starship

    # -------------------- Dev --------------------- #
    # Rust
    rustup cargo
    rust-script
    lldb # debug

    # C/C++
    gcc clang clang-tools cmake gnumake
    gdb # debug
    glibc

    # Java script
    nodePackages_latest.nodejs typescript
    yarn deno

    # Android dev
    dart flutter
    gradle sdkmanager

    # Java
    javaPackages.openjfx21
    openjdk
    openjdk17
    openjdk8

    # Python
    python3 python312Packages.pip
    python312Packages.tkinter 

    # Others
    sqlite sqlite-utils mysql
    clisp sbcl # functional lang env
    lua 
    dosbox nasm # assembler
    # ---------------------------------------------- #

    # Virtualisation
    winePackages.stableFull winetricks winePackages.fonts wine-staging samba
    protonup protontricks
    lutris
    distrobox podman
    qemu_kvm libvirt bridge-utils

    # Rice
    lxappearance nitrogen rofi dmenu pavucontrol
    libexecinfo
    i3 i3lock-fancy
    gxkb parcellite
    i3status i3lock i3blocks

    # Drivers
    blueman playerctl
    vulkan-validation-layers
    cloudflared
    vial qmk # for ergonomic keyboard
    udisks2 udiskie # auto mount usb flash 
    cups pantum-driver cups-printers # for my printer
    xarchiver
    vulkan-tools vulkan-loader vulkan-validation-layers
    dotnetCorePackages.sdk_6_0_1xx
    acpid dbus pkg-config
    freetype
    mesa glfw mesa-demos
    dialog

    # -------------------- Apps -------------------- #
    ungoogled-chromium
    webtorrent_desktop
    obs-studio

    # db viev
    mysql-workbench dbeaver-bin
    sqlitebrowser
    # pgcli

    # draw
    gimp krita
    drawio

    # media
    spotify-cli-linux spotifywm
    revolt-desktop

    # keep in touch with my bros
    telegram-desktop
    vesktop

    # bussines / university
    onlyoffice-bin_latest
    anydesk

    # Utility
    flameshot pick-colour-picker
    gnome-disk-utility ventoy

    # Gaming
    steam
    mangohud
    logmein-hamachi
    scanmem # game conqueror
    evtest xboxdrv linuxConsoleTools SDL2 # gamepad
    sdl-jstest
    # ---------------------------------------------- #

    # Open with
    feh gthumb qimgv # img
    evince zathura # pdf
    mpv # audio
    ark # zip

    # xorg dependencies
  ] ++ lib.flatten [(with xorg; [ xf86videofbdev xkbcomp libX11 libxcb libXcursor libXrandr libXi libXrender libXxf86vm xrandr ])];

  # Logseq fix
  # nixpkgs.overlays = [
  #   ( final: prev: {
  #     logseq = prev.logseq.override {
  #       electron = prev.electron_27;
  #     };
  #   })
  # ];
  # nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  # Looking glass
  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
    qemu.ovmf.enable = true;
  };
  programs.virt-manager.enable = true;
  services.dbus.packages = [ pkgs.dbus ];

  # qt
  qt.enable = false;
  qt.platformTheme = "gtk2";
  xdg.portal = {
    enable = true; 
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Devices
  hardware.keyboard.qmk.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0x1038", GROUP="plugdev", MODE="0666"
    SUBSYSTEM=="input", ATTRS{name}=="Pro Controller", MODE="0666"
    KERNEL=="event*", SUBSYSTEM=="input", MODE="0666", GROUP="input"
  '';

  system.stateVersion = "24.11";
}
