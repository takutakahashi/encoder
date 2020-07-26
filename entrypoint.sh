#!/bin/bash

FILENAME=$1

ffmpeg -vaapi_device /dev/dri/card0 \
    -hwaccel vaapi \
    -hwaccel_output_format vaapi \
    -i /src/$FILENAME \
    -vf 'format=nv12|vaapi,hwupload,scale_vaapi=w=1280:h=720' \
    -level 41 \
    -c:v h264_vaapi \
    -aspect 16:9 \
    -qp 23 \
    -c:a copy \
    -movflags faststart \
    -vsync 1 \
    /dst/$FILENAME.mp4
    
