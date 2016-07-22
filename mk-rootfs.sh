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
sudo cp -rf develop $TARGET_ROOTFS_DIR/
# sudo cp -rf 3288/* $TARGET_ROOTFS_DIR/

echo Change root.....................
sudo cp /usr/bin/qemu-arm-static $TARGET_ROOTFS_DIR/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev
# setup rk enviorment
cat << EOF | sudo chroot $TARGET_ROOTFS_DIR
chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
apt-get update
apt-get install -y libgcrypt20:armhf  libdbus-1-3:armhf -t testing libdbus-1-dev
apt-get remove -y xserver-xorg
apt-get install -y -t testing xserver-xorg-core 
apt-get install -y -t testing xserver-xorg-input-evdev
apt-get install -y -t testing libepoxy0
dpkg -i  /packages/libmali-rk32881_1.4-3_armhf.deb
dpkg -i  /packages/libmali-rk3288-dev_1.4-3_armhf.deb
dpkg -i  /packages/xserver-common_1.18.21-2_all.deb 
dpkg -i  /packages/xserver-xorg-core_1.18.21-2_armhf.deb
apt-get install -y gstreamer1.0-vaapi gstreamer1.0-tools libvdpau1 libva1 \
	 libva-wayland1 gstreamer1.0-alsa gstreamer1.0-plugins-good 	\
	 gstreamer1.0-plugins-bad libdbus-1-dev alsa-utils vdpau-va-driver

dpkg -i  /packages/libva-rockchip1_0.20-1_armhf.deb
dpkg -i  /packages/libdrm/*

apt-get install -f -y

# Prepare VDPAU VAAPI enviorment
cp /libs/test.mp4 /usr/local/
cp /libs/test_* /usr/local/bin/
cp /libs/statistics.sh /usr/local/bin/
cp /libs/vdpau_drv_video.so /usr/lib/arm-linux-gnueabihf/dri/vdpau_drv_video.so
cp /libs/libgstvaapi.so libgstvaapi_parse.so /usr/lib/arm-linux-gnueabihf/gstreamer-1.0/
cp -r /libs/gstvaapi/* /usr/lib/arm-linux-gnueabihf/

# rm -rf /var/lib/apt/lists/*
# rm -rf /packages
# rm -rf /libs

# for develop
ln -s /usr/bin/Xorg /usr/bin/X
apt-get install -y bash-completion
apt-get install -y sshfs -t testing
setcap CAP_SYS_ADMIN+ep /usr/bin/gst-launch-1.0

EOF

sudo umount $TARGET_ROOTFS_DIR/dev

