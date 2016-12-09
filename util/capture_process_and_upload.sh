#/bin/bash
#set -x

LC_ALL="pt_BR.UTF-8";
DATE="Notícias de $(date +"%d, %B, %Y")";
BASE="/home/otubo/";
URL="##################";
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S");
FFMPEG="/usr/bin/ffmpeg";
ID3="/usr/bin/id3";
SHOW_ID="##################";
OAUTH_TOKEN="##################";
EPISODE_SIZE="90s"; # 90 minutes
LAST_TS_FILE="";

# while we don't have any results, keep trying, for up to 3 times
while test ! ${LAST_TS_FILE}; do
	# save the radio stream from internet into a Transport Stream format (.ts)
	timeout -k 1m ${EPISODE_SIZE} ${FFMPEG} -i ${URL} -c copy -strict 2 \
		${BASE}${TIMESTAMP}.ts &> /dev/null
	LAST_TS_FILE="$(ls -1t ${BASE}|grep ts|head -1)";

	test ${LAST_TS_FILE} || ((strike++));
	if [[ $strike = 3 ]]; then
		#you're out
		echo "Stream da bandnews está fora; mais sorte amanhã :/" | \
			mail -s "BAND NEWS OFFLINE" eduardo.otubo@gmail.com >/dev/null 2>&1
	fi
	sleep 5s;
done

# got this piece of code from my last script, I think we can optimize it
NEW_MP3_FILE="$(echo $LAST_TS_FILE|sed -e 's/ts/mp3/g')"
LAST_TS_FILE="${BASE}${LAST_TS_FILE}"
NEW_MP3_FILE="${BASE}${NEW_MP3_FILE}"

# encode the .ts file into .mp3
${FFMPEG} -i "${LAST_TS_FILE}" -acodec mp3 -write_xing 0 "${NEW_MP3_FILE}" &> /dev/null

# set id3 tags
${ID3} -t "$(date)" "${NEW_MP3_FILE}" &> /dev/null
${ID3} -a ${DATE} "${NEW_MP3_FILE}" &> /dev/null
rm "${LAST_TS_FILE}" &> /dev/null

# upload to my spreaker account
curl -X POST -H "Authorization: Bearer ${OAUTH_TOKEN}" -F media_file=@${NEW_MP3_FILE} -F \
	"title=${DATE}" https://api.spreaker.com/v2/shows/${SHOW_ID}/episodes &> /dev/null

# remove the file, we don't need it anyway
rm ${NEW_MP3_FILE} -f;

# get how many episodes online we have
N_EPISODES_ONLINE=$(curl -s https://api.spreaker.com/v2/shows/${SHOW_ID}/episodes|jq -S \
	'.response'|jq '.items'|jq '.[] | .episode_id'|wc -l);

# we don't have much space, so if more than 2, remove the last one
if [[ ${N_EPISODES_ONLINE} > 2 ]]; then
	OLDEST=$(curl -s https://api.spreaker.com/v2/shows/${SHOW_ID}/episodes|jq -S \
		'.response'|jq '.items'|jq '.[] | .episode_id'|head -n1);
	curl -X DELETE -H "Authorization: Bearer ${OAUTH_TOKEN}" \
		https://api.spreaker.com/v2/episodes/${OLDEST} &> /dev/null;
fi
	
