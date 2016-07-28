#!/bin/bash

function link_mali() {
if [ "$1" == "rk3288" ];
then
    dpkg -i  /packages/libmali/libmali-rk-midgard0_1.4-4_armhf.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_1.4-4_armhf.deb
    cp  /usr/lib/arm-linux-gnueabihf/libmali-midgard.so /usr/lib/arm-linux-gnueabihf/libmali.so
    ln -sf /usr/lib/arm-linux-gnueabihf/libmali.so /usr/lib/arm-linux-gnueabihf/libmali-midgard.so    
else
    dpkg -i  /packages/libmali/libmali-rk-utgard0_1.4-4_armhf.deb    
    dpkg -i  /packages/libmali/libmali-rk-dev_1.4-4_armhf.deb
    cp  /usr/lib/arm-linux-gnueabihf/libmali-utgard.so /usr/lib/arm-linux-gnueabihf/libMali.so
    ln -sf /usr/lib/arm-linux-gnueabihf/libMali.so /usr/lib/arm-linux-gnueabihf/libmali-utgard.so
fi

}

if [ ! -e "/usr/local/first_boot" ] ;
then
    echo "It's the first time booting."
    echo "The rootfs will be configured, according to your chip."
    touch /usr/local/first_boot
    COMPATIBLE=$(cat /proc/device-tree/compatible)
    CHIPNAME=${COMPATIBLE##*rockchip,}

    link_mali ${CHIPNAME}
    setcap CAP_SYS_ADMIN+ep /usr/bin/gst-launch-1.0
    rm -rf /packages
    ldconfig

    
fi