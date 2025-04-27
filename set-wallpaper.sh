#!/bin/bash

WALLPAPER=~/Pictures/Wallpapers/wallaper-2.jpg

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # For Wayland/Sway
    pkill swaybg 2>/dev/null
    swaybg -i "$WALLPAPER" -m fill &
else
    feh --bg-scale "$WALLPAPER"
fi
