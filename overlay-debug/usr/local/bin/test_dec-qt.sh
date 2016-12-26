#!/bin/sh

export DISPLAY=:0.0 
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

su linaro -c "DISPLAY=:0.0 /usr/lib/arm-linux-gnueabihf/qt5/examples/multimediawidgets/player/player /usr/local/test.mp4 "