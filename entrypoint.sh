#!/bin/bash -xe
PRJ_ROOT=$PWD
SRC=$1
DST=$2
cd $SRC
while true; do
  FILENAME=`find . -type f |grep "queue" |head -1 |tail -1`
  if [[ "`dirname $FILENAME`" != "." ]]; then
    mkdir -p $DST/`dirname $FILENAME`
  fi
  $PRJ_ROOT/encode.sh "$SRC/$FILENAME" "$DST/$FILENAME.mp4" && rm -f "$SRC/$FILENAME"
  sleep 10
done


