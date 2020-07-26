#!/bin/bash

FILENAME=$1
/usr/local/ffmpeg/bin/ffmpeg -y \
  -nostdin \
  -hwaccel qsv \
  -vcodec mpeg2_qsv \
  -i /src/$FILENAME \
  -vcodec h264_qsv \
  -preset medium \
  -tune film \
  -vb 4M \
  -vf deinterlace_qsv,scale_qsv=1280:720 \
  -acodec copy \
  -threads 0 \
  /dst/$FILENAME
