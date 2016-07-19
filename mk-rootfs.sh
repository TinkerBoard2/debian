#!/bin/bash -e

# Directory contains the target rootfs
export TARGET_ROOTFS_DIR="binary"

if [ ! -e linaro-jessie-alip-*.tar.gz ]; then 
	wget https://releases.linaro.org/debian/images/alip-armhf/latest/linaro-jessie-alip-20160620-25.tar.gz
fi

sudo tar -xpf linaro-jessie-alip-*.tar.gz

export TARGET_ROOTFS_DIR="binary"
sudo cp -rf packages $TARGET_ROOTFS_DIR/
sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
# sudo cp -rf 3288/* $TARGET_ROOTFS_DIR/
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/

sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev


# setup rk enviorment
cat << EOF | sudo chroot $TARGET_ROOTFS_DIR

chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
cd /libs/
bash ./prepare.sh

setcap CAP_SYS_ADMIN+ep /usr/bin/gst-launch-1.0

apt-get update

#apt-get remove libgbm1:armhf libgles2-mesa:armhf libegl1-mesa:armhf

apt-get install -y libgcrypt20:armhf  libdbus-1-3:armhf -t testing libdbus-1-dev
apt-get install -t testing xserver-xorg
apt-get install -t testing libepoxy0

# dpkg -i  /packages/libmali-rk32881_1.4-3_armhf.deb
# dpkg -i  /packages/libmali-rk3288-dev_1.4-3_armhf.deb
# dpkg -i /packages/xserver-common_1.18.21-2_all.deb 
# dpkg -i  /packages/xserver-xorg-core_1.18.21-2_armhf.deb
# dpkg -i  /packages/libdrm-rockchip1_2.4.68-2_armhf.deb
# dpkg -i  /packages/libdrm2_2.4.68-2_armhf.deb

# ln -s /usr/bin/Xorg /usr/bin/X

# rm -rf /var/lib/apt/lists/*
# rm -rf /packages
# rm -rf /libs

EOF

sudo cp -rf 3288/* $TARGET_ROOTFS_DIR/

sudo umount $TARGET_ROOTFS_DIR/dev

