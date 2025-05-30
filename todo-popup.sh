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

# Launch Alacritty as a floating window in i3
alacritty \
  --class "todo_popup" \
  --title "TodoPopup" \
  -e bash -c "nvim '$TODO_FILE'" &

# Wait for the window to appear
sleep 0.5

# Get the window ID
WIN_ID=$(xdotool search --class "todo_popup" | tail -1)

if [ -z "$WIN_ID" ]; then
  echo "Error: Could not find window!" >&2
  exit 1
fi

# Make it floating and set properties in i3
i3-msg "[id=$WIN_ID] floating enable"
i3-msg "[id=$WIN_ID] resize set $WIDTH $HEIGHT"

# Calculate position (top-right corner)
SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
X_POS=$((SCREEN_WIDTH - WIDTH ))  # 10px padding from the right edge
Y_POS=0  # 30px padding from the top

i3-msg "[id=$WIN_ID] move position $X_POS $Y_POS"

# Focus the window (optional)
i3-msg "[id=$WIN_ID] focus"
