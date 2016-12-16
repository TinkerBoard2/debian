#!/bin/sh

export DISPLAY=:0.0 
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

su linaro -c "gst-launch-1.0 uridecodebin uri=file:///usr/local/test.mp4  ! rkximagesink" 