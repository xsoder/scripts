#!/bin/bash

echo "Updating system"
sudo apt update && sudo apt upgrade -y

echo "Clearing apt cache"
apt_cache_space_used="$(du -sh /var/cache/apt/archives/)"
sudo apt clean
echo "Space saved: $apt_cache_space_used"

echo "Removing orphan packages"
sudo apt autoremove --purge -y

echo "Clearing ~/.cache"
home_cache_used="$(du -sh ~/.cache)"
rm -rf ~/.cache/
echo "Space saved: $home_cache_used"

echo "Clearing system logs (older than 7 days)"
sudo journalctl --vacuum-time=7d

