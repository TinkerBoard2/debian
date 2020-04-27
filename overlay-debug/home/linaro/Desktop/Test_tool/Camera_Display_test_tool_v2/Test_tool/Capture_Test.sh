#!/bin/bash

i=0
ERROR=0
ResultFile="/tmp/Capture_TestResult.txt"
CSI0="/dev/video0"
CSI1="/dev/video5"

function Remove_TestResult()
{
    if [ -f $ResultFile ]; then
		echo "$ResultFile EXIST, Revmove $ResultFile!"
		rm -rf $ResultFile
	fi
}

function END()
{
    exit $ERROR
}

function Preview_Test()
{
	gst-launch-1.0 rkv4l2src device=$CSI0 num-buffers=100 ! video/x-raw,format=NV12,width=1920,height=1080, framerate=30/1 ! videoconvert ! kmssink

	gst-launch-1.0 rkv4l2src device=$CSI1 num-buffers=100 ! video/x-raw,format=NV12,width=1920,height=1080, framerate=30/1 ! videoconvert ! kmssink
}

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
Remove_TestResult

echo -e "Start Preview Test!" | tee -a $ResultFile
Preview_Test

echo -e "Start Capture Test!" | tee -a $ResultFile
gst-launch-1.0 rkv4l2src device=$CSI0 num-buffers=10 ! video/x-raw,format=NV12,width=1920,height=1080, framerate=30/1 ! jpegenc ! multifilesink location=/tmp/Capture_ov5647.jpg
sleep 2
gst-launch-1.0 rkv4l2src device=$CSI1 num-buffers=10 ! video/x-raw,format=NV12,width=1920,height=1080, framerate=30/1 ! jpegenc ! multifilesink location=/tmp/Capture_imx219.jpg

echo -e "Finished Capture Test!" | tee -a $ResultFile
systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
