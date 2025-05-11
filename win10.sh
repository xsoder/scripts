#!/bin/sh

set -xe

ISO_PATH="$HOME/Downloads/Win10.iso"
QCOW2_IMAGE="$HOME/OS/win.qcow2"

# Check if the image exists
if [ ! -f "$QCOW2_IMAGE" ]; then
    echo "Creating new disk image..."
    qemu-img create -f qcow2 "$QCOW2_IMAGE" 60G

    echo "Launching Windows installation..."
    qemu-system-x86_64 -enable-kvm \
                       -m 4096 \
                       -cdrom "$ISO_PATH" \
                       -hda "$QCOW2_IMAGE" \
                       -boot d \
                       -netdev user,id=net0 \
                       -device e1000,netdev=net0
else
    echo "Booting from existing disk..."
    qemu-system-x86_64 -enable-kvm \
                       -m 4096 \
                       -hda "$QCOW2_IMAGE" \
                       -boot c \
                       -netdev user,id=net0 \
                       -device e1000,netdev=net0
fi

