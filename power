#!/bin/bash

# Rofi Power Menu Script

# Path to your custom theme
ROFI_THEME="~/.config/rofi/themes/theme.rasi"

# Options to show in Rofi
options="Shutdown\nLogout\nRestart"

# Get the user's choice from rofi using your custom theme
choice=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -theme "$ROFI_THEME")

case "$choice" in
  Shutdown)
    # Shutdown system
    systemctl poweroff
    ;;
  Logout)
    # Logout of i3
    i3-msg exit
    ;;
  Restart)
    # Restart system
    systemctl reboot
    ;;
  *)
    # If no valid option selected, do nothing
    exit 0
    ;;
esac

