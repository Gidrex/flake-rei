{
  programs.waybar = {
    style = builtins.readFile ./style.scss;
    settings.mainBar = {
      # Variables
      position = "bottom";
      height = 0;
      spacing = 0;
      # mode = "dock";

      # Visible modules
      modules-left = [
        "hyprland/language"

      ];
      modules-center = [
        "hyprland/workspaces"
        "hyprland/submap"
        "battery"
        "clock"
        "custom/clock-icon"
        "custom/media"
      ];
      modules-right = [ "pulseaudio" "privacy" "network" "tray" ];

      # Hyprland modules
      "hyprland/submap" = { format = "{} 󱂬"; };

      "hyprland/language" = {
        format = "{}";
        format-en = "US 🇺🇸";
        format-ru = "RU 🇷🇺";
      };

      "hyprland/worksapces" = {
        format = "{id}";
        show-special = true;
      };

      # Other modules
      tray = {
        icon-size = 21;
        show-passive-items = false;
        spacing = 8;
      };
      clock = {
        timezone = "Europe/Moscow";
        format = "{:%H:%M}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      battery = {
        interval = 8;
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% 󱐌";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        states = {
          warning = 30;
          critical = 15;
        };
      };

      network = {
        format-wifi = "{essid} 󰖩  {signalStrength}%";
        format-ethernet = "{ipaddr}󱎔 ";
        format-disconnected = "󰖪";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format = " {volume}% {icon}  {format_source}";
        format-muted = "󰝟  {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "󰍭";
        format-icons = {
          headphone = "󰋋";
          hands-free = "󰆟";
          headset = "󰋎";
          phone = "";
          portable = "󰓃";
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
      };

      privacy = {
        transition-duration = 250;
        modules = [
          {
            type = "audio-out";
            tooltip = true;
            tooltip-icon-size = 24;
          }
          {
            type = "audio-in";
            tooltip = true;
            tooltip-icon-size = 24;
          }
          {
            type = "screenshare";
            tooltip = true;
            tooltip-icon-size = 24;
          }
        ];
      };

      "custom/clock-icon" = {
        interval = 1200;
        exec = ''
          case $(($(date +%H) % 12)) in
            0) icon="󱑖" ;;
            1) icon="󱑋" ;;
            2) icon="󱑌" ;;
            3) icon="󱑍" ;;
            4) icon="󱑎" ;;
            5) icon="󱑏" ;;
            6) icon="󱑐" ;;
            7) icon="󱑑" ;;
            8) icon="󱑒" ;;
            9) icon="󱑓" ;;
            10) icon="󱑔" ;;
            11) icon="󱑕" ;;
          esac
          echo "$icon"
        '';
      };
    };
  };
}
