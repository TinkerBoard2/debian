#!/bin/bash
export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

echo "Start MIPI CSI Camera Preview!"

su linaro -c " \
    gst-launch-1.0 v4l2src device=/dev/video0 io-mode=4 ! video/x-raw,format=NV12,width=640,height=480, framerate=30/1 ! videoconvert ! autovideosink\
"
sleep 1

su linaro -c " \
    gst-launch-1.0 v4l2src device=/dev/video4 io-mode=4 ! video/x-raw,format=NV12,width=640,height=480, framerate=30/1 ! videoconvert ! autovideosink\
"
