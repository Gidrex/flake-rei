# Ice Lake kernel parameters optimized for CHUWI CoreBook X
{ pkgs, lib, ... }: {
  boot = {
    kernelParams = [
      # Intel CPU optimizations
      "intel_pstate=active"
      "intel_idle.max_cstate=2"
      "processor.max_cstate=2"

      # Intel UHD Graphics Ice Lake optimizations
      "i915.enable_fbc=1" # Frame Buffer Compression
      "i915.enable_psr=1" # Panel Self Refresh
      "i915.enable_guc=2" # GuC submission + HuC loading
      "i915.enable_dc=2" # Display C-states
      "i915.fastboot=1" # Skip modeset on boot
      "i915.nuclear_pageflip=1" # Atomic page flipping
      "i915.semaphores=1" # GPU semaphores
      "i915.enable_hangcheck=0" # Disable GPU hang detection for performance

      # Storage optimizations for NVMe SSD
      "elevator=mq-deadline"
      "laptop_mode=5"
      "nvme_core.default_ps_max_latency_us=0" # Disable NVMe power saving

      # Memory optimizations for 16GB
      "transparent_hugepage=madvise"
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=25"

      # Performance optimizations
      "preempt=voluntary"
      "mitigations=off" # Disable CPU vulnerability mitigations for performance
      "nowatchdog" # Disable soft lockup detector
      "nmi_watchdog=0" # Disable NMI watchdog

      # Ice Lake specific
      "intel_iommu=igfx_off" # Disable IOMMU for integrated graphics
      "split_lock_detect=off" # Disable split lock detection

      # Power management
      "acpi_osi=Linux"
      "acpi_backlight=vendor"

      # Audio optimizations
      "snd_hda_intel.power_save=1"
      "snd_hda_intel.power_save_controller=1"

      # Network power saving
      "usbcore.autosuspend=1"

      # Quiet boot
      "quiet"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "systemd.show_status=false"
    ];

    # Linux Zen kernel optimized for Ice Lake
    kernelPackages = pkgs.linuxPackages_zen;

    # Enable Intel microcode updates and TPM2 modules
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
      "intel_agp"
      "i915"
      "tpm_tis"
      "tpm_crb"
    ];
  };

  # Hardware configuration
  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # VAAPI driver for Ice Lake
        intel-vaapi-driver # Replacement for vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL support
      ];
    };

    bluetooth.enable = true;
  };

  # LUKS TPM2 integration
  boot.initrd = {
    # TPM2 unlock for LUKS
    systemd.enable = true;

    luks.devices."crypted" = {
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  # Services
  services = {
    # Enable TPM2 services
    tcsd.enable = true;

    # Power management (TLP conflicts with power-profiles-daemon)
    tlp = {
      enable = true;
      settings = {
        # Ice Lake specific settings
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
      };
    };

    # Firmware updates
    fwupd.enable = true;
  };

  # Environment variables for native optimizations
  environment.variables = {
    NIX_CFLAGS_COMPILE =
      "-march=native -mtune=native -O3 -flto=auto -fuse-linker-plugin -ftree-vectorize -ffast-math -funroll-loops -fomit-frame-pointer";
    NIX_LDFLAGS = "-flto=auto -Wl,--as-needed -Wl,-O1";
  };

  nixpkgs = {
    hostPlatform = lib.genAttrs [ "system" "gcc.arch" "gcc.tune" ]
      (attr: if attr == "system" then "x86_64-linux" else "icelake-client");

    overlays = [
      # Fix for hostPlatform gcc.arch overrides causing build issues
      (self: super: {
        libopus = super.libopus.overrideDerivation
          (oldAttrs: { patches = oldAttrs.patches; });
      })

      (final: prev: {
        linuxPackages_zen = prev.linuxPackages_zen.extend (lpself: lpsuper: {
          kernel = lpsuper.kernel.override {
            structuredExtraConfig = with prev.lib.kernel; {
              MNATIVE_INTEL = yes;
              MCORE2 = no;
              GENERIC_CPU = no;
              MK8 = no;

              # Ice Lake specific CPU features
              X86_INTEL_LPSS = yes;
              INTEL_TH = yes;
              INTEL_TH_PCI = yes;
              INTEL_TH_GTH = yes;
              INTEL_TH_STH = yes;
              INTEL_TH_MSU = yes;
              INTEL_TH_PTI = yes;

              # Performance optimizations for laptop
              PREEMPT = yes;
              PREEMPT_VOLUNTARY = no;
              PREEMPT_DYNAMIC = yes;
              HZ_1000 = yes;
              HZ_300 = no;
              NO_HZ_FULL = yes;

              # Intel Ice Lake graphics (UHD Graphics)
              DRM_I915 = yes;
              DRM_I915_GVT = yes;
              DRM_I915_USERPTR = yes;
              DRM_I915_GVT_KVMGT = yes;
              DRM_I915_FORCE_PROBE = freeform "1a56"; # Ice Lake GT2 device ID

              # F2FS optimizations for NVMe SSD
              F2FS_FS = yes;
              F2FS_STAT_FS = yes;
              F2FS_FS_XATTR = yes;
              F2FS_FS_POSIX_ACL = yes;
              F2FS_FS_SECURITY = yes;
              F2FS_CHECK_FS = yes;
              F2FS_FS_COMPRESSION = yes;

              # NVMe optimizations
              BLK_DEV_NVME = yes;
              NVME_CORE = yes;
              NVME_MULTIPATH = yes;
              NVME_VERBOSE_ERRORS = yes;
              NVME_HWMON = yes;

              # TPM2 support
              TCG_TPM = yes;
              TCG_TIS_CORE = yes;
              TCG_TIS = yes;
              TCG_TIS_SPI = yes;
              TCG_CRB = yes;

              # Audio PCH
              SND_SOC_INTEL_SKYLAKE_FAMILY = yes;
              SND_SOC_INTEL_ICL = yes;
              SND_SOC_SOF_INTEL_ICL = yes;
              SND_SOC_SOF_INTEL_TOPLEVEL = yes;

              # WiFi - typical Ice Lake WiFi chips
              IWLWIFI = yes;
              IWLDVM = yes;
              IWLMVM = yes;

              # Bluetooth
              BT_INTEL = yes;
              BT_BCM = yes;

              # USB
              USB_XHCI_HCD = yes;
              USB_XHCI_PCI = yes;
              USB_XHCI_PLATFORM = yes;

              # Thunderbolt 3 support
              THUNDERBOLT = yes;
              USB4 = yes;

              # RAM optimizations
              TRANSPARENT_HUGEPAGE = yes;
              TRANSPARENT_HUGEPAGE_ALWAYS = no;
              TRANSPARENT_HUGEPAGE_MADVISE = yes;
              COMPACTION = yes;
              MIGRATION = yes;
              KSM = yes;

              # Zen kernel specific optimizations
              CC_OPTIMIZE_FOR_PERFORMANCE = yes;
              CC_OPTIMIZE_FOR_SIZE = no;

              # Security
              SECURITY_SELINUX = no;
              SECURITY_APPARMOR = no;
              SECURITY_TOMOYO = no;
              HARDENED_USERCOPY = yes;
              FORTIFY_SOURCE = yes;

              # Reduce kernel size - disable debugging
              DEBUG_KERNEL = no;
              DEBUG_INFO = no;
              DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT = no;
              COMPILE_TEST = no;
              LOCALVERSION_AUTO = no;

              # Laptop specific
              LAPTOP_MODE = yes;
              ACPI_BATTERY = yes;
              ACPI_AC = yes;
              ACPI_FAN = yes;
              ACPI_THERMAL = yes;

              # Power management
              INTEL_IDLE = yes;
              INTEL_PSTATE = yes;
              X86_INTEL_PSTATE = yes;
              CPU_FREQ_GOV_SCHEDUTIL = yes;
              CPU_FREQ_GOV_ONDEMAND = yes;
              CPU_FREQ_GOV_CONSERVATIVE = yes;
              ACPI_PROCESSOR_AGGREGATOR = yes;

              # Power saving
              PM = yes;
              PM_SLEEP = yes;
              SUSPEND = yes;
              HIBERNATION = yes;
              PM_STD_PARTITION = freeform "/dev/disk/by-partlabel/swap";
            };
          };
        });
      })
    ];
  };

  # Enable weekly TRIM instead of continuous discard
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Nix system features for architecture-specific builds
  nix.settings.system-features = lib.mkForce [
    "gccarch-icelake-client"
    "benchmark"
    "big-parallel"
    "kvm"
    "nixos-test"
  ];
}
