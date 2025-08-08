#!/bin/bash

SCREENSHOTS_DIR=~/Pictures/Screenshots
mkdir -p "$SCREENSHOTS_DIR"
FILENAME="$SCREENSHOTS_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # For Wayland/Sway
    grim -g "$(slurp)" "$FILENAME"
else
    # For X11/i3
    scrot -s "$FILENAME"
fi

# Notify user
notify-send "Screenshot saved" "$FILENAME"
