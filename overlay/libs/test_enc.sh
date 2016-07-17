#!/bin/sh
export DISPLAY=:0.0

echo "message: decoding raw video" > /tmp/video.log
#dump raw video
export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=rockchip
gst-launch-1.0 filesrc location=/usr/local/test.mp4 ! \
    qtdemux name=vdemux vdemux.video_0 ! queue ! vaapidecode ! queue ! \
    filesink location=/usr/local/output.yuv

echo "message: encoding" > /tmp/video.log

export LIBVA_DRIVER_NAME=rockchip
gst-launch-1.0 mp4mux name=mux ! \
    filesink location=/usr/local/output.mp4 \
    filesrc location=/usr/local/output.yuv ! \
    videoparse format=nv12 width=1920 height=1088 framerate=24 ! \
    vaapiencode_h264 ! queue ! mux. \
    filesrc location=/usr/local/test.mp4 ! \
    qtdemux name=demux demux.audio_0 ! decodebin ! voaacenc ! queue ! mux.

echo "message: playing encoded video" > /tmp/video.log

export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=rockchip
export OVERLAY=1
export OVERLAY_FULLSCREEN=1
gst-launch-1.0 $@ -v playbin uri=file:///usr/local/output.mp4

rm /tmp/video.log
