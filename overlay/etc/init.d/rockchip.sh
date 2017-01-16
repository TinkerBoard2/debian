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

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
function link_mali() {
if [ "$1" == "rk3288" ];
then
    dpkg -i  /packages/libmali/libmali-rk-midgard-r13p0-r0p0_*.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
elif [[  "$1" == "rk3399"  ]]; then
    dpkg -i  /packages/libmali/lib*mali-rk-midgard-4th-r13p0_*.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
    dpkg -i  /packages/video/mpp/librockchip-rk3399-vpu0_*.deb
    dpkg -i  /packages/video/mpp/librockchip-rk3399-mpp1_*.deb
else
    dpkg -i  /packages/libmali/libmali-rk-utgard0_*.deb  
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
fi
}

COMPATIBLE=$(cat /proc/device-tree/compatible)
if [[ $COMPATIBLE =~ "rk3288" ]];
then
    CHIPNAME="rk3288"
elif [[ $COMPATIBLE =~ "rk3399" ]]; then
    CHIPNAME="rk3399"
else
    CHIPNAME="rk3036"
fi
COMPATIBLE=${COMPATIBLE#rockchip,}
BOARDNAME=${COMPATIBLE%%rockchip,*}

# first boot configure
if [ ! -e "/usr/local/first_boot_flag" ] ;
then
    echo "It's the first time booting."
    echo "The rootfs will be configured."

    link_mali ${CHIPNAME}
    touch /usr/local/first_boot_flag
    setcap CAP_SYS_ADMIN+ep /usr/bin/gst-launch-1.0
    rm -rf /packages

    systemctl restart lightdm.service
fi

# read mac-address from efuse
# if [ "$BOARDNAME" == "rk3288-miniarm" ]; then
#     MAC=`xxd -s 16 -l 6 -g 1 /sys/bus/nvmem/devices/rockchip-efuse0/nvmem | awk '{print $2$3$4$5$6$7 }'`
#     ifconfig eth0 hw ether $MAC
# fi
