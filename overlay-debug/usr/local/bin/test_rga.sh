#!/bin/sh

export DISPLAY=:0.0 
#export GST_DEBUG=rgaconvert:5
#export GST_DEBUG_FILE=/tmp/2.txt

su linaro -c ' \
    gst-launch-1.0 -v videotestsrc ! "video/x-raw,format=BGRA, width=1920,height=1080,framerate=30/1" ! \
    rgaconvert hflip=false vflip=false rotation=90 input-crop=0x0x1920x1080 output-crop=0x0x640x360 \
     output-io-mode=dmabuf capture-io-mode=dmabuf ! \
    "video/x-raw,format=NV12, width=640,height=640x360,framerate=30/1" ! rkximagesink \
'


: '
Video convert pipeline:

gst-launch-1.0  filesrc location=/usr/local/test.mp4 ! qtdemux ! queue ! h264parse ! mppvideodec  ! queue ! \
   rgaconvert output-io-mode=dmabuf-import capture-io-mode=dmabuf ! \
   "video/x-raw,format=NV12, width=640,height=720,pixel-aspect-ratio=8/9"  ! rkximagesink
'

: '
WorkAround kernel patch for video convert pipeline:

   driver/media/platform/rockchip-rga/rga-hw.c
   @@ -73,10 +73,16 @@ rga_get_addr_offset(struct rga_frame *frm, unsigned int x, unsigned int y,
 	lt->y_off = y * frm->stride + x * pixel_width;
 	lt->u_off =
 		frm->width * frm->height + (y / y_div) * uv_stride + x / x_div;
 	lt->v_off = lt->u_off + frm->width * frm->height / uv_factor;
 
+	/* workaround for ver_stride from vpu.... */
+	if(frm->fmt->fourcc == V4L2_PIX_FMT_NV12);
+		lt->u_off = DIV_ROUND_UP(frm->width, 32) *
+			DIV_ROUND_UP(frm->height, 32) +
+			(y / y_div) * uv_stride + x / x_div;
+
 	lb->y_off = lt->y_off + (h - 1) * frm->stride;
 	lb->u_off = lt->u_off + (h / y_div - 1) * uv_stride;
 	lb->v_off = lt->v_off + (h / y_div - 1) * uv_stride;
'