#!/bin/sh
export DISPLAY=:0.0
export LIBVA_DRIVER_NAME=rockchip

echo "message: decoding raw video" > /tmp/video.log
#dump raw video
gst-launch-1.0 filesrc location=/usr/local/test.mp4 ! \
    qtdemux name=vdemux vdemux.video_0 ! queue ! vaapidecode ! queue ! \
    filesink location=/usr/local/output.yuv

echo "message: encoding" > /tmp/video.log

gst-launch-1.0 mp4mux name=mux ! \
    filesink location=/usr/local/output.mp4 \
    filesrc location=/usr/local/output.yuv ! \
    videoparse format=nv12 width=1920 height=1088 framerate=24 ! \
    vaapiencode_h264 ! queue ! mux. \
    filesrc location=/usr/local/test.mp4 ! \
    qtdemux name=demux demux.audio_0 ! decodebin ! voaacenc ! queue ! mux.

echo "message: playing encoded video" > /tmp/video.log
gst-launch-1.0  filesrc location=/usr/local/test.mp4! \
qtdemux ! vaapidecode ! video/x-raw,format=NV12 ! videoconvert ! xvimagesink

rm /tmp/video.log
