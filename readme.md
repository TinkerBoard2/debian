## Introduction
This is RockChip Debian SDK's rootfs build script.  
It will build a Debian Stretch rootfs for you. 

(Please note that Debian pakcages are updated frequently and I can't guarantee the build scripts would work all the time. It's better for you to just download the prebuit image in online drive.)

(MALI X11 might not be supported in the future, debian also will be abandoned. if you are doing serious development, it is recommended to use yocto
Http://rockchip.wikidot.com/yocto-user-guide)

## usage
Building base debian system by ubuntu-build-service from linaro.  
(If you don't need a complete desktop environment, then use TARGET=base and lxde won't be installed )
	
	sudo apt-get install binfmt-support qemu-user-static
	sudo dpkg -i ubuntu-build-service/packages/*
	sudo apt-get install -f
	TARGET=desktop ARCH=armhf ./mk-base-debian.sh

Building rk-debian rootfs

	ARCH=armhf ./mk-rootfs.sh

Creating the ext4 image(linaro-rootfs.img)

	./mk-image.sh


## version
release-20170308-alpha-1
