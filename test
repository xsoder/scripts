# Stop and disable the timer
systemctl --user stop wallpaper.timer
systemctl --user disable wallpaper.timer

# Remove the timer and service files
rm -f ~/.config/systemd/user/wallpaper.timer
rm -f ~/.config/systemd/user/wallpaper.service

# Reload user systemd
systemctl --user daemon-reload

