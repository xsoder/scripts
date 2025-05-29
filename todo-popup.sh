#!/bin/bash

WIDTH=480
HEIGHT=480

# Calculate X and Y for top-right
SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
XOFFSET=$((SCREEN_WIDTH - WIDTH - 10))  # 10px padding from edge
YOFFSET=10 

# Launch Alacritty running Neovim on todo file
alacritty \
  --class todo_popup \
  --title "TodoPopup" \
  --command nvim ~/notes/todo.md &

# Give it time to appear
sleep 0.3

# Get window ID
WIN_ID=$(xdotool search --name "TodoPopup" | tail -1)

# Resize and move
xdotool windowsize "$WIN_ID" $WIDTH $HEIGHT
xdotool windowmove "$WIN_ID" $XOFFSET $YOFFSET

