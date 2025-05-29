#!/bin/bash

WIDTH=480
HEIGHT=480

# Determine today's file path
TODAY=$(date +"%Y-%m-%d")
NOTES_DIR=~/notes
TODO_FILE="$NOTES_DIR/todo-$TODAY.md"

# Ensure the notes directory exists
mkdir -p "$NOTES_DIR"

# Check if file exists before
if [ ! -f "$TODO_FILE" ]; then
  # Create file and add template content
  {
    echo "# Todo"
    echo "# Completed"
  } > "$TODO_FILE"
fi

# Calculate X and Y for top-right
SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
XOFFSET=$((SCREEN_WIDTH - WIDTH - 3))  
YOFFSET=3

# Launch Alacritty running Neovim on today's todo file
alacritty \
  --class todo_popup \
  --title "TodoPopup" \
  -e bash -c "nvim '$TODO_FILE'" &

# Give it time to appear
sleep 0.3

# Get window ID
WIN_ID=$(xdotool search --name "TodoPopup" | tail -1)

# Resize and move
xdotool windowsize "$WIN_ID" $WIDTH $HEIGHT
xdotool windowmove "$WIN_ID" $XOFFSET $YOFFSET

