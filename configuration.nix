{ config, pkgs, ... }: 
{
  imports = [ 
    ./hardware-configuration.nix
  ];

  # Global system
  security.polkit.enable = true;
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    kernelPackages = pkgs.pkgs.linuxPackages_xanmod_latest;
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
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Rice
  services = {
    displayManager.defaultSession = "hyprland"; # "none+i3"
    displayManager.enable = false;
    xserver = {
      enable = false;
      xkb = {
        layout = "us,ru";
        model = "pc105";
        options = "grp:alt_shift_toggle";
      };
      # displayManager.lightdm = {
      #   background = ./assets/nix.png;
      #   enable  = false;
      # };
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

    # Services

    openssh.enable = true;
    deluge.enable = true;
    blueman.enable = true;
    onlyoffice.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ pantum-driver ];
    };
    udisks2 = {
      enable = true; # auto mount flash usb
      mountOnMedia = true;
    };


    # flatpak
    flatpak.enable = true;
    udev.extraRules = ''SUBSYSTEM=="usb", ATTR{idVendor}=="0x1038", GROUP="plugdev", MODE="0666"'';
  };

  # Networking
  networking = {
    # proxy.httpProxy = "http://127.0.0.1:8889";
    # proxy.allProxy = "socks5://localhost:1089";
    hostName = "rei";
    networkmanager.enable = true;
  };

  # Locale
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [ "ru_RU.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8" ];  
  hardware.bluetooth.enable = true;

  # User
  users.users.gidrex = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Alexander";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" "docker" "vboxusers" "input" "plugdev" "libvirtd" "kvm" "adbusers"];
  };
  programs.adb.enable = true;

  # Graphics
  services.xserver.videoDrivers = ["nvidia"];
  boot.kernelModules = ["nvidia" "i2c-dev" "nvidia-drm" "nvidia-modeset" "nvidia-uvm"];
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
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    fish.enable = true;
    zsh.enable = true;
    command-not-found.enable = false;
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
    fontconfig.enable = true;
    fontconfig.defaultFonts.monospace = [ "Hack" ];
    packages = with pkgs; [
      nerdfonts
      noto-fonts
      jetbrains-mono
      _0xproto
      times-newer-roman
      hack-font
      source-code-pro
      sudo-font
    ];
  };

  # Packets
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # --------------- Terminal tools --------------- #
    # musthave
    neovim tldr
    pciutils gnutls usbutils util-linux wget
    acpi sysstat
    htop
    coreutils-prefixed pinentry

    # term tools
    xsel ffmpeg killall xclip
    file hexyl procs broot dig
    imagemagick pastel
    fd ripgrep procs jq dust
    nix-inspect nix-prefetch-github
    calc libqalculate
    wmctrl

    # web & security
    openssl
    cloak pass
    shadowsocks-rust shadowsocks-libev 
    wireguard-tools udp2raw inetutils v2ray qv2ray
    crow-translate
    ytfzf yt-dlp
    git-filter-repo

    # fun
    fastfetch screenfetch starfetch ghfetch onefetch

    # university learning & documents
    zip unzip rar unrar
    pandoc

    # dependencies
    alsa-utils ueberzugpp poppler chafa

    # why Im garbage collector?
    micro

    # I want to learn it
    # github-copilot-cli
    # ---------------------------------------------- #

    # Shells
    kitty fish alacritty nushell starship

    # Dev
    gradle sdkmanager
    python3 python312Packages.pip virtualenv python3Packages.psutil
    python312Packages.huggingface-hub python312Packages.tkinter
    gdb
    lua 
    nodejs yarn deno typescript
    rustup cargo rust-script
    dart
    gcc clang clang-tools cmake gnumake pkg-config glibc libcxx libstdcxx5 ncurses
    sqlite sqlite-utils
    clisp sbcl

    # Utility
    flameshot pick-colour-picker

    # Apps
    firefox ungoogled-chromium
    # libsForQt5.qtstyleplugin-kvantum libsForQt5.qt5ct
    webtorrent_desktop
    telegram-desktop vesktop 
    onlyoffice-bin_latest
    logseq
    androidStudioPackages.canary
    mysql-workbench dbeaver-bin sqlitebrowser
    drawio gimp krita
    obs-studio
    spotify-cli-linux spotifywm
    anydesk
    pavucontrol
    nemo-with-extensions

    # Open with
    feh gthumb
    evince zathura # pdf
    mpv
    qimgv
    ark

    # Virtualisation
    winePackages.stableFull winetricks winePackages.fonts
    protonup protontricks
    lutris
    distrobox podman
    qemu_kvm libvirt bridge-utils

    # Rice
    xorg.xf86videofbdev xorg.xkbcomp
    lxappearance nitrogen rofi dmenu fzf pavucontrol
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
    acpid

    # Dependencies
    xorg.libX11
    xorg.libXfixes
    xorg.libXrandr
    xorg.xmodmap
    freetype

    # Gaming
    mangohud
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    openjdk flutter
  ];

  # Electron <3 .!.
  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  # Looking glass TODO
  # virtualisation.libvirtd = {
  #   enable = true;
  #   qemu.package = pkgs.qemu_kvm;
  #   qemu.ovmf.enable = true;
  # };
  # programs.virt-manager.enable = true;
  # services.dbus.packages = [ pkgs.dbus ];

  # qt
  qt.enable = false;
  qt.platformTheme = "gtk2";
  xdg.portal = {
    enable = true; 
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # ergonomic keyboard
  hardware.keyboard.qmk.enable = true;

  system.stateVersion = "24.11";
}
