#!/bin/bash
echo 1 > /sys/class/rfkill/rfkill0/state
hciattach /dev/ttyS0 bcm43xx 115200&
