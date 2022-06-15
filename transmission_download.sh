#!/bin/sh
IFS='
' 
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


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

# Primero tienen que ir las funciones
get_id(){
if [ $# -lt 1 ]; then
  echo 'Hay que proporcionar el numero de fila que está'
  return 1
else
 echo $(transmission-remote http://192.168.1.24:9091/transmission --list | awk -v val="$1" 'FNR==val {print $1}' )
fi
}

get_Nombre(){
if [ $# -lt 1 ]; then
  echo 'Hay que proporcionar el ID de la descarga'
  return 1
else
 echo $(transmission-remote http://192.168.1.24:9091/transmission --torrent $1 --info| grep "Name" | cut --complement -c -8)
fi
}

fill_log(){


}
init(){
for i in $(seq 2 $TORRENTS_LEN)  # (( i=0; i< $TORRENT_LEN; i++ ))
do
  #echo $i
  #ID=$(transmission-remote http://192.168.1.24:9091/transmission --list | awk -v val="$i" 'FNR==val {print $1}' )
  #NOMBRE=$(transmission-remote http://192.168.1.24:9091/transmission --torrent $ID --info| grep "Name" | cut --complement -c -8)
  # Se pone así $(funcion ) para que el echo lo pase a la variable
  ID=$(get_id $i) 
  NOMBRE=$(get_Nombre $ID)
  # NOMBRE= $(get_id $1 | get_Nombre2)
  echo $ID'\t-> '$NOMBRE #>> torrentLog
done
}

init

# Para obtener el ratio
# transmission-remote http://192.168.1.24:9091/transmission -t3 -i | grep "Ratio:" | awk {'print $2'}