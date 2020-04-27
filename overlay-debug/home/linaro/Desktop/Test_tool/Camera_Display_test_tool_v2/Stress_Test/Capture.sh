#!/bin/bash

i=0
ERROR=0
ResultFile="/tmp/Capture_TestResult.txt"
CSI0="/dev/video0"
CSI1="/dev/video5"
output="/tmp"

function Remove_TestResult()
{
    if [ -f $ResultFile ]; then
		echo "$ResultFile EXIST, Revmove $ResultFile!"
		rm -rf $ResultFile
	fi
	
	rm -rf /tmp//*.jpg
}

function END()
{
    exit $ERROR
}

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
Remove_TestResult

if [ ! -n "$1" ];then
	echo -e "Set to default capture 3000 shots" | tee -a $ResultFile
	count=$((3000))
else
	echo -e "Set to capture $1 shots" | tee -a $ResultFile
	count=$(($1))
fi

echo -e "Start Capture Stress Test!" | tee -a $ResultFile

echo -e "Start Capture Test!" | tee -a $ResultFile
while [ $i != $count ]; do
    i=$(($i+1))

	gst-launch-1.0 rkv4l2src device=$CSI0 num-buffers=10 ! video/x-raw,format=NV12,width=1920,height=1080, framerate=30/1 ! jpegenc ! multifilesink location=$output/ov5647_$i.jpg &
	sleep 4
	
	gst-launch-1.0 rkv4l2src device=$CSI1 num-buffers=10 ! video/x-raw,format=NV12,width=1920,height=1080, framerate=30/1 ! jpegenc ! multifilesink location=$output/imx219_$i.jpg &
	sleep 4
	
	echo -e "$(date): Camera capture $i time(s)" | tee -a $ResultFile
			
done
echo -e "Finished Capture Test!" | tee -a $ResultFile
systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
