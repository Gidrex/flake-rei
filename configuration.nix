{ config, pkgs, ... }: 
{
security.polkit.enable = true;
imports = [ 
  ./hardware-configuration.nix
  ./rice/i3
  # ./modules/wgraw
# ./modules/pince
# ./modules/proxy
];

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

# Networking
networking = {
  # proxy.httpProxy = "http://127.0.0.1:1092";
  # proxy.noProxy = "127.0.0.1";
  hostName = "rei";
  networkmanager.enable = true;
};

# Locale
time.timeZone = "Europe/Moscow";
i18n.defaultLocale = "en_GB.UTF-8";

# Audio
# sound.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  pulse.enable = true;
  jack.enable = true;
};  
hardware.bluetooth.enable = true;

# default environment variables
environment.variables = {
  TERM = "kitty";
  EDITOR = "nvim";
};

 # User
users.users.gidrex = {
  shell = pkgs.fish;
  isNormalUser = true;
  description = "Alexander";
  extraGroups = [ "networkmanager" "wheel" "audio" "input" "docker" "vboxusers" "input" "plugdev" "libvirtd" "kvm"];
};

# Graphics
boot.kernelModules = ["nvidia" "i2c-dev" "nvidia-drm" "nvidia-modeset" "nvidia-uvm"];
services.xserver.videoDrivers = ["nvidia"];
hardware = {
  graphics = {
    enable = true;
    # driSupport = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl mesa.drivers ];
  };
  nvidia = {
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;      # false
    powerManagement.finegrained = true; # false 
    dynamicBoost.enable = true;
    modesetting.enable = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId =  "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };
};

# Docker
virtualisation.docker.enable = true;
virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
};
virtualisation.containers.enable = true;
users.extraGroups.docker.members = [ "username-with-access-to-socket" ];

programs = {
  thunar.enable = true;
  thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ];
  steam.enable = true;
  gamescope.enable = true;
  gamemode.enable = true;
  fish.enable = true;
  zsh.enable = true;
  command-not-found.enable = true;
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

# Services
services = {
  openssh.enable = true;
  udisks2.enable = true; # auto mount flash usb
  udisks2.mountOnMedia = true;
  # spotifyd.enable = true;
  deluge.enable = true;
  printing.enable = true;
  printing.drivers = with pkgs; [ pantum-driver ];
  blueman.enable = true;
  onlyoffice.enable = true;
};

# Fonts
fonts.fontconfig.enable = true;
fonts.packages = with pkgs; [
  nerdfonts
  noto-fonts
  jetbrains-mono
  _0xproto
  times-newer-roman
];

nix.settings.experimental-features = ["nix-command" "flakes"];
nix.gc.automatic = true; #Garbage collector

# Packets
nixpkgs.config.allowUnfree = true;
environment.systemPackages = with pkgs; [
# --------------- Terminal tools --------------- #
  # musthave
  neovim tlrc
  pciutils gnutls usbutils util-linux wget
  acpi sysstat
  htop
  coreutils-prefixed pinentry

  # term tools
  xsel ffmpeg
  file hexyl procs broot chafa
  imagemagick
  fd ripgrep
  nix-inspect


  # web & security
  openssl
  cloak pass
  shadowsocks-rust shadowsocks-libev 
  wireguard-tools udp2raw
  crow-translate
  ytfzf yt-dlp
  git-filter-repo

  # fun
  ranger neofetch calc

  # university learning & documents
  zip unzip pkg-config
  pandoc

  # dependencies
  alsa-utils ueberzug

  # why Im garbage collector?
  jq  micro

  # I want to learn it
  lynx 
  rust-script
# ---------------------------------------------- #

  # Shells
  kitty fish alacritty nushell starship

  # Dev
  gradle openjdk jdk8 #libcanberra 
  python3 python312Packages.pip virtualenv python3Packages.psutil
  python312Packages.huggingface-hub python312Packages.tkinter
  gdb
  lua 
  nodejs yarn deno
  rustup cargo
  flutter
  gcc cmake gnumake
  libstdcxx5 
  sqlite

  # Utility
  flameshot pick-colour-picker

  # Apps
  firefox google-chrome
  webtorrent_desktop
  telegram-desktop vesktop 
  onlyoffice-bin_latest
  logseq figma-linux
  mysql-workbench dbeaver-bin sqlitebrowser
  drawio gimp krita
  qalculate-gtk
  audio-recorder kazam
  spotify-cli-linux spotifywm
  # (pkgs.android-studio.overrideAttrs (oldAttrs: {
  #   version = "2024.1.1.4";
  #   src = pkgs.fetchurl {
  #   url = "https://redirector.gvt1.com/edgedl/android/studio/install/2024.1.1.4/android-studio-2024.1.1.4-linux.tar.gz";
  #   sha256 = "lfig7lFyF7XZowTQKpo6zGeR23VHq/f7vvUDWCs7jeo=";
  #   };
  # }))
  android-studio.canary

  # Open with
  feh gthumb
  evince
  mpv
  qimgv
  ark

  # Boxes
  fuse wine winetricks
  protonup protontricks
  lutris
  distrobox podman
  qemu_kvm libvirt bridge-utils

  # Rice
  xorg.xf86videofbdev xorg.xkbcomp
  lxappearance nitrogen rofi dmenu fzf pavucontrol

  # Drivers
  blueman playerctl
  vulkan-validation-layers
  cloudflared
  vial qmk # for ergonomic keyboard
  udisks2 udiskie # auto mount usb flash 
  cups pantum-driver cups-printers # for my printer
  xarchive
  vulkan-tools vulkan-loader vulkan-validation-layers
  dotnetCorePackages.sdk_6_0_1xx

  # Dependencies
  xorg.libX11
  xorg.libXfixes
  xorg.libXrandr

  # Gaming
  mangohud
];

# Electron <3 .!.
nixpkgs.config.permittedInsecurePackages = [
  "electron-27.3.11"
];

# xserver conf
services.xserver = {
  enable = true;
  xkb = {
    layout = "us,ru";
    model = "pc105";
    options = "grp:alt_shift_toggle";
  };
  displayManager.lightdm = {
    background = ./assets/nix.png;
    enable  = true;
  };
};
environment.variables.PATH = "${pkgs.stdenv.cc}/bin:/usr/bin";

# flatpak
services.flatpak.enable = true;
xdg.portal = {
  enable = true; 
  extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  config.common.default = "*";
};

# ergonomic keyboard
hardware.keyboard.qmk.enable = true;
services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTR{idVendor}=="0x1038", GROUP="plugdev", MODE="0666"
'';

# Looking glass TODO
virtualisation.libvirtd = {
  enable = true;
  qemu.package = pkgs.qemu_kvm;
  qemu.ovmf.enable = true;
};
programs.virt-manager.enable = true;
services.dbus.packages = [ pkgs.dbus ];

system.stateVersion = "24.11";
}
