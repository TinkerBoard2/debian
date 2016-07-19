#!/bin/sh
export DISPLAY=:0.0
export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=rockchip
export OVERLAY=1
#export OVERLAY_FULLSCREEN=1

echo "message: playing video" > /tmp/video.log

#gst-launch-1.0 -m -v filesrc location=${1} ! qtdemux ! vaapidecode ! vaapisink
#gst-launch-1.0 -m -v filesrc location=/usr/local/test.mp4 ! qtdemux ! vaapidecode ! vaapisink fullscreen=1
gst-launch-1.0 $@ -v playbin uri=${1}

rm /tmp/video.log
