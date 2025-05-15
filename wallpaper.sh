
#!/bin/bash

WALLPAPER_DIR="$HOME/wallpaper/wallpapers"

INTERVAL=1800

SET_WALLPAPER_CMD="feh --bg-scale"

if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Directory $WALLPAPER_DIR does not exist."
  exit 1
fi

while true; do
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.jpeg' \) | shuf -n 1)

  if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR."
    exit 1
  fi

  $SET_WALLPAPER_CMD "$WALLPAPER"
  sleep $INTERVAL
done

