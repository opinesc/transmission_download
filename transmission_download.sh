#!/bin/sh
IFS='
' 
SERVER="http://192.168.1.24:9091/transmission"
WORKING=`transmission-remote $SERVER --list`
PWD=$(pwd) 
FILE=$PWD/torrentLog
# echo 'ARCHIVO: '$FILE
COUNT_DOWNLOAD=$(transmission-remote http://192.168.1.24:9091/transmission --list | wc -l)
TORRENTS_LEN=$(( COUNT_DOWNLOAD - 1 ))
# echo "TORRENTS: "$TORRENTS_LEN
# if [ -f $FILE ]; then
# 	rm $FILE
# fi

for i in $(seq 1 $TORRENTS_LEN)  # (( i=0; i< $TORRENT_LEN; i++ ))
do
  # echo $i
  ID=$(transmission-remote http://192.168.1.24:9091/transmission --list | awk -v val="$i" 'FNR==val {print $1}' )
  NOMBRE=$(transmission-remote http://192.168.1.24:9091/transmission --torrent $ID --info| grep "Name" | cut --complement -c -8)
  echo $NOMBRE #>> torrentLog
done