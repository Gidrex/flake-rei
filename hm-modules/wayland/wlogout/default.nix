let
  inherit (builtins) readFile toString;
  lockscreen = toString ../../../assets/scripts/swaylock_fancy.sh;

in {
  catppuccin.wlogout = {
    enable = false;
    iconStyle = "wleave";
  };

  programs.wlogout = {
    style = readFile ./style.scss;
    layout = [
      {
        label = "lock";
        action = "${lockscreen}";
        text = "Lock";
        keybind = "l";
      }
      # {
      #   label = "hibernate";
      #   action = "systemctl hibernate";
      #   text = "Hibernate";
      #   keybind = "h";
      # }
      # {
      #   label = "logout";
      #   action = "hyprctl dispatch exit";
      #   text = "Logout";
      #   keybind = "l";
      # }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "${lockscreen} & systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };
}
