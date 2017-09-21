## Introduction
A set of shell scripts that will build GNU/Linux distribution rootfs image
for rockchip platform.

## Available Distro
* Debian Stretch (X11)
* Debian Buster (Wayland)

## Usage
Building a base debian system by ubuntu-build-service from linaro.
	
	sudo apt-get install binfmt-support qemu-user-static
	sudo dpkg -i ubuntu-build-service/packages/*
	sudo apt-get install -f
	VERSION=stretch TARGET=desktop ARCH=armhf ./mk-base-debian.sh

Building the rk-debian rootfs

	VERSION=stretch ARCH=armhf ./mk-rootfs.sh

Creating the ext4 image(linaro-rootfs.img)

	./mk-image.sh

## Cross Compile for ARM Debian

[Docker + Multiarch](http://opensource.rock-chips.com/wiki_Cross_Compile#Docker)

## Others
* Run `apt-get upgrade` in Debian-10 will break things.