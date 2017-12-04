#!/bin/sh

sudo apt-get update
sudo apt-get install xmms2-plugin-all sox libsox-fmt-all git g++ build-essential pkg-config libx11-dev libgl1-mesa-dev libjpeg-dev libpng-dev git build-essential
cd ~/
git clone https://github.com/glmark2/glmark2.git
cd glmark2/
./waf configure --with-flavors=x11-glesv2
./waf build -j 4
sudo ./waf install

echo "install the lib success! please run test_glmark2!!"
