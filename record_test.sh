#!/bin/bash

save_dir="$HOME/Videos/Recordings"
mkdir -p "$save_dir"
pidfile="/tmp/wf-record-window.pid"

# Stop existing recording if running
if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
    kill "$(cat "$pidfile")"
    rm "$pidfile"
    notify-send "Window recording stopped"
    exit 0
fi

# Get list of windows with better formatting
windows=$(hyprctl clients -j | jq -r '.[] | select(.title != null and .title != "") | "\(.title)|\(.address)"')

if [ -z "$windows" ]; then
    notify-send "No windows available for recording"
    exit 1
fi

# Format for rofi display (show only titles)
window_titles=$(echo "$windows" | cut -d'|' -f1)

# Select window via rofi
selected_title=$(echo "$window_titles" | rofi -dmenu -i -p "Select window to record:")

if [ -z "$selected_title" ]; then
    notify-send "Recording cancelled"
    exit 1
fi

# Find the corresponding address
address=$(echo "$windows" | grep -F "$selected_title" | cut -d'|' -f2 | head -n1)

if [ -z "$address" ]; then
    notify-send "Could not determine window address"
    exit 1
fi

# Get current audio sink (auto-detect)
audio_device=$(pactl get-default-sink)
if [ -n "$audio_device" ]; then
    audio_param="--audio=${audio_device}.monitor"
else
    # Fallback to no audio if detection fails
    audio_param=""
    notify-send "Audio device not detected" "Recording without audio"
fi

filename="record_window_$(date '+%Y-%m-%d_%H-%M-%S').mp4"
filepath="$save_dir/$filename"

# Debug: Show what we're trying to record
echo "Recording window: $selected_title"
echo "Window address: $address"
echo "Audio device: $audio_device"

# Start recording with error handling
if wf-recorder -w "$address" -f "$filepath" $audio_param &> /tmp/wf-recorder.log & then
    echo $! > "$pidfile"
    notify-send "Window recording started" "Recording: $selected_title"
    
    # Optional: Show a brief status after 2 seconds
    (
        sleep 2
        if kill -0 "$(cat "$pidfile")" 2>/dev/null; then
            notify-send "Recording active" "File: $filename"
        else
            notify-send "Recording failed" "Check /tmp/wf-recorder.log for details"
        fi
    ) &
else
    notify-send "Failed to start recording" "Check /tmp/wf-recorder.log for details"
    exit 1
fi
