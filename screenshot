#!/bin/bash

save_dir="$HOME/media/Picture/screenshot"
mkdir -p "$save_dir"

filename="screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"
filepath="$save_dir/$filename"

if ! scrot -s "$filepath" > /dev/null 2>&1; then
    notify-send "Screenshot" "Cancelled or failed to take screenshot" -i dialog-warning
    exit 1
fi

if ! xclip -selection clipboard -t image/png -i "$filepath" > /dev/null 2>&1; then
    notify-send "Screenshot" "Cancelled or failed to take screenshot" -i dialog-warning
    exit 1
fi

notify-send "Screenshot" "Saved to $filepath and copied to clipboard" -i camera

