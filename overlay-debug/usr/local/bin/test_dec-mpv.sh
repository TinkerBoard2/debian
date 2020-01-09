#!/bin/sh
export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

sudo service lightdm stop
mpv --hwdec=rkmpp --vo=drm -v --drm-mode=0 -loop /usr/local/test.mp4
sudo service lightdm start
