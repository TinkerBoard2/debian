#!/bin/bash -e

# Directory contains the target rootfs
export TARGET_ROOTFS_DIR="binary"
export ARCH="armhf"
export VERSION="debug"

if [ ! -e linaro-jessie-alip-*.tar.gz ]; then 
	echo Download linaro rootfs
	wget https://releases.linaro.org/debian/images/alip-armhf/16.07/linaro-jessie-alip-20160722-27.tar.gz
fi

echo "Extract image"
sudo tar -xpf linaro-jessie-alip-*.tar.gz

echo "Copy overlay to rootfs"
sudo cp -rf packages/$ARCH/* $TARGET_ROOTFS_DIR/packages
sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
sudo cp -rf overlay-firmware/* $TARGET_ROOTFS_DIR/

if [ "$VERSION" == "debug" ] ; then
	sudo cp -rf overlay-debug/* $TARGET_ROOTFS_DIR/
	apt-get install -y sshfs openssh-server -t testing 
fi

echo "Change root....................."
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev

# setup rk enviorment
cat << EOF | sudo chroot $TARGET_ROOTFS_DIR
chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
apt-get update

# xserver
apt-get install -y libgcrypt20  libdbus-1-3 -t testing libdbus-1-dev
apt-get remove -y xserver-xorg
apt-get install -y -t testing xserver-xorg-core 
apt-get install -y -t testing xserver-xorg-input-evdev
apt-get install -y -t testing libepoxy0

dpkg -i  /packages/xserver-common_*_all.deb 
dpkg -i  /packages/xserver-xorg-core_*_armhf.deb

# drm
dpkg -i  /packages/libdrm/*

# video 
apt-get install -y gstreamer1.0-vaapi gstreamer1.0-tools libvdpau1 libva1 \
	 libva-wayland1 gstreamer1.0-alsa gstreamer1.0-plugins-good 	\
	 gstreamer1.0-plugins-bad libdbus-1-dev alsa-utils vdpau-va-driver
dpkg -i  /packages/libva-rockchip1_*_armhf.deb
dpkg -i  /packages/rockchip-vdpau-drivers_*_armhf.deb

apt-get install -f -y

# Prepare VDPAU VAAPI enviorment
cp /libs/test.mp4 /usr/local/
cp /libs/test_* /usr/local/bin/
cp /libs/statistics.sh /usr/local/bin/
cp /libs/vdpau_drv_video.so /usr/lib/arm-linux-gnueabihf/dri/vdpau_drv_video.so
cp /libs/libgstvaapi.so /libs/libgstvaapi_parse.so /usr/lib/arm-linux-gnueabihf/gstreamer-1.0/
cp -rf /libs/gstvaapi/* /usr/lib/arm-linux-gnueabihf/

chmod +x /etc/init.d/rockchip.sh 
ln -s /etc/init.d/rockchip.sh /etc/rcS.d/S11rockchip.sh

if [ "$VERSION" == "debug" ] ; then
	sudo cp -rf overlay-debug/* $TARGET_ROOTFS_DIR/
fi

rm -rf /var/lib/apt/lists/*
rm -rf /libs

EOF

sudo umount $TARGET_ROOTFS_DIR/dev

