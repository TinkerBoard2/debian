#!/bin/bash -e

if [ -e linaro-stretch-alip-*.tar.gz ]; then 
	rm linaro-stretch-alip-*.tar.gz
fi

cd ubuntu-build-service/stretch-blend-armhf

make clean

./configure

make

sudo chmod 0666 linaro-stretch-alip-*.tar.gz

mv linaro-stretch-alip-*.tar.gz ../../
