{ pkgs, ... }: {
  imports = [
    ./hardware/optimization.nix
    ./hardware/disko.nix
    ./rice/niri.nix

  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      cores = 4;
      max-jobs = 4;
    };

    # nixPath = lib.mkForce [ ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Users
  users.users.gidrex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # TPM2 tools
    tpm2-tools
    tpm2-tss

    # System utilities
    intel-gpu-tools
    powertop

    # Basic tools
    git
    vim
    wget
    curl
  ];

  # Networking
  networking = {
    hostName = "nixos-icelake";
    networkmanager.enable = true;
    # Enable WiFi powersave
    networkmanager.wifi.powersave = true;
  };

  system.stateVersion = "25.05";
}
