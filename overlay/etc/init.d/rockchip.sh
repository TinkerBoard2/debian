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
    GPU_VERSION=$(cat /sys/devices/platform/*gpu/gpuinfo)
    if [[ $GPU_VERSION =~ "Mali-T76x MP4 r1p0 0x0750" ]];
    then
        dpkg -i  /packages/libmali/libmali-rk-midgard-t76x-r14p0-r1p0_*.deb #3288w
    else
        dpkg -i  /packages/libmali/libmali-rk-midgard-t76x-r14p0-r0p0_*.deb
    fi
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
elif [[  "$1" == "rk3328"  ]]; then
    dpkg -i  /packages/libmali/libmali-rk-utgard-450-*.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
    mv /etc/X11/xorg.conf.d/20-modesetting.conf /etc/X11/xorg.conf.d/20-modesetting.conf.backup
    mv /etc/X11/xorg.conf.d/20-armsoc.conf.backup /etc/X11/xorg.conf.d/20-armsoc.conf
elif [[  "$1" == "rk3399"  ]]; then
    dpkg -i  /packages/libmali/libmali-rk-midgard-t86x-*.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
elif [[  "$1" == "rk3326"  ]]; then
    dpkg -i  /packages/libmali/libmali-rk-bifrost-g31-*.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
elif [[  "$1" == "rk3036"  ]]; then
    dpkg -i  /packages/libmali/libmali-rk-utgard-400-*.deb
    dpkg -i  /packages/libmali/libmali-rk-dev_*.deb
    mv /etc/X11/xorg.conf.d/20-modesetting.conf /etc/X11/xorg.conf.d/20-modesetting.conf.backup
    mv /etc/X11/xorg.conf.d/20-armsoc.conf.backup /etc/X11/xorg.conf.d/20-armsoc.conf
    # sed -i -e 's:"SWcursor"              "false":"SWcursor"              "true":' \
    #     -i /etc/X11/xorg.conf.d/20-armsoc.conf
fi
}

COMPATIBLE=$(cat /proc/device-tree/compatible)
if [[ $COMPATIBLE =~ "rk3288" ]];
then
    CHIPNAME="rk3288"
elif [[ $COMPATIBLE =~ "rk3328" ]]; then
    CHIPNAME="rk3328"
elif [[ $COMPATIBLE =~ "rk3399" ]]; then
    CHIPNAME="rk3399"
elif [[ $COMPATIBLE =~ "rk3326" ]]; then
    CHIPNAME="rk3326"
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

    # The base target does not come with lightdm
    systemctl restart lightdm.service || true
fi

# read mac-address from efuse
# if [ "$BOARDNAME" == "rk3288-miniarm" ]; then
#     MAC=`xxd -s 16 -l 6 -g 1 /sys/bus/nvmem/devices/rockchip-efuse0/nvmem | awk '{print $2$3$4$5$6$7 }'`
#     ifconfig eth0 hw ether $MAC
# fi
