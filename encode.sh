#!/bin/bash
SRC=$1
DST=$2
ffmpeg -y \
  -init_hw_device vaapi=foo:/dev/dri/renderD128 \
  -nostdin \
  -hwaccel vaapi \
  -hwaccel_output_format vaapi \
  -i "$SRC" \
  -vf 'format=nv12|vaapi,scale_vaapi=w=1280:h=720' \
  -b:v 5M -maxrate 5M \
  -c:v h264_vaapi -aspect 16:9 \
  -c:a copy \
  -bsf:a aac_adtstoasc \
  "$DST"
