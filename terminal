#!/bin/bash
RECORD_DIR="$HOME/media/terminal"
mkdir -p "$RECORD_DIR"


PID_FILE="$RECORD_DIR/st_recording.pid"

if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  if ps -p "$PID" > /dev/null 2>&1; then
    kill "$PID"
    rm "$PID_FILE"
    notify-send "Terminal Recording" "Recording stopped."
    exit 0
  else
    rm "$PID_FILE"
  fi
fi

OUTPUT="$RECORD_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mkv"

WIN_ID=$(xdotool search --onlyvisible --class ghostty | head -n 1)

if [ -z "$WIN_ID" ]; then
  notify-send "Terminal Recording" " Could not find ST terminal window."
  exit 1
fi

eval $(xdotool getwindowgeometry --shell "$WIN_ID")
notify-send "Terminal Recording" " Recording started. Run script again to stop."

ffmpeg -y -video_size ${WIDTH}x${HEIGHT} -framerate 30 -f x11grab -i $DISPLAY+$X,$Y "$OUTPUT" &
echo $! > "$PID_FILE"

