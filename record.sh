#!/bin/bash

save_dir="$HOME/Videos/Recordings"
mkdir -p "$save_dir"
pidfile="/tmp/wf-record-screen.pid"

# Stop recording if already running
if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
    kill "$(cat "$pidfile")"
    rm "$pidfile"
    notify-send "Screen recording stopped"
    exit 0
fi

# Get default audio sink
audio_device=$(pactl get-default-sink)
if [ -n "$audio_device" ]; then
    audio_param="--audio=${audio_device}.monitor"
else
    audio_param=""
    notify-send "Audio device not detected" "Recording without audio"
fi

# Output filename
filename="record_fullscreen_$(date '+%Y-%m-%d_%H-%M-%S').mp4"
filepath="$save_dir/$filename"

# Start recording
if wf-recorder -f "$filepath" $audio_param &> /tmp/wf-recorder.log & then
    echo $! > "$pidfile"
    notify-send "Full screen recording started" "File: $filename"
else
    notify-send "Failed to start recording" "Check /tmp/wf-recorder.log for details"
    exit 1
fi

