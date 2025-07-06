#!/bin/bash

save_dir="$HOME/media/Picture/screenshot"
mkdir -p "$save_dir"
filename="screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"
filepath="$save_dir/$filename"
scrot "$filepath"
xclip -selection clipboard -t image/png -i "$filepath"
notify-send "Screenshot" "Saved to $filepath and copied to clipboard" -i camera
