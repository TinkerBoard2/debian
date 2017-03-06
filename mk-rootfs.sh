#!/bin/bash -e

# Directory contains the target rootfs
TARGET_ROOTFS_DIR="binary"

if [ ! $ARCH ]; then  
	ARCH='armhf'  
fi 
if [ ! $VERSION ]; then  
	VERSION="debug"
fi 

if [ ! -e linaro-stretch-alip-*.tar.gz ]; then 
	echo "\033[36m Run mk-base-debian.sh first \033[0m"
fi

finish() {
	sudo umount $TARGET_ROOTFS_DIR/dev
	exit -1
}
trap finish ERR

echo -e "\033[36m Extract image \033[0m"
sudo tar -xpf linaro-stretch-alip-*.tar.gz

echo -e "\033[36m Copy overlay to rootfs \033[0m"
sudo mkdir -p $TARGET_ROOTFS_DIR/packages
sudo cp -rf packages/$ARCH/* $TARGET_ROOTFS_DIR/packages
# some configs
sudo cp -rf overlay/* $TARGET_ROOTFS_DIR/
# bt,wifi,audio firmware
sudo cp -rf overlay-firmware/* $TARGET_ROOTFS_DIR/
if [ "$VERSION" == "debug" ] || [ "$VERSION" == "jenkins" ] ; then
	# adb, video, camera  test file
	sudo cp -rf overlay-debug/* $TARGET_ROOTFS_DIR/
fi

if  [ "$VERSION" == "jenkins" ] ; then
	# network
	sudo cp -b /etc/resolv.conf  $TARGET_ROOTFS_DIR/etc/resolv.conf
fi

echo -e "\033[36m Change root.....................\033[0m"
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev

cat << EOF | sudo chroot $TARGET_ROOTFS_DIR

chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
apt-get update

#---------------conflict workaround --------------
apt-get remove -y xserver-xorg-video-fbdev  xserver-xorg xserver-xorg-video-ati \
	xserver-xorg-video-amdgpu xserver-xorg-video-nouveau xserver-xorg-video-radeon \
	xserver-xorg-video-vesa libdrm-amdgpu1 libdrm-radeon1 libxfont2

apt-get install -y libxfont1 libinput-bin libinput10 libwacom-common libwacom2 libunwind8
dpkg -i  /packages/workaround/*
rm /lib/systemd/system/wpa_supplicant@.service

#---------------Xserver--------------
echo -e "\033[36m Setup Xserver.................... \033[0m"
[ -e /packages/xserver/xserver-common_*_all.deb ] && dpkg -i  /packages/xserver/xserver-common_*_all.deb
[ -e /packages/xserver/xserver-xorg-core_*_$ARCH.deb ] && dpkg -i  /packages/xserver/xserver-xorg-core_*_$ARCH.deb
apt-get install -f -y

#---------------libdrm--------------
echo -e "\033[36m Setup libdrm.................... \033[0m"
dpkg -i  /packages/libdrm/*
apt-get install -f -y

#---------------Video--------------
echo -e "\033[36m Setup vaapi.................... \033[0m"
apt-get install -y gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-alsa \
	gstreamer1.0-plugins-good  gstreamer1.0-plugins-bad alsa-utils gstreamer1.0-x \
	gstreamer1.0-pulseaudio
# [ -e /packages/video/gstreamer1.0-vaapi_*.deb  ] && dpkg -i  /packages/video/gstreamer1.0-vaapi_*.deb
# [ -e /packages/video/libva-rockchip*.deb  ] && dpkg -i  /packages/video/libva-rockchip*.deb

[ -e /packages/video/mpp/librockchip-mpp1_*_armhf.deb  ] && dpkg -i  /packages/video/mpp/librockchip-mpp1_*_armhf.deb
[ -e /packages/video/mpp/librockchip-mpp-dev_*_armhf.deb  ] && dpkg -i  /packages/video/mpp/librockchip-mpp-dev_*_armhf.deb
[ -e /packages/video/mpp/librockchip-vpu0_*_armhf.deb  ] && dpkg -i  /packages/video/mpp/librockchip-vpu0_*_armhf.deb
[ -e /packages/video/gstreamer1.0-rockchip*.deb  ] && dpkg -i  /packages/video/gstreamer1.0-rockchip*.deb
apt-get install -f -y

#---------------Qt-Video--------------
dpkg -l | grep lxde
if [ "$?" -eq 0 ]; then
	# if target is base, we won't install qt
	apt-get install  -y libqt5opengl5 libqt5qml5 libqt5quick5 libqt5widgets5 libqt5gui5 libqt5core5a qml-module-qtquick2
	dpkg -i  /packages/video/qt/*
	apt-get install -f -y
else
	echo 1
fi

#---------------Debug-------------- 
if [ "$VERSION" == "debug" ] || [ "$VERSION" == "jenkins" ] ; then
	apt-get install -y sshfs openssh-server bash-completion
fi

#---------------Custom Script-------------- 
systemctl enable rockchip.service
systemctl mask systemd-networkd-wait-online.service
systemctl mask NetworkManager-wait-online.service

#---------------Clean-------------- 
rm -rf /var/lib/apt/lists/*

EOF

sudo umount $TARGET_ROOTFS_DIR/dev