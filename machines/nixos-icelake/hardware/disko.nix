{ ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "umask=0077" ];
              };
            };

            swap = {
              size = "20G";
              content = {
                type = "swap";
                randomEncryption = true;
                discardPolicy = "both";
                resumeDevice = true;
              };
            };

            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";

                # LUKS2 with Argon2id optimizations
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];

                # LUKS2 formatting arguments for cryptsetup luksFormat
                extraFormatArgs = [
                  "--type"
                  "luks2"
                  "--cipher"
                  "aes-xts-plain64"
                  "--key-size"
                  "512"
                  "--hash"
                  "sha512"
                  "--pbkdf"
                  "argon2id"
                  "--pbkdf-memory"
                  "4194304"
                  "--pbkdf-parallel"
                  "8"
                  "--iter-time"
                  "4000"
                  "--use-random"
                ];

                # Settings for NixOS LUKS configuration  
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [
                    "tpm2-device=auto"
                    "tmp2-pcrs=0+2+7+12"
                    "tpm2-with-pin=false"
                    "timeout=10"
                  ];
                };

                content = {
                  type = "filesystem";
                  format = "f2fs";
                  mountpoint = "/";

                  # F2FS optimizations for Ice Lake + NVMe
                  mountOptions = [
                    # Compression
                    "compress_algorithm=zstd:6"
                    "compress_chksum"
                    "compress_mode=fs"

                    # Garbage collection optimizations
                    "atgc"
                    "gc_merge"
                    "checkpoint_merge"

                    # Performance optimizations
                    "lazytime"
                    "noatime"
                    "nodiratime"

                    # SSD optimizations
                    "discard"
                    "fastboot"

                    # Ice Lake specific
                    "extent_cache"
                    "inline_data"
                    "inline_dentry"
                    "flush_merge"
                    "mode=adaptive"
                  ];

                  # F2FS format options
                  extraArgs = [
                    "-f" # Force format
                    "-O"
                    "extra_attr,inode_checksum,sb_checksum,compression"
                    "-C"
                    "utf8" # Case-insensitive support
                    "-w"
                    "4096" # 4KB sector size for NVMe
                  ];
                };
              };
            };
          };
        };
      };
    };
  };

  # Additional filesystem optimizations
  fileSystems = {
    "/" = {
      options = [
        # F2FS specific mount options for performance
        "compress_algorithm=zstd:6"
        "compress_chksum"
        "atgc"
        "gc_merge"
        "checkpoint_merge"
        "lazytime"
        "noatime"
        "nodiratime"
        "discard"
        "fastboot"
        "extent_cache"
        "inline_data"
        "inline_dentry"
        "flush_merge"
        "mode=adaptive"
      ];
    };

    "/boot" = {
      options =
        [ "defaults" "umask=0077" "iocharset=iso8859-1" "shortname=winnt" ];
    };
  };

  # Swap configuration
  swapDevices = [ ];

  # Zram for better memory management on 16GB system
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25; # Use 4GB of RAM for zram
  };
}
