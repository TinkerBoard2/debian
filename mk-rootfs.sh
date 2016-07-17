#!/bin/bash -e

# Directory contains the target rootfs
TARGET_ROOTFS_DIR="rootfs"

sudo apt-get install multistrap qemu qemu-user-static binfmt-support dpkg-cross

sudo multistrap -a armhf -f rk-debian.conf

sudo cp -rf packages $TARGET_ROOTFS_DIR/
sudo cp -rf overlay $TARGET_ROOTFS_DIR/
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/