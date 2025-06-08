#!/bin/bash

# === CONFIG ===
SCRIPT_DIR="$HOME/scripts"
SCRIPT_PATH="$SCRIPT_DIR/wallpaper.sh"
WALLPAPER_DIR="$HOME/devenv/wallpaper/gruvbox"
STATE_FILE="$HOME/.cache/current_wallpaper.txt"
SERVICE_NAME="wallpaper"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

# === CREATE WALLPAPER SCRIPT ===
mkdir -p "$SCRIPT_DIR"

cat > "$SCRIPT_PATH" <<EOF
#!/bin/bash

WALLPAPER_DIR="$WALLPAPER_DIR"
STATE_FILE="$STATE_FILE"

mapfile -t WALLPAPERS < <(find "\$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)
if [ \${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Switcher" "No wallpapers found in \$WALLPAPER_DIR"
    exit 1
fi

LAST_WALLPAPER=\$(cat "\$STATE_FILE" 2>/dev/null)
INDEX=0
for i in "\${!WALLPAPERS[@]}"; do
    if [[ "\${WALLPAPERS[\$i]}" == "\$LAST_WALLPAPER" ]]; then
        INDEX=\$(( (\$i + 1) % \${#WALLPAPERS[@]} ))
        break
    fi
done

NEXT_WALLPAPER="\${WALLPAPERS[\$INDEX]}"
swww img "\$NEXT_WALLPAPER" --transition-type any --transition-duration 1.0
echo "\$NEXT_WALLPAPER" > "\$STATE_FILE"
notify-send "Wallpaper Changed" "Set to: \$(basename "\$NEXT_WALLPAPER")"
EOF

chmod +x "$SCRIPT_PATH"

# === CREATE SYSTEMD SERVICE ===
mkdir -p "$SYSTEMD_USER_DIR"

cat > "$SYSTEMD_USER_DIR/$SERVICE_NAME.service" <<EOF
[Unit]
Description=Switch wallpaper using swww

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
EOF

# === CREATE SYSTEMD TIMER ===
cat > "$SYSTEMD_USER_DIR/$SERVICE_NAME.timer" <<EOF
[Unit]
Description=Run wallpaper switcher every 5 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
EOF

# === RELOAD AND START TIMER ===
systemctl --user daemon-reload
systemctl --user enable --now "$SERVICE_NAME.timer"

echo "✅ Wallpaper switching timer set up!"
echo "⏰ Changes every 5 minutes. Script path: $SCRIPT_PATH"

