#!/bin/sh

echo performance | tee $(find /sys/ -name *governor)

echo "running glmark2 for testing GPU!!"

su linaro -c "DISPLAY=:0.0 /usr/local/bin/glmark2-es2 --fullscreen"

