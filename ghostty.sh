#!/bin/bash

# Continuously monitor for Ghostty windows and fullscreen them as they appear
while true; do
    # Get all visible Ghostty clients (by class)
    ghostty_clients=$(hyprctl clients -j | jq -r '.[] | select(.class == "ghostty") | .address')

    for addr in $ghostty_clients; do
        # Fullscreen using class name (this should affect all Ghostty windows)
        hyprctl dispatch fullscreen ghostty
    done

    # Run as fast as possible — remove this line if you want zero delay
    # sleep 0.1
done

