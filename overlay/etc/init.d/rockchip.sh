#!/bin/bash -e
### BEGIN INIT INFO
# Provides:          rockchip
# Required-Start:  
# Required-Stop: 
# Default-Start:
# Default-Stop:
# Short-Description: 
# Description:       Setup rockchip platform environment
### END INIT INFO

function link_mali() {
if [ "$1" == "rk3288" ];
then
    dpkg -i  /packages/libmali/libmali-rk-midgard0_1.4-5_armhf.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_1.4-5_armhf.deb
elif [[  "$1" == "rk3399"  ]]; then
    dpkg -i  /packages/libmali/libmali-rk-midgard-4th0_1.4-7_armhf.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_1.4-5_armhf.deb
else
    dpkg -i  /packages/libmali/libmali-rk-utgard0_1.4-5_armhf.deb  
    dpkg -i  /packages/libmali/libmali-rk-dev_1.4-5_armhf.deb
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
    echo "The rootfs will be configured."
    touch /usr/local/first_boot_flag

    link_mali ${CHIPNAME}
    setcap CAP_SYS_ADMIN+ep /usr/bin/gst-launch-1.0
    rm -rf /packages
fi

# read mac-address from efuse
# if [ "$BOARDNAME" == "rk3288-miniarm" ]; then
#     MAC=`xxd -s 16 -l 6 -g 1 /sys/bus/nvmem/devices/rockchip-efuse0/nvmem | awk '{print $2$3$4$5$6$7 }'`
#     ifconfig eth0 hw ether $MAC
# fi
