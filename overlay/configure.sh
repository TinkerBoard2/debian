#!/bin/bash -e
echo rockchip > /etc/hostname

echo "I: create debian user"
adduser --gecos debian

echo "I: set debian user password"
echo "debian:debian" | chpasswd

# Enable lightdm autologin for linaro user
if [ -e /etc/lightdm/lightdm.conf ]; then 
  sed -i "s|^#autologin-user=.*|autologin-user=linaro|" /etc/lightdm/lightdm.conf
  sed -i "s|^#autologin-user-timeout=.*|autologin-user-timeout=0|" /etc/lightdm/lightdm.conf
fi

apt-get update

apt-get install xserver-xorg-core -t testing
dpkg -i  /packages/xserver-xorg-core_1.18.21-1_armhf.deb
dpkg -i  /packages/libmali-rk32881_1.4-1_armhf.deb
dpkg -i  /packages/libmali-rk3288-dev_1.4-1_armhf.deb
dpkg -i  /packages/libdrm-rockchip1_2.4.68-2_armhf.deb
dpkg -i  /packages/libdrm2_2.4.68-2_armhf.deb
apt-get install -f

rm -rf /packages
rm -rf /libs
rm -rf /configure.sh