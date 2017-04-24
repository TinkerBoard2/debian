#!/bin/sh
export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

echo "message: decoding raw video!"

#dump raw video
gst-launch-1.0 filesrc location=/usr/local/test.mp4 ! \
    qtdemux ! queue ! h264parse ! mppvideodec ! queue ! \
    filesink location=/usr/local/output.yuv

echo "message: encoding ....."

gst-launch-1.0 -v filesrc location=/usr/local/output.yuv ! \
 videoparse format=nv12 width=1920 height=1080 framerate=24 ! mpph264enc ! \
h264parse ! mp4mux ! filesink location=/usr/local/output.mp4

echo "message: playing encoded video!"

su linaro -c "gst-launch-1.0 uridecodebin uri=file:///usr/local/output.mp4  ! rkximagesink" 
