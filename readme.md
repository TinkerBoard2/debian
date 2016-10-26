## usage
This repo contains rockchip rootfs build script.

Building base debian system by ubuntu-build-service from linaro.
	
	sudo apt-get install binfmt-support qemu-user-static
	dpkg -i ubuntu-build-service/packages
	sudo apt-get install -f
	mk-base-debian.sh

Building rk-debian rootfs

	./mk-rootfs.sh

Creating the ext4 image(linaro-rootfs.img)

	./mk-image.sh


## others

#### packages-rebuild
`./rebuild-packages.sh` is the script help to rebuild rockchip supplied packages.
To rebuild the packages, the environment must be set up properly.
I recommend to chroot to a clean Stretch Debian.

#### build-ubuntu

Since a lot of peoples want to get other distributions, such as ubuntu, so i write `mk-rootfs-ubuntu.sh` to help, but please notice this script isn't get well maintenance and the rootfs built by this script can be easily broken because the script don't use package manager to install packages, it just unpack packages.


## version
release-20161015