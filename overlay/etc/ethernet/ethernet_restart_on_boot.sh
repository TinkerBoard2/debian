#!/bin/bash
sudo ethtool -s eth0 autoneg off
sleep 1
sudo ethtool -s eth0 autoneg on
