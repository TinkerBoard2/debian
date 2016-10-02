## usage
This repo contains rockchip rootfs build script.


Building base debian system by ubuntu-build-service from linaro.

	mk-base-debian.sh


Installing the build tools because we will chroot to this base rootfs.

	apt-get install qemu-user-static

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

Since a lot of peoples want to get other distributions, such as ubuntu, so i write `mk-rootfs-ubuntu.sh` to help.But please notice this script is not well maintenance and the rootfs built by this script can be easily broken because the script don't use package manager to install packages, it just unpack packages.

