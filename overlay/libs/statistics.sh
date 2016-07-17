#!/bin/bash
IF=eth0
SYS_PATH=/sys/class/net/${IF}/statistics
RX_PATH=${SYS_PATH}/rx_bytes
TX_PATH=${SYS_PATH}/tx_bytes
LOG_PATH=/tmp/video.log
CPU_STAT_PATH=/proc/stat

function rx_bytes()
{
    cat ${RX_PATH}
}

function tx_bytes()
{
    cat ${TX_PATH}
}

function cpu_stat()
{
    cat ${CPU_STAT_PATH} | head -1 | grep -o "[^a-z ].*"
}

function cpu_idle()
{
    cpu_stat | cut -d' ' -f4
}

function cpu_total()
{
    echo $(( `cpu_stat | tr -s ' ' '+'` ))
}

function getvar()
{
    grep "$1" ${LOG_PATH} 2>/dev/null |tail -1|cut -d':' -f2
}

function resolution()
{
    getvar "resolution"
}

function fps()
{
    getvar "fps"
}

function intra_ratio()
{
    getvar "intra_ratio"
}

function bitrate()
{
    getvar "bitrate"
}

function message()
{
    getvar "message"
}

RX_OLD=`rx_bytes`
TX_OLD=`tx_bytes`
CPU_TOTAL_OLD=`cpu_total`
CPU_IDLE_OLD=`cpu_idle`

while sleep 1;do
clear

RX=`rx_bytes`
TX=`tx_bytes`
echo "${IF}: $(((${RX} - ${RX_OLD}) / 1024)) KB/S | $(((${TX} - ${TX_OLD}) / 1024)) KB/S "
RX_OLD=${RX}
TX_OLD=${TX}

CPU_TOTAL=`cpu_total`
CPU_IDLE=`cpu_idle`
echo "cpu_load:" $((100 - (${CPU_IDLE} - ${CPU_IDLE_OLD}) * 100 / (${CPU_TOTAL} - ${CPU_TOTAL_OLD}))) "%"
CPU_TOTAL_OLD=${CPU_TOTAL}
CPU_IDLE_OLD=${CPU_IDLE}

echo

echo "message:" `message`

echo "resolution:" `resolution`

echo "bitrate:" `bitrate` "KB/S"

echo "fps:" `fps`

echo "intra_ratio:" `intra_ratio`

done
