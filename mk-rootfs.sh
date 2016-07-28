#!/bin/bash -e

# Directory contains the target rootfs
export TARGET_ROOTFS_DIR="binary"

if [ ! -e linaro-jessie-alip-*.tar.gz ]; then 
	echo Download linaro rootfs
	wget https://releases.linaro.org/debian/images/alip-armhf/latest/linaro-jessie-alip-20160620-25.tar.gz
fi

echo Extract image
sudo tar -xpf linaro-jessie-alip-*.tar.gz

echo Copy overlay to rootfs
sudo cp -rf packages $TARGET_ROOTFS_DIR/
sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
if [ "$1" == "develop" ] ; then
	sudo cp -rf develop/* $TARGET_ROOTFS_DIR/
fi

echo Change root.....................
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev

# setup rk enviorment
cat << EOF | sudo chroot $TARGET_ROOTFS_DIR
chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
apt-get update

# xserver
apt-get install -y libgcrypt20:armhf  libdbus-1-3:armhf -t testing libdbus-1-dev
apt-get remove -y xserver-xorg
apt-get install -y -t testing xserver-xorg-core 
apt-get install -y -t testing xserver-xorg-input-evdev
apt-get install -y -t testing libepoxy0

dpkg -i  /packages/xserver-common_1.18.21-2_all.deb 
dpkg -i  /packages/xserver-xorg-core_1.18.21-2_armhf.deb

# drm
dpkg -i  /packages/libdrm/*

# video 
apt-get install -y gstreamer1.0-vaapi gstreamer1.0-tools libvdpau1 libva1 \
	 libva-wayland1 gstreamer1.0-alsa gstreamer1.0-plugins-good 	\
	 gstreamer1.0-plugins-bad libdbus-1-dev alsa-utils vdpau-va-driver
dpkg -i  /packages/libva-rockchip1_0.20-1_armhf.deb
dpkg -i  /packages/rockchip-vdpau-drivers_0.20-1_armhf.deb

apt-get install -f -y

# Prepare VDPAU VAAPI enviorment
cp /libs/test.mp4 /usr/local/
cp /libs/test_* /usr/local/bin/
cp /libs/statistics.sh /usr/local/bin/

cp /libs/vdpau_drv_video.so /usr/lib/arm-linux-gnueabihf/dri/vdpau_drv_video.so
cp /libs/libgstvaapi.so /libs/libgstvaapi_parse.so /usr/lib/arm-linux-gnueabihf/gstreamer-1.0/
cp -rf /libs/gstvaapi/* /usr/lib/arm-linux-gnueabihf/

# for develop
apt-get install -y sshfs openssh-server -t testing 

rm -rf /var/lib/apt/lists/*
rm -rf /libs
#rm -rf /packages

EOF

sudo umount $TARGET_ROOTFS_DIR/dev

