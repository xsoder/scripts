#!/bin/bash

WALLPAPER_DIR="/home/csode/devenv/wallpaper/gruvbox"
STATE_FILE="/home/csode/.cache/current_wallpaper.txt"

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Switcher" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

LAST_WALLPAPER=$(cat "$STATE_FILE" 2>/dev/null)
INDEX=0
for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$LAST_WALLPAPER" ]]; then
        INDEX=$(( ($i + 1) % ${#WALLPAPERS[@]} ))
        break
    fi
done

NEXT_WALLPAPER="${WALLPAPERS[$INDEX]}"
swww img "$NEXT_WALLPAPER" --transition-type any --transition-duration 1.0
echo "$NEXT_WALLPAPER" > "$STATE_FILE"
notify-send "Wallpaper Changed" "Set to: $(basename "$NEXT_WALLPAPER")"
