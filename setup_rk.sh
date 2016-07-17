#!/bin/bash
export TARGET_ROOTFS_DIR="rootfs"

sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev
sudo chroot rootfs dpkg --configure -a

sudo echo rockchip > $TARGET_ROOTFS_DIR/etc/hostname

echo "I: create debian user"
sudo chroot rootfs adduser --gecos debian

echo "I: set debian user password"
echo "debian:debian" | chpasswd


sudo umount $TARGET_ROOTFS_DIR/dev