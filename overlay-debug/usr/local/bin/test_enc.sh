#!/bin/sh
export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

echo "message: downloading raw sample!"

[ ! -e /usr/local/sample.yuv ] && sudo apt-get update && sudo apt-get install dtrx \
    && wget http://trace.eas.asu.edu/yuv/bridge-close/bridge-close_qcif.7z \
    && dtrx -n bridge-close_qcif.7z && mv bridge-close_qcif/bridge-close_qcif.yuv /usr/local/sample.yuv

echo "message: encoding ....."

gst-launch-1.0 -v filesrc location=/usr/local/sample.yuv  ! \
 videoparse format=yv12 width=176 height=144 framerate=24 ! videoconvert ! mpph264enc ! \
h264parse ! filesink location=/usr/local/test.h264

echo "message: playing encoded video!"

su linaro -c "gst-launch-1.0 uridecodebin uri=file:///usr/local/test.h264  ! rkximagesink"
