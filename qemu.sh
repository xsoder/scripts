#!/bin/bash

echo "[!] This will FORCE REMOVE all QEMU-related packages using pacman -Rdd."
read -p "Type YES to proceed: " confirm

if [[ "$confirm" != "YES" ]]; then
    echo "Aborted."
    exit 1
fi

# Find QEMU-related packages
echo "[*] Finding installed QEMU-related packages..."
qemu_pkgs=$(pacman -Q | grep -i qemu | awk '{print $1}')

if [[ -z "$qemu_pkgs" ]]; then
    echo "No QEMU packages found."
    exit 0
fi

echo "[*] The following packages will be removed WITHOUT dependency checks:"
echo "$qemu_pkgs"
echo

read -p "Are you REALLY sure? Type REMOVE to confirm: " really

if [[ "$really" != "REMOVE" ]]; then
    echo "Aborted."
    exit 1
fi

# Remove packages
sudo pacman -Rdd --noconfirm $qemu_pkgs

echo "[✓] QEMU packages removed. System dependencies may now be broken."

