#!/bin/bash

# Directory containing your scripts
SCRIPTS_DIR="$HOME/scripts"

# Get all regular (non-hidden) files
scripts=$(find "$SCRIPTS_DIR" -maxdepth 1 -type f -printf "%f\n")

# TokyoNight colors (storm variant)
DMENU_FONT="JetBrainsMono Nerd Font-12"
DMENU_NB="#1a1b26"  # Normal background
DMENU_NF="#c0caf5"  # Normal foreground
DMENU_SB="#7aa2f7"  # Selected background
DMENU_SF="#1a1b26"  # Selected foreground

# Run dmenu and store selected item
selected=$(echo "$scripts" | dmenu -i -l 10 -p "Run script:" \
  -fn "$DMENU_FONT" \
  -nb "$DMENU_NB" -nf "$DMENU_NF" \
  -sb "$DMENU_SB" -sf "$DMENU_SF")

# If something was selected, execute it
[ -n "$selected" ] && "$SCRIPTS_DIR/$selected"


