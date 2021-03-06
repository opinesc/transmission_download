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
 dateIn=$(date +"%Y-%m-%d %H:%M")
 echo "${greenColour}[ ${dateIn} ]${endColour}${purpleColour} $2 ${endColour}${grayColour}$1 ${endColour}" >> log.txt
}

check_log(){
  data=$(cat log.txt | grep -ic ${1})
  if [ $data -eq 0 ]; then return 0 ; else return 1; fi
}
get_title(){
  # count_parts=$(echo $1 | grep -o '-' | wc -l )
  file=$1
  title=${file%%- T*}
  prob=$(echo ${file##*Cap.}| cut -d "]" -f 1)
  season=$(echo $prob  | rev | cut -c 3- | rev)
  chapter=$(echo $prob |rev | cut -c -2 | rev)
  echo '[X] '$title $season'x'$chapter
  fillname=`echo $season'x'$chapter $title`
  echo "Filname ->"$fillname
  check_txt=`echo '[D]' $fillname`
  if [ check_log `$check_txt` ]; then
    echo "ya existe $check_txt"
  else 
    # fill_log $fillname '[D]'
    echo $check_txt
  fi
}
get_info() {
  data=$(transmission-remote http://192.168.1.24:9091/transmission --torrent $1 -i)
  Name_file=$(echo "$data" | grep  'Name' | cut --complement -c -8)
  Done_file=$(echo "$data" | grep Done | cut --complement -c -15)
  Ratio_file=$(echo "$data" | grep Ratio: | cut -d ':' -f2-3)
  Info_file=$(echo "$Name_file$Done_file$Ratio_file")
  echo "Info ->"$Info_file
}
step_downloaded(){
  echo "step_downloaded"
}

init(){
for i in $(seq 2 $TORRENTS_LEN)  # (( i=0; i< $TORRENT_LEN; i++ ))
do
  #echo $i
  #ID=$(transmission-remote http://192.168.1.24:9091/transmission --list | awk -v val="$i" 'FNR==val {print $1}' )
  #NOMBRE=$(transmission-remote http://192.168.1.24:9091/transmission --torrent $ID --info| grep "Name" | cut --complement -c -8)
  # Se pone así $(funcion ) para que el echo lo pase a la variable
  ID=$(get_id $i) 
  echo "ID -> ${ID}"
  # NOMBRE=$(get_Nombre $ID)
  # prueba=$(get_info $ID)
  get_info $ID
  # title=$(get_title $NOMBRE)
  # echo $prueba
  # fill_log $NOMBRE "D"
  # NOMBRE= $(get_id $1 | get_Nombre2)
  # echo $ID'\t-> '$NOMBRE #>> torrentLog
done
# NOMBRE"=$(echo $NOMBRE | sed -e 's/[/\[/g' -e 's/]/\]/g' )"
# echo $NOMBRE
if [ $(check_log "D" $title) ]; then
  echo "No grabar"
else 
  echo "grabar";fi
}

init

# Para obtener el ratio
# transmission-remote http://192.168.1.24:9091/transmission -t3 -i | grep "Ratio:" | awk {'print $2'}