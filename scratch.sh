#!/bin/bash
set -euo pipefail

die() {
    echo -e "\e[1;31mERROR: $1\e[0m" >&2
    exit 1
}

[ "$EUID" -eq 0 ] || die "Run as root"

KVER=$(uname -r)
MODDIR="/lib/modules/$KVER"

make clean

# Ignore failures if modules are not loaded
modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia_peermem nvidia || true

# Remove any previously installed NVIDIA modules
rm -f "$MODDIR"/updates/dkms/nvidia*.ko
rm -f "$MODDIR"/kernel/drivers/video/nvidia*.ko

# Build and install
make -j"$(nproc)" modules
make modules_install

depmod -a

# Reload modules
modprobe nvidia
modprobe nvidia_uvm

echo
echo "Loaded module:"
modinfo nvidia_uvm | grep -E 'filename|version'