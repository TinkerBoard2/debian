#!/bin/sh

echo performance | tee $(find /sys/ -name *governor)

echo "running glmark2 for testing GPU!!"
echo "please use the 'test_glmark2.sh fullscreen' or 'test_glamrk2.sh offscreen'"

case "$1" in

fullscreen)
    su linaro -c "DISPLAY=:0.0  taskset -c 4-5 /usr/local/bin/glmark2-es2 --fullscreen"
	;;
offscreen)
    su linaro -c "DISPLAY=:0.0  taskset -c 4-5 /usr/local/bin/glmark2-es2 --off-screen"
	;;
esac
shift
