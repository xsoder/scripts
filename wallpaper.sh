#!/usr/bin/env bash

FOLDER=~/devenv/wallpaper      # Folder containing wallpapers
SCRIPT=~/scripts/pywal16       # Script to run after setting wallpaper

menu () {
    if command -v nsxiv >/dev/null; then 
        CHOICE=$(nsxiv -otb "$FOLDER"/*)
    elif command -v feh >/dev/null; then
        CHOICE=$(feh --thumbnails --action1 "echo %f" "$FOLDER" 2>/dev/null | head -n 1)
    else 
        CHOICE=$(printf "Random\n%s\n" "$(command ls -v "$FOLDER" | grep -v '^\.' )" | dmenu -c -l 15 -i -p "Wallpaper:")
        [[ "$CHOICE" != "Random" && -n "$CHOICE" ]] && CHOICE="$FOLDER/$CHOICE"
    fi

    case "$CHOICE" in
        Random) wal -i "$FOLDER" -o "$SCRIPT" ;;
        *.*) wal -i "$CHOICE" -o "$SCRIPT" ;;
        *) exit 0 ;;
    esac
}

# If given arguments:
# First argument will be used as wallpaper or directory
# Second argument is the pywal theme (optional)
case "$#" in
    0) menu ;;
    1) wal -i "$1" -o "$SCRIPT" ;;
    2) wal -i "$1" --theme "$2" -o "$SCRIPT" ;;
    *) exit 0 ;;
esac

