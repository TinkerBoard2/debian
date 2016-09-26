## usage
This repo contains rockchip rootfs build script. It will download linaro releases and set up enviroment for our chip based on the download releases.


`apt-get install qemu-user-static` to installing the build tools because we will chroot to this base rootfs.

`./mk-rootfs.sh` to build rk-debian rootfs

`./mk-image.sh` to create the ext4 image(linaro-rootfs.img).


## others
Since a lot of peoples want to get other distributions, such as ubuntu, so i write mk-rootfs-ubuntu.sh to help.But please notice this script is not well maintenance and the rootfs built by this script can be easily broken because the script don't use package manager to install packages, it just unpack packages.