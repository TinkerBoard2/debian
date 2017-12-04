#!/bin/sh

export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt

#Gstreamer Display: kmssink(qt eglfs),rkximagesink(x11), waylandsink(wayland)

while [ -n "$1" ];do
	case "$1" in
        rk3036) ###default the rk3036 use kmssink.
		export QT_GSTREAMER_WIDGET_VIDEOSINK=kmssink
		su linaro -c "DISPLAY=:0.0 /usr/lib/arm-linux-gnueabihf/qt5/examples/multimediawidgets/player/player /usr/local/test.mp4 "
		;;

        *)
		export QT_GSTREAMER_WIDGET_VIDEOSINK=rkximagesink
		su linaro -c "DISPLAY=:0.0 /usr/lib/arm-linux-gnueabihf/qt5/examples/multimediawidgets/player/player /usr/local/test.mp4 "
		;;
	esac
	shift
done
