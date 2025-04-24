#!/bin/bash

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # For Wayland/Sway
    wl-paste -t text --watch clipman store
else
    # For X11/i3
    xclip -selection clipboard &
    clipman &
fi
