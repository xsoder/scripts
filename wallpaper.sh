#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/tokyo"

# Interval in seconds (5 minutes = 300 seconds)
INTERVAL=1800

# Command to set wallpaper (e.g., feh, nitrogen, etc.)
# Replace `feh` with the appropriate command for your system
SET_WALLPAPER_CMD=""

# Ensure the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Directory $WALLPAPER_DIR does not exist."
  exit 1
fi

# Infinite loop to change wallpaper every INTERVAL seconds
while true; do
  # Select a random image from the directory
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.jpeg' \) | shuf -n 1)

  # Check if a wallpaper was found
  if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR."
    exit 1
  fi

  # Set the wallpaper
  $SET_WALLPAPER_CMD "$WALLPAPER"

  # Wait for the specified interval
  sleep $INTERVAL
done

