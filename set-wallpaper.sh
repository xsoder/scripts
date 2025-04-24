#!/bin/bash

WALLPAPER=~/Pictures/Wallpapers/animewaifu.jpg

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # For Wayland/Sway
    pkill swaybg 2>/dev/null
    swaybg -i "$WALLPAPER" -m fill &
else
    # For X11/i3
    feh --bg-scale "$WALLPAPER"
fi
