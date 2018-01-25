This Folder contains packages form comunity people.  

> NOTE: Rockchip don't have much knowledge about those packages and we can't give you offical support.(Like BUG-Fix, Add New Features, Explain how it works......) We just provide those pakcages for testing purpose, do not ask us "How-to".

# Usage

You need setup a minimal-gbm env before run thos app, because all of them can not work with X11.
```
wget https://github.com/rockchip-linux/libmali/raw/rockchip/lib/arm-linux-gnueabihf/libmali-midgard-t76x-r14p0-r0p0-gbm.so
mv /usr/lib/arm-linux-gnueabihf/libMali.so libMali.so.backup
mv libmali*.so /usr/lib/arm-linux-gnueabihf/libMali.so
sudo service lightdm stop
```

## MPV
See https://github.com/rockchip-linux/meta-rockchip/tree/master/recipes-multimedia/mplayer

## KODI
nothing

## FFmpeg
See https://github.com/rockchip-linux/meta-rockchip/tree/master/recipes-multimedia/ffmpeg
