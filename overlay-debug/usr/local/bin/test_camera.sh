#!/bin/sh

export DISPLAY=:0.0 
#export GST_DEBUG=ispsrc:5
#export GST_DEBUG_FILE=/tmp/2.txt

echo "Start MIPI CSI Camera Preview!"

echo 1 > /sys/module/video_rkisp1/parameters/rkisp1_debug

echo "3A disabled"
ehco "To enable AWB/AE, use isp-mode=2A tuning-xml-path=/etc/cam_iq/imx219.xml "

su linaro -c " \
    gst-launch-1.0 rkcamsrc device=/dev/video0 io-mode=4 isp-mode=0A ! videoconvert ! video/x-raw,format=NV12,width=640,height=480  ! rkximagesink \
" 
