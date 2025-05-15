#!/bin/bash

# Starting directory (defaults to $HOME if not provided)
SEARCH_DIR="${1:-$HOME}"

# Use `find` to locate directories, ignoring .git
DIR=$(find "$SEARCH_DIR" -type d \( -name ".git" -o -path "*/.git/*" \) -prune -false -o -type d -print 2>/dev/null \
    | rofi -dmenu -p "Open Dir in Neovim")

# If a directory was selected
if [[ -n "$DIR" ]]; then
    # Open alacritty and run the `nvim` command in the selected directory
    alacritty -e bash -c "cd \"$DIR\" && nvim ."
fi

