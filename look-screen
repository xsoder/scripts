#!/bin/bash

WALLPAPER=~/Pictures/Wallpapers/rosepine.png

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # For Wayland/Sway
    swaylock -i "$WALLPAPER"
else
    # For X11/i3
    i3lock -i "$WALLPAPER"
fi
