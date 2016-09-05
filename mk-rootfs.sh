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
sudo mkdir $TARGET_ROOTFS_DIR/packages
sudo cp -rf packages/$ARCH/* $TARGET_ROOTFS_DIR/packages
sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
sudo cp -rf overlay-firmware/* $TARGET_ROOTFS_DIR/

if [ "$VERSION" == "debug" ] ; then
	sudo cp -rf overlay-debug/* $TARGET_ROOTFS_DIR/
fi

echo "Change root....................."
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev

cat << EOF | sudo chroot $TARGET_ROOTFS_DIR
chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
apt-get update

#---------------Xserver-------------- 
apt-get install -y libgcrypt20  libdbus-1-3  libdbus-1-dev -t testing
apt-get remove -y xserver-xorg
apt-get install -y -t testing xserver-xorg-core 
apt-get install -y -t testing xserver-xorg-input-evdev
apt-get install -y -t testing libepoxy0

dpkg -i  /packages/xserver-common_*_all.deb 
dpkg -i  /packages/xserver-xorg-core_*_armhf.deb

#---------------LIBDRM-------------- 
dpkg -i  /packages/libdrm/*

#---------------Video-Vaapi-------------- 
apt-get install -y  -t testing gstreamer1.0-vaapi gstreamer1.0-tools libvdpau1 libva1 \
	 libva-wayland1 gstreamer1.0-alsa gstreamer1.0-plugins-good 	\
	 gstreamer1.0-plugins-bad alsa-utils vdpau-va-driver gstreamer1.0-x
dpkg -i  /packages/video/gstreamer1.0-vaapi_1.8.3-1_armhf.deb
dpkg -i  /packages/video/libva-rockchip*_armhf.deb
# dpkg -i  /packages/video/rockchip-vdpau-drivers_*_armhf.deb
apt-get install -f -y

#---------------Debug-------------- 
if [ "$VERSION" == "debug" ] ; then
	apt-get install -y sshfs openssh-server -t testing 
fi

#---------------Custom Script-------------- 
chmod +x /etc/init.d/rockchip.sh 
ln -s /etc/init.d/rockchip.sh /etc/rcS.d/S11rockchip.sh

#---------------Clean-------------- 
rm -rf /var/lib/apt/lists/*
rm -rf /libs

EOF

sudo umount $TARGET_ROOTFS_DIR/dev

