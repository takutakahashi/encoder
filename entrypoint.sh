#!/bin/bash -x
PRJ_ROOT=$PWD
encode(){
  $PRJ_ROOT/encode.sh $1 $2
}

SRC=$1
DST=$2
cd $SRC
while true; do
  FILENAME=`find . -type f|head -1 |tail -1`
  if [[ "`dirname $FILENAME`" != "." ]]; then
    mkdir -p $DST/`dirname $FILENAME`
  fi
  encode $SRC/$FILENAME $DST/$FILENAME.mp4
  sleep 10
done


