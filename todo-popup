#!/bin/bash

WIDTH=480
HEIGHT=480

# Determine today's file path
TODAY=$(date +"%Y-%m-%d")
NOTES_DIR=~/notes
TODO_FILE="$NOTES_DIR/todo-$TODAY.md"

# Ensure the notes directory exists
mkdir -p "$NOTES_DIR"

# Create file with template if it doesn't exist
if [ ! -f "$TODO_FILE" ]; then
  {
    echo "# Todo"
    echo "# Completed"
  } > "$TODO_FILE"
fi

# Launch Ghostty and capture its PID
ghostty -e bash -lc "cd ~/notes && nvim '$TODO_FILE'" >/dev/null 2>&1 &
GHOSTTY_PID=$!

# Wait for the window to appear and be associated with the PID
for _ in {1..20}; do
  WIN_ID=$(xdotool search --pid "$GHOSTTY_PID" 2>/dev/null | tail -1)
  if [ -n "$WIN_ID" ]; then break; fi
  sleep 0.2
done

if [ -z "$WIN_ID" ]; then
  echo "Error: Could not find Ghostty window for PID $GHOSTTY_PID" >&2
  exit 1
fi

# Float, resize, and move the window using i3
i3-msg "[id=$WIN_ID] floating enable"
i3-msg "[id=$WIN_ID] resize set $WIDTH $HEIGHT"

# Calculate top-right position
read SCREEN_WIDTH SCREEN_HEIGHT < <(xdotool getdisplaygeometry)
X_POS=$((SCREEN_WIDTH - WIDTH))  # 10px padding
Y_POS=0

i3-msg "[id=$WIN_ID] move position $X_POS $Y_POS"
i3-msg "[id=$WIN_ID] focus"

