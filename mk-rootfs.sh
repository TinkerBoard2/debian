#!/bin/bash -e

if [ ! $VERSION ]; then
	VERSION='stretch'
fi

./mk-rootfs-$VERSION.sh
