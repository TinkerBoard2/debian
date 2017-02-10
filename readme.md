## Introduction
This is RockChip Debian SDK's rootfs build script.  
It will build a Debian Stretch rootfs for you. 

(Please note that Debian pakcages are updated frequently and I can't guarantee the build scripts would work all the time. It's better for you to just download the prebuit image in online drive.)

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
release-20170109-beta-2

### ChangLog
* New vpu stack

	* support h264/h265 up to 4k decode  
	* support gstreamer  
	* support qt  

* fix some network bugs for stretch
* back to chromium and enable gpu acceleration
* xserver is updated to 1.18.4
* mali is updated to r13p0
* reduce size by delete some useless build tools and languages


## Next

* xserver rga acceleration
* video encode support 
* wayland support

