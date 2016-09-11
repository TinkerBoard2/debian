#!/bin/sh
export DISPLAY=:0.0 
export LIBVA_DRIVER_NAME=rockchip

# gst-launch-1.0  filesrc location=/usr/local/test.mp4 ! \
# qtdemux ! vaapidecode ! video/x-raw,format=NV12 ! videoconvert ! xvimagesink

gst-launch-1.0  filesrc location=/usr/local/test.mp4 ! \
qtdemux ! vaapidecode ! vaapisink

# --gst-debug=vaapi:9