#!/bin/bash -e

if [ ! $ARCH ]; then
       ARCH='armhf'
fi 

if [ ! $TARGET ]; then
       TARGET='desktop'
fi

if [ -e linaro-stretch-alip-*.tar.gz ]; then
	rm linaro-stretch-alip-*.tar.gz
fi

cd ubuntu-build-service/stretch-$TARGET-$ARCH

make clean

./configure

make

if [ -e linaro-stretch-alip-*.tar.gz ]; then 
	sudo chmod 0666 linaro-stretch-alip-*.tar.gz
	mv linaro-stretch-alip-*.tar.gz ../../
fi

