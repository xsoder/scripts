#!/bin/bash

save_dir="$HOME/media/Picture/screenshot"
mkdir -p "$save_dir"

filename="screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"
filepath="$save_dir/$filename"

mode=$(printf "Region\nWindow\nFullscreen" | dmenu -i -p "Select screenshot mode:")

case "$mode" in
  Region)
    scrot -s "$filepath"
    ;;
  Window)
    scrot -u "$filepath"
    ;;
  Fullscreen)
    scrot "$filepath"
    ;;
  *)
    notify-send "Screenshot" "Cancelled or invalid choice" -i dialog-warning
    exit 1
    ;;
esac

xclip -selection clipboard -t image/png -i "$filepath"

notify-send "Screenshot" "Saved to $filepath and copied to clipboard" -i camera

