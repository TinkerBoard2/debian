#!/bin/sh

export DISPLAY=:0.0 
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

echo "Start MIPI CSI Camera Preview!"
echo "Please make sure libv4l-mplane are removed."

#rm /usr/lib/arm-linux-gnueabihf/libv4l/plugins/libv4l-mplane.so

su linaro -c " \
    gst-launch-1.0 v4l2src device=/dev/video0 io-mode=4 ! videoconvert ! video/x-raw,format=NV12,width=640,height=480  ! rkximagesink \
" 

# If you are using uvc camera which don't support output NV12,
# then you have to use RGA to convert color formats.
# See test_rga.sh.
