#!/bin/sh
set -xe
ISO_PATH="$HOME/VM/alpine.iso"
QCOW2_IMAGE="$HOME/VM/alpinw.qcow2"

# Check if the image exists
if [ ! -f "$QCOW2_IMAGE" ]; then
    echo "Creating new disk image..."
    qemu-img create -f qcow2 "$QCOW2_IMAGE" 60G
    echo "Launching installation from ISO..."
    qemu-system-x86_64 -enable-kvm \
                       -m 8000 \
                       -cdrom "$ISO_PATH" \
                       -drive file="$QCOW2_IMAGE",if=virtio \
                       -boot d \
                       -netdev user,id=net0,hostfwd=tcp::2222-:22 \
                       -device virtio-net-pci,netdev=net0 \
                       -vga qxl \
                       -spice port=5930,addr=127.0.0.1,disable-ticketing=on \
                       -device virtio-serial-pci \
                       -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
                       -chardev spicevmc,id=spicechannel0,name=vdagent \
                       -device ich9-intel-hda \
                       -device hda-micro,audiodev=hda \
                       -audiodev spice,id=hda \
                       -monitor stdio
else
    echo "Booting from existing disk..."
    qemu-system-x86_64 -enable-kvm \
                       -m 8000 \
                       -drive file="$QCOW2_IMAGE",if=virtio \
                       -boot c \
                       -netdev user,id=net0,hostfwd=tcp::2222-:22 \
                       -device virtio-net-pci,netdev=net0 \
                       -vga qxl \
                       -spice port=5930,addr=127.0.0.1,disable-ticketing=on \
                       -device virtio-serial-pci \
                       -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
                       -chardev spicevmc,id=spicechannel0,name=vdagent \
                       -device ich9-intel-hda \
                       -device hda-micro,audiodev=hda \
                       -audiodev spice,id=hda \
                       -monitor stdio
fi
