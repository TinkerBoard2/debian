#!/bin/bash

i=0
ERROR=0
ResultFile="/tmp/Record_TestResult.txt"
CSI0="/dev/video0"
CSI1="/dev/video5"
output="/home/linaro/Desktop"

function Remove_TestResult()
{
    if [ -f $ResultFile ]; then
		echo "ResultFile EXIST, Revmove ResultFile!"
		rm -rf $ResultFile
	fi
}

function END()
{
    exit $ERROR
}

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
Remove_TestResult

if [ ! -n "$1" ];then
	echo -e "Set to default record time: 12 hr(s)" | tee -a $ResultFile
	time=$[12*1]
else
	echo -e "Set to default record time: $1 hr(s)" | tee -a $ResultFile
	time=$[$1*1]
fi

echo $time

echo -e "Start Record Test!" | tee -a $ResultFile
while [ $i != $time ]; do
	i=$(($i+1))
	rm -rf $output/Record_ov5647.avi
	echo -e "$(date): Start record ov5647 $i time(s)" | tee -a $ResultFile
	gst-launch-1.0 rkv4l2src device=$CSI0 ! video/x-raw,width=640,height=480,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=640,height=480,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=$output/Record_ov5647.avi &
	var=$!
	sleep 3600
	kill -9 $var
    echo -e "$(date): Camera record $i time(s)" | tee -a $ResultFile
done

i=0
while [ $i != $time ]; do
    i=$(($i+1))
    rm -rf $output/Record_imx219.avi
	echo -e "$(date): Start record imx219 $i time(s)" | tee -a $ResultFile
    gst-launch-1.0 rkv4l2src device=$CSI1 ! video/x-raw,width=640,height=480,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=640,height=480,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=$output/Record_imx219.avi &
    var=$!
    sleep 3600
    kill -9 $var
    echo -e "$(date): Camera record $i time(s)" | tee -a $ResultFile
done


echo -e "Finished Record Test!" | tee -a $ResultFile
systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
