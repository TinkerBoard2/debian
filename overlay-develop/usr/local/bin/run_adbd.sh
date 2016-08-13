#! /bin/sh

UDC=`ls /sys/class/udc/| awk '{print $1}'`

if [ "$1" = "" ];then
	echo ""
elif [ "$1" = "reattach" ];then
	echo $UDC > /sys/kernel/config/usb_gadget/g1/UDC
	return
fi

mkdir /dev/usb-ffs -m 0770 
mkdir /dev/usb-ffs/adb -m 0770 

mkdir /sys/kernel/config/usb_gadget/g1  -m 0770 

echo 0x2207 > /sys/kernel/config/usb_gadget/g1/idVendor 
echo 0x0006 > /sys/kernel/config/usb_gadget/g1/idProduct

mkdir /sys/kernel/config/usb_gadget/g1/strings/0x409   -m 0770 

echo "0123456789ABCDEF" > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
echo "rockchip"  > /sys/kernel/config/usb_gadget/g1/strings/0x409/manufacturer
echo "rk3xxx"  > /sys/kernel/config/usb_gadget/g1/strings/0x409/product

mkdir /sys/kernel/config/usb_gadget/g1/functions/ffs.adb
mkdir /sys/kernel/config/usb_gadget/g1/configs/b.1  -m 0770 
mkdir /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409  -m 0770 

ln -s  /sys/kernel/config/usb_gadget/g1/functions/ffs.adb /sys/kernel/config/usb_gadget/g1/configs/b.1
echo "adb" > /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409/configuration
mount -t functionfs adb /dev/usb-ffs/adb

./usr/local/sbin/adbd  &

echo $UDC > /sys/kernel/config/usb_gadget/g1/UDC













