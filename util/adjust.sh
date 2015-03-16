#/bin/bash

FOLDER=$1;

srt=(`ls $FOLDER*.srt`);
avi=(`ls $FOLDER*.avi`);

i=0;

for video in ${avi[@]}; do
    mv ${srt[$i]} `echo ${avi[$i]}|sed -e 's/avi/pt-br.srt/g'` -v ;
    let "i++";
done
