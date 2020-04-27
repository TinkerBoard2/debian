#!/bin/bash

echo "Setting CPU / GPU / DDR in highest performance mode"
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "performance" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo "performance" > /sys/class/devfreq/ff9a0000.gpu/governor

if [ $1 -a $1 == 2 ]; then
	echo keep thermal
	echo 70000 > /sys/class/thermal/thermal_zone0/trip_point_0_temp
	echo 85000 > /sys/class/thermal/thermal_zone0/trip_point_1_temp
	echo 115000 > /sys/class/thermal/thermal_zone0/trip_point_2_temp
else
	echo disable thermal
	if [ -e /sys/class/thermal/thermal_zone0 ]; then
		echo user_space >/sys/class/thermal/thermal_zone0/policy
		echo disabled > /sys/class/thermal/thermal_zone0/mode
		echo 0 > /sys/class/thermal/thermal_zone0/cdev0/cur_state
		echo 0 > /sys/class/thermal/thermal_zone0/cdev1/cur_state
		echo 0 > /sys/class/thermal/thermal_zone0/cdev2/cur_state
	fi

	if [ -e /sys/class/thermal/thermal_zone1 ]; then
		echo user_space >/sys/class/thermal/thermal_zone1/policy
		echo disabled > /sys/class/thermal/thermal_zone1/mode
	fi
fi