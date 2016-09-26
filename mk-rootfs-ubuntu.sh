#!/bin/bash -e

# Directory contains the target rootfs
export TARGET_ROOTFS_DIR="binary"
export ARCH="armhf"

# none or debug(adb,ssh) or demo(more apps)
export VERSION="demo"

if [ ! -e ubuntu-base-16.04-core-armhf.tar.gz ]; then 
	echo Download ubuntu core rootfs
	wget http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/ubuntu-base-16.04-core-armhf.tar.gz
fi

echo "Extract image"
sudo tar -xpf ubuntu-base-16.04-core-armhf.tar.gz -C binary

echo "Copy overlay to rootfs"
sudo mkdir -p $TARGET_ROOTFS_DIR/packages
sudo cp -rf packages/$ARCH/* $TARGET_ROOTFS_DIR/packages

sudo cp -b /etc/resolv.conf  $TARGET_ROOTFS_DIR/etc/resolv.conf

echo "Change root....................."
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev

cat << EOF | sudo chroot $TARGET_ROOTFS_DIR
apt-get update
 
apt-get install -y xserver-xorg xserver-xorg-core xserver-xorg-input-evdev libepoxy0 libgcrypt20  libdbus-1-3  libdbus-1-dev \
	lightdm gstreamer1.0-tools libvdpau1 gstreamer1.0-alsa gstreamer1.0-plugins-good alsa-utils gstreamer1.0-x \
	gstreamer1.0-plugins-base  openssh-server 

apt-get install -y libdrm-dev 

dpkg -x /packages/xserver-common_*_all.deb  /
dpkg -x  /packages/xserver-xorg-core_*_armhf.deb /

dpkg -x  /packages/libmali/libmali-rk-midgard0_1.4-5_armhf.deb /
ln -s /usr/lib/arm-linux-gnueabihf/libgbm.so.1 /usr/lib/arm-linuxx-gnueabihf/libgbm.so   
rm -rf /usr/lib/arm-linux-gnueabihf/mesa-egl/*
# dpkg -x  /packages/libdrm/* /

# ubuntu don't have vaapi packages for armhf, so if you want to use rockchip vaapi library,
# you should build the needed packages by yourself. 
# For this reason, this script will not install our video packages.

# sudo apt-get install libva1 libva-wayland1 gstreamer1.0-vaapi vdpau-va-driver

#---------------Clean-------------- 
rm -rf /var/lib/apt/lists/*
rm -rf /libs

useradd -s '/bin/bash' -m -G adm,sudo rk
echo "Set password for rk:"
passwd rk
echo "Set password for root:"
passwd root

EOF

sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
sudo rm -f $TARGET_ROOTFS_DIR/etc/apt/sources.list.d/testing.list
sudo rm -f $TARGET_ROOTFS_DIR/etc/apt/preferences.d/default-pins.pref
sudo cp -rf overlay-firmware/* $TARGET_ROOTFS_DIR/

if [ "$VERSION" == "debug" ] || [ "$VERSION" == "demo" ] ; then
	sudo cp -rf overlay-debug/* $TARGET_ROOTFS_DIR/
fi
if [ "$VERSION" == "demo" ] ; then
	sudo cp -rf overlay-demo/* $TARGET_ROOTFS_DIR/
fi


sudo umount $TARGET_ROOTFS_DIR/dev
