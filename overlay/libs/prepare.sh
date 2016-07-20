apt-get update
# apt-get remove -y chromium.*
apt-get install -y gstreamer1.0-vaapi gstreamer1.0-tools libvdpau1 libva1 \
	 libva-wayland1 gstreamer1.0-alsa gstreamer1.0-plugins-good 	\
	 gstreamer1.0-plugins-bad libdbus-1-dev alsa-utils vdpau-va-driver

# echo "xhost +" >> /etc/profile
# /etc/init.d/lightdm restart &

# rm `find /usr/lib/ -name "*vaapi*"`
# rm /etc/init/tiny*
# rm /usr/sbin/tiny*
cp librkdec-h264d.so /usr/lib/arm-linux-gnueabihf/
cp libvdpau_rockchip.so.1 /usr/lib/arm-linux-gnueabihf/vdpau/libvdpau_rockchip.so.1

cp vdpau_drv_video.so /usr/lib/arm-linux-gnueabihf/dri/vdpau_drv_video.so

cp libgstvaapi.so libgstvaapi_parse.so /usr/lib/arm-linux-gnueabihf/gstreamer-1.0/
cp -r gstvaapi/* /usr/lib/arm-linux-gnueabihf/

cp rockchip_drv_video.so /usr/lib/arm-linux-gnueabihf/dri/

cp rockchip_drv_video.so /usr/lib/arm-linux-gnueabihf/dri/

cp librkenc-h264e.so /usr/lib/arm-linux-gnueabihf/

cp test.mp4 /usr/local/
cp test_* /usr/local/bin/
cp statistics.sh /usr/local/bin/

cp -r alsa_init/* /usr/share/alsa/init/


