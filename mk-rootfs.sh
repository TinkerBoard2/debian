#!/bin/bash -e

# Directory contains the target rootfs
TARGET_ROOTFS_DIR="binary"
ARCH="armhf"
# none or debug(adb,ssh) or demo(more apps)
VERSION="debug"

if [ ! -e linaro-stretch-alip-*.tar.gz ]; then 
	echo "\033[36m Run mk-base-debian.sh first \033[0m"
fi

echo -e "\033[36m Extract image \033[0m"
sudo tar -xpf linaro-stretch-alip-*.tar.gz

echo -e "\033[36m Copy overlay to rootfs \033[0m"
sudo mkdir -p $TARGET_ROOTFS_DIR/packages
sudo cp -rf packages/$ARCH/* $TARGET_ROOTFS_DIR/packages
# some configs
sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
# bt,wifi,audio firmware
sudo cp -rf overlay-firmware/* $TARGET_ROOTFS_DIR/
if [ "$VERSION" == "debug" ] || [ "$VERSION" == "demo" ] ; then
	# adb, video, camera  test file
	sudo cp -rf overlay-debug/* $TARGET_ROOTFS_DIR/
fi
if [ "$VERSION" == "demo" ] ; then
	sudo cp -rf overlay-demo/* $TARGET_ROOTFS_DIR/
fi

echo -e "\033[36m Change root.....................\033[0m"
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev

cat << EOF | sudo chroot $TARGET_ROOTFS_DIR

chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
apt-get update

#---------------Work around debian bugs-------------- 
apt-get remove -y network-manager blueman
dpkg -i  /packages/bug-downgrade/*
systemctl enable NetworkManager.service

#---------------Xserver-------------- 
echo -e "\033[36m Setup Xserver.................... \033[0m"
dpkg -i  /packages/xserver-common_*_all.deb 
dpkg -i  /packages/xserver-xorg-core_*_armhf.deb
apt-get  remove -y xserver-xorg-video-fbdev  xserver-xorg
apt-get install -f -y

#---------------libdrm-------------- 
echo -e "\033[36m Setup libdrm.................... \033[0m"
dpkg -i  /packages/libdrm/*
apt-get install -f -y

#---------------Video-Vaapi-------------- 
echo -e "\033[36m Setup vaapi.................... \033[0m"
apt-get install -y gstreamer1.0-vaapi gstreamer1.0-tools libvdpau1 libva1 \
	 libva-wayland1 gstreamer1.0-alsa gstreamer1.0-plugins-good 	\
	 gstreamer1.0-plugins-bad alsa-utils vdpau-va-driver gstreamer1.0-x
dpkg -i  /packages/video/gstreamer1.0-vaapi_*_armhf.deb
dpkg -i  /packages/video/libva-rockchip*_armhf.deb
apt-get install -f -y

#---------------Debug-------------- 
if [ "$VERSION" == "debug" ] || [ "$VERSION" == "demo" ] ; then
	apt-get install -y sshfs openssh-server bash-completion 
fi

#---------------Custom Script-------------- 
chmod +x /etc/init.d/rockchip.sh 
systemctl enable rockchip.service

#---------------Demo-------------- 
if [ "$VERSION" == "demo" ] ; then
	apt-get install -y xserver-xorg-input-synaptics
	apt-get install -y cheese fswebcam
fi

#---------------Clean-------------- 
rm -rf /var/lib/apt/lists/*

EOF

sudo umount $TARGET_ROOTFS_DIR/dev