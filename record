#!/bin/bash

save_dir="$HOME/media/Videos/Recordings"
mkdir -p "$save_dir"
pidfile="/tmp/ffmpeg-screen-record.pid"

# === Stop if already recording ===
if [ -f "$pidfile" ]; then
    pid=$(cat "$pidfile")
    if kill -0 "$pid" 2>/dev/null; then
        kill -INT "$pid"
        sleep 1
        rm "$pidfile"
        notify-send "Recording stopped"
        exit 0
    else
        rm "$pidfile"
    fi
fi

# === Audio setup ===
audio_device=$(pactl get-default-sink)
if [ -n "$audio_device" ]; then
    audio_param="-f pulse -i ${audio_device}.monitor"
else
    audio_param=""
    notify-send "No audio device detected" "Recording without audio"
fi

# === Video setup ===
screen_size=$(xdpyinfo | awk '/dimensions:/ {print $2}')
filename="record_$(date '+%Y-%m-%d_%H-%M-%S').mkv"
filepath="$save_dir/$filename"

# Lossless / highest quality video options:
# -crf 0: lossless quality (large file size)
# -preset veryslow: best compression quality (takes longer to encode)
# -pix_fmt yuv420p for compatibility, or yuv444p for no chroma subsampling (larger files, better color)
ffmpeg_opts="-c:v libx264 -crf 0 -preset veryslow -pix_fmt yuv420p -c:a flac"

notify-send "Recording started" "Saving to $filename"

setsid bash -c "exec ffmpeg -y \
  -video_size \"$screen_size\" \
  -framerate 30 \
  -f x11grab -i :0.0 \
  $audio_param \
  $ffmpeg_opts \
  \"$filepath\"" &> /tmp/ffmpeg-record.log &

echo $! > "$pidfile"

