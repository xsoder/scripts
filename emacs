#!/bin/bash

# Define directory and create it if it doesn't exist
RECORD_DIR="$HOME/media/emacs"
mkdir -p "$RECORD_DIR"

# File to store the PID of the ffmpeg process
PID_FILE="$RECORD_DIR/emacs_recording.pid"

# Check if ffmpeg is already running
if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  if ps -p "$PID" > /dev/null 2>&1; then
    kill "$PID"
    rm "$PID_FILE"
    notify-send "Emacs Recording" "⏹️ Recording stopped."
    exit 0
  else
    # Stale PID file
    rm "$PID_FILE"
  fi
fi

# Set output filename with timestamp
OUTPUT="$RECORD_DIR/emacs_recording_$(date +'%Y-%m-%d_%H-%M-%S').mkv"

# Get window ID of Emacs
WIN_ID=$(xdotool search --onlyvisible --class emacs | head -n 1)

if [ -z "$WIN_ID" ]; then
  notify-send "Emacs Recording" "❌ Could not find Emacs window."
  exit 1
fi

# Get window geometry
eval $(xdotool getwindowgeometry --shell "$WIN_ID")

# Notify user and start recording in background
notify-send "Emacs Recording" "🎥 Recording started. Run script again to stop."

ffmpeg -y -video_size ${WIDTH}x${HEIGHT} -framerate 30 -f x11grab -i $DISPLAY+$X,$Y "$OUTPUT" &

# Save PID
echo $! > "$PID_FILE"

