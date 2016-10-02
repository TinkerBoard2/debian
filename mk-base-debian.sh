#!/bin/bash -e

cd ubuntu-build-service/stretch-blend-armhf

sudo apt-get install qemu-user-static live-build linaro-image-tools

make clean

./configure

make

sudo chmod 0666 linaro-stretch-alip-*.tar.gz

mv linaro-stretch-alip-*.tar.gz ../../