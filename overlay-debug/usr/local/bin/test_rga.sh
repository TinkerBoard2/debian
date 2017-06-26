#!/bin/sh

sudo service lightdm stop

sudo gst-launch-1.0 -v videotestsrc ! "video/x-raw,format=BGRA, width=1920,height=1080,framerate=30/1" ! \ 
    v4l2video0convert output-io-mode=dmabuf capture-io-mode=dmabuf ! \
    "video/x-raw,format=NV12, width=640,height=720,framerate=30/1, pixel-aspect-ratio=8/9" ! kmssink
