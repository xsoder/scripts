#!/bin/bash

# Use fzf to search for files
selected_file=$(fzf --preview 'bat --color=always {}' --preview-window 'right:60%')

# Check if a file was selected
if [ -n "$selected_file" ]; then
    # Open the selected file in Neovim
    nvim "$selected_file"
else
    echo "No file selected."
fi
