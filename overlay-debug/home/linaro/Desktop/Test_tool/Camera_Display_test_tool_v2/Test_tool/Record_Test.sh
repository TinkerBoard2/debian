#!/bin/bash

i=0
ERROR=0
ResultFile="/tmp/Record_TestResult.txt"
CSI0="/dev/video0"
CSI1="/dev/video5"

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
time=2
echo -e "Start Record Test!" | tee -a $ResultFile

gst-launch-1.0 rkv4l2src device=$CSI0 ! video/x-raw,width=640,height=480,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=640,height=480,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=/tmp/Record_OV5647_480p.avi &
var=$!
sleep 60
kill -9 $var
echo -e "$(date): Camera record Record_ov5647_480p.avi" | tee -a $ResultFile

gst-launch-1.0 rkv4l2src device=$CSI0 ! video/x-raw,width=1280,height=720,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=1280,height=720,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=/tmp/Record_OV5647_720p.avi &
var=$!
sleep 60
kill -9 $var
echo -e "$(date): Camera record Record_ov5647_720p.avi" | tee -a $ResultFile

gst-launch-1.0 rkv4l2src device=$CSI0 ! video/x-raw,width=1920,height=1088,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=1920,height=1088,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=/tmp/Record_OV5647_1080p.avi &
var=$!
sleep 60
kill -9 $var
echo -e "$(date): Camera record Record_ov5647_1080p.avi" | tee -a $ResultFile

gst-launch-1.0 rkv4l2src device=$CSI1 ! video/x-raw,width=640,height=480,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=640,height=480,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=/tmp/Record_IMX219_480p.avi &
var=$!
sleep 60
kill -9 $var
echo -e "$(date): Camera record Record_IMX219_480p.avi" | tee -a $ResultFile

gst-launch-1.0 rkv4l2src device=$CSI1 ! video/x-raw,width=1280,height=720,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=1280,height=720,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=/tmp/Record_IMX219_720p.avi &
var=$!
sleep 60
kill -9 $var
echo -e "$(date): Camera record Record_IMX219_720p.avi" | tee -a $ResultFile

gst-launch-1.0 rkv4l2src device=$CSI1 ! video/x-raw,width=1920,height=1088,framerate=30/1 ! tee name=t t. ! queue ! kmssink sync=false t. ! queue ! videorate ! video/x-raw,width=1920,height=1088,framerate=30/1 ! mpph264enc ! queue ! h264parse ! avimux ! filesink location=/tmp/Record_IMX219_1080p.avi &
var=$!
sleep 60
kill -9 $var
echo -e "$(date): Camera record Record_IMX219_1080p.avi" | tee -a $ResultFile

echo -e "Finished Record Test!" | tee -a $ResultFile
systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
