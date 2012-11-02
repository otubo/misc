#!/bin/bash
srt="$1"
output="$2"
# filename must be of the form "movie name.XX[X].srt" or "movie name.srt"
base_name="$(echo $srt | sed 's/^\(.*\)\.srt$/\1/')"
echo $base_name;

extensions="avi mp4 mpg mov"
for ext in $extensions ; do
    input=$base_name.$ext;
    if [[ -e $input ]]; then break; fi
done

exec mencoder "$input" \
-ovc xvid \
    -oac mp3lame \
    -lameopts abr:br=92 \
    -xvidencopts bitrate=16000 \
-sub "$srt" -font "/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf" -subfont-autoscale 2 \
-o "$output"

