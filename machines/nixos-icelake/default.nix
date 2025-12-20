{ pkgs, ... }: {
  programs = {
    # Terminal emulator
    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=12";
          dpi-aware = "yes";
        };

        scrollback.lines = 10000;

        cursor = {
          style = "beam";
          blink = "yes";
        };
      };
    };

    # Shell configuration
    fish = {
      enable = true;
      shellAliases = {
        rbn = "sudo nixos-rebuild switch --flake ~/flake-rei/#nixos-icelake";
        rbh = "home-manager switch --flake ~/flake-rei/#nixos-icelake";
      };
    };
  };

  # Niri configuration
  xdg.configFile."niri/config.kdl".text = ''
    // Ice Lake optimized niri configuration

    input {
        keyboard {
            xkb {
                layout "us,ru"
                options "grp:alt_shift_toggle,compose:ralt"
            }
        }
        
        touchpad {
            tap
            dwt
            natural-scroll
            accel-speed 0.2
            accel-profile "adaptive"
        }
        
        mouse {
            accel-speed 0.2
            accel-profile "adaptive"
        }
    }

    layout {
        gaps 8
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
    }

    spawn-at-startup "${pkgs.swaybg}/bin/swaybg -i ~/flake-rei/assets/wallpapers/red_portal.png"

    prefer-no-csd

    hotkey-overlay {
        skip-at-startup
    }

    animations {
        slowdown 1.0
        window-open {
            duration-ms 150
            curve "ease-out-cubic"
        }
        window-close {
            duration-ms 150
            curve "ease-out-cubic"  
        }
        horizontal-view-movement {
            duration-ms 200
            curve "ease-out-cubic"
        }
        workspace-switch {
            duration-ms 200
            curve "ease-out-cubic"
        }
    }

    window-rule {
        match app-id="firefox"
        default-column-width { proportion 0.75; }
    }

    binds {
        Mod+T { spawn "${pkgs.foot}/bin/foot"; }
        Mod+D { spawn "${pkgs.fuzzel}/bin/fuzzel"; }
        Mod+Q { close-window; }
        
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        
        Mod+R { switch-preset-column-width; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Minus { set-column-width "-10%"; }
        
        Print { spawn "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"; }
        
        Mod+Shift+E { quit; }
        Mod+Shift+R { reload-config; }
        
        XF86AudioRaiseVolume { spawn "${pkgs.pamixer}/bin/pamixer -i 5"; }
        XF86AudioLowerVolume { spawn "${pkgs.pamixer}/bin/pamixer -d 5"; }
        XF86AudioMute { spawn "${pkgs.pamixer}/bin/pamixer --toggle-mute"; }
        
        XF86MonBrightnessUp { spawn "${pkgs.brightnessctl}/bin/brightnessctl set +5%"; }
        XF86MonBrightnessDown { spawn "${pkgs.brightnessctl}/bin/brightnessctl set 5%-"; }
    }
  '';

  # Home packages
  home.packages = with pkgs; [
    fd
    ripgrep

    # System monitoring
    powertop
    intel-gpu-tools

    # Audio control
    pamixer

    # Brightness control
    brightnessctl

    # Wayland applications
    fuzzel
    grim
    slurp
    wl-clipboard
  ];

  # Home Manager state version
  home.sessionVariables.FLAKE_MACHINE = "nixos-icelake";
  home.stateVersion = "25.05";
}
