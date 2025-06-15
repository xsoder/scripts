#!/bin/bash

# Directory to save screenshots
save_dir="$HOME/media/Picture/screenshot"
mkdir -p "$save_dir"

# Generate timestamped filename
filename="screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"
filepath="$save_dir/$filename"

# Let user choose screenshot mode
mode=$(printf "Region\nWindow\nFullscreen" | dmenu -i -p "Select screenshot mode:")

# Take screenshot based on chosen mode
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

# Copy to clipboard
xclip -selection clipboard -t image/png -i "$filepath"

# Notify
notify-send "Screenshot" "Saved to $filepath and copied to clipboard" -i camera

