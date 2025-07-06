#!/bin/bash

save_dir="$HOME/media/Videos/Recordings"
mkdir -p "$save_dir"
pidfile="/tmp/wf-record-window.pid"

# Stop existing recording if running
if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
    kill "$(cat "$pidfile")"
    rm "$pidfile"
    notify-send "Window recording stopped"
    exit 0
fi

# Method 1: Try using hyprctl activewindow for the focused window
echo "Select the window you want to record and press Enter..."
read -p "Press Enter when the target window is focused: "

# Get the currently active window
active_window=$(hyprctl activewindow -j)
if [ "$active_window" = "Invalid" ] || [ -z "$active_window" ]; then
    notify-send "No active window found"
    exit 1
fi

# Extract geometry
x=$(echo "$active_window" | jq -r '.at[0]')
y=$(echo "$active_window" | jq -r '.at[1]')
width=$(echo "$active_window" | jq -r '.size[0]')
height=$(echo "$active_window" | jq -r '.size[1]')
title=$(echo "$active_window" | jq -r '.title')

# Alternative geometry formats to try
geometry1="${x},${y} ${width}x${height}"
geometry2="${width}x${height}+${x}+${y}"

echo "Window: $title"
echo "Trying geometry format 1: $geometry1"

# Get audio device
audio_device=$(pactl get-default-sink 2>/dev/null)
if [ -n "$audio_device" ]; then
    audio_param="--audio=${audio_device}.monitor"
else
    audio_param=""
fi

filename="record_window_$(date '+%Y-%m-%d_%H-%M-%S').mp4"
filepath="$save_dir/$filename"

# Try first geometry format
if wf-recorder -g "$geometry1" -f "$filepath" $audio_param &> /tmp/wf-recorder1.log & then
    recorder_pid=$!
    echo $recorder_pid > "$pidfile"
    
    # Wait a moment and check if it's actually recording the right area
    sleep 3
    
    # Take a screenshot to verify the recording area
    temp_screenshot="/tmp/recording_test.png"
    grim -g "$geometry1" "$temp_screenshot" 2>/dev/null
    
    if [ -f "$temp_screenshot" ]; then
        notify-send "Window recording started" "Recording: $title"
        rm "$temp_screenshot"
    else
        # Kill the recorder and try second format
        kill $recorder_pid 2>/dev/null
        rm "$pidfile"
        
        echo "First format failed, trying geometry format 2: $geometry2"
        
        if wf-recorder -g "$geometry2" -f "${filepath%.*}_alt.mp4" $audio_param &> /tmp/wf-recorder2.log & then
            echo $! > "$pidfile"
            notify-send "Window recording started (alt format)" "Recording: $title"
        else
            notify-send "Both geometry formats failed" "Check logs in /tmp/"
            exit 1
        fi
    fi
else
    notify-send "Failed to start recording" "Check /tmp/wf-recorder1.log"
    exit 1
fi
