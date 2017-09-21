#!/bin/bash -e

# Directory contains the target rootfs
TARGET_ROOTFS_DIR="binary"

if [ ! $ARCH ]; then  
	ARCH='armhf'  
fi 
if [ ! $VERSION ]; then  
	VERSION="debug"
fi 

if [ ! -e linaro-buster-alip-*.tar.gz ]; then 
	echo "\033[36m Run mk-base-debian.sh first \033[0m"
fi

finish() {
	sudo umount $TARGET_ROOTFS_DIR/dev
	exit -1
}
trap finish ERR

echo -e "\033[36m Extract image \033[0m"
sudo tar -xpf linaro-buster-alip-*.tar.gz

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

apt-get update

apt-get install -y systemd-sysv vi

#---------------ForwardPort Linaro overlay -------------- 
apt-get install -y e2fsprogs
wget http://repo.linaro.org/ubuntu/linaro-overlay/pool/main/l/linaro-overlay/linaro-overlay-minimal_1112.10_all.deb
wget http://repo.linaro.org/ubuntu/linaro-overlay/pool/main/9/96boards-tools/96boards-tools-common_0.9_all.deb
dpkg -i *.deb
rm -rf *.deb
apt-get install -f -y

#---------------TODO: USE DEB-------------- 
#---------------Setup Graphics-------------- 
apt-get install -y weston
cd /usr/lib/arm-linux-gnueabihf
wget https://github.com/rockchip-linux/libmali/raw/rockchip/lib/arm-linux-gnueabihf/libmali-midgard-r13p0-r0p0-wayland.so
ln -s libmali-midgard-r13p0-r0p0-wayland.so libmali-midgard-r13p0-r0p0-wayland.so
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libEGL.so
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libEGL.so.1
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libEGL.so.1.0.0
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libGLESv2.so
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libGLESv2.so.2
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libGLESv2.so.2.0.0
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libMaliOpenCL.so
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libOpenCL.so
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libgbm.so
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libgbm.so.1
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libgbm.so.1.0.0
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libwayland-egl.so
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libwayland-egl.so.1
ln -sf libmali-midgard-r13p0-r0p0-wayland.so libwayland-egl.so.1.0.0
cd /


#---------------Custom Script-------------- 
systemctl mask systemd-networkd-wait-online.service
systemctl mask NetworkManager-wait-online.service
rm /lib/systemd/system/wpa_supplicant@.service

#---------------Clean-------------- 
rm -rf /var/lib/apt/lists/*

EOF

sudo umount $TARGET_ROOTFS_DIR/dev