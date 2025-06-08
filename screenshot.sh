#!/bin/bash

save_dir="$HOME/media/Picture/screenshot"
mkdir -p "$save_dir"

# Generate timestamped filename
filename="screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"
filepath="$save_dir/$filename"

# Take screenshot, copy to clipboard, and save
grim -g "$(slurp)" "$filepath"
cat "$filepath" | wl-copy

# Notification
notify-send "Screenshot" "Saved to $filepath and copied to clipboard" -i camera

