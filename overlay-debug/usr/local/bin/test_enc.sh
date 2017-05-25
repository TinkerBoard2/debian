#!/bin/sh
export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

echo "message: output to /home/linaro/2k.h264!"

gst-launch-1.0 videotestsrc ! video/x-raw,format=NV12,width=1920,height= 1080,framerate=30/1 ! queue ! mpph264enc ! filesink location=/home/linaro/2k.h264

echo "message: playing encoded video!"

su linaro -c "gst-launch-1.0 uridecodebin uri=file:///home/linaro/2k.h264  ! rkximagesink"
