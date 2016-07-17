#!/bin/bash -e

# Directory contains the target rootfs
export TARGET_ROOTFS_DIR="binary"

wget https://releases.linaro.org/debian/images/alip-armhf/latest/linaro-jessie-alip-20160620-25.tar.gz
sudo tar -xpf linaro-jessie-alip-*.tar.gz

export TARGET_ROOTFS_DIR="binary"
sudo cp -rf packages $TARGET_ROOTFS_DIR/
sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/

sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev

# setup rk enviorment
cat << EOF | sudo chroot binary

apt-get update

apt-get install -y libgcrypt20:armhf -t testing
apt-get install -y xserver-xorg-core -t testing

dpkg --remove --force-depends libegl1-mesa:armhf
dpkg --remove --force-depends libgbm1:armhf libgles2-mesa:armhf

dpkg -i  /packages/xserver-xorg-core_1.18.21-1_armhf.deb
dpkg -i  /packages/libmali-rk32881_1.4-1_armhf.deb
dpkg -i  /packages/libmali-rk3288-dev_1.4-1_armhf.deb
dpkg -i  /packages/libdrm-rockchip1_2.4.68-2_armhf.deb
dpkg -i  /packages/libdrm2_2.4.68-2_armhf.deb

rm -rf /var/lib/apt/lists/*
rm -rf /packages
rm -rf /libs

EOF



sudo umount $TARGET_ROOTFS_DIR/dev

