#!/bin/bash

function link_mali() {
if [ "$1" == "rk3288" ];
then
    dpkg -i  /packages/libmali/libmali-rk-midgard0_1.4-5_armhf.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_1.4-5_armhf.deb
    # cp  /usr/lib/arm-linux-gnueabihf/libmali-midgard.so /usr/lib/arm-linux-gnueabihf/libmali.so
    # ln -sf /usr/lib/arm-linux-gnueabihf/libmali.so /usr/lib/arm-linux-gnueabihf/libmali-midgard.so    
else
    dpkg -i  /packages/libmali/libmali-rk-utgard0_1.4-5_armhf.deb  
    dpkg -i  /packages/libmali/libmali-rk-dev_1.4-5_armhf.deb
    # cp  /usr/lib/arm-linux-gnueabihf/libmali-utgard.so /usr/lib/arm-linux-gnueabihf/libMali.so
    # ln -sf /usr/lib/arm-linux-gnueabihf/libMali.so /usr/lib/arm-linux-gnueabihf/libmali-utgard.so
fi
}

COMPATIBLE=$(cat /proc/device-tree/compatible)
CHIPNAME=${COMPATIBLE##*rockchip,}
COMPATIBLE=${COMPATIBLE#rockchip,}
BOARDNAME=${COMPATIBLE%%rockchip,*}

# first boot configure
if [ ! -e "/usr/local/first_boot_flag" ] ;
then
    echo "It's the first time booting."
    echo "The rootfs will be configured, according to your chip."
    touch /usr/local/first_boot_flag

    link_mali ${CHIPNAME}
    setcap CAP_SYS_ADMIN+ep /usr/bin/gst-launch-1.0
    rm -rf /packages
fi

# read mac-address from efuse
if [ "$BOARDNAME" == "rk3288-miniarm" ]; then
    MAC=`xxd -s 16 -l 6 -g 1 /sys/bus/nvmem/devices/rockchip-efuse0/nvmem | awk '{print $2$3$4$5$6$7 }'`
    ifconfig eth0 hw ether $MAC
fi
