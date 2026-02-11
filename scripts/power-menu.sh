#!/bin/bash
options="Shutdown\nReboot\nLogout\nSuspend\nHibernate\nLock\nExit\nTurn off monitor"
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 10% --height 30% )

case $chosen in
  "Shutdown") systemctl poweroff ;;
  "Reboot")   systemctl reboot ;;
  "Logout")   niri msg action quit --skip-confirmation ;;
  "Suspend")  systemctl suspend ;;
  "Hibernate") systemctl hibernate ;;
  "Lock")     swaylock ;;
  "Exit")     exit 0 ;;
  "Turn off monitor") niri msg action power-off-monitors ;; 
  *)          exit 1 ;;
esac