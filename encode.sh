#!/bin/bash
SRC=$1
DST=$2
ffmpeg -y \
  -init_hw_device vaapi=foo:/dev/dri/card0 \
  -nostdin \
  -hwaccel vaapi \
  -hwaccel_output_format vaapi \
  -i $SRC \
  -preset medium \
  -vf 'deinterlace_vaapi,scale_vaapi=w=1280:h=720,hwdownload,format=nv12' \
  -vc h264_vaapi \
  -vb 5M \
  -maxrate 5M \
  -acodec copy \
  -threads 0 \
  $DST \


