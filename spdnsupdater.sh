#!/bin/bash

# get IP
LASTIP=0.0.0.0

if [ -f /tmp/lastip ];then
	echo "import lastip"
	source /tmp/lastip
	echo "last ip was $LASTIP"
fi



IP=$(curl -s http://checkip4.spdyn.de/)
echo "Current IP is $IP"



if [ "$IP" = "$LASTIP" ];then
	if [ "$LASTCHECK" -le "$(( $(date +%s) - 86400 ))" ];then
		echo "force ip update"
	else
	echo "no ip change"
	exit
	fi
fi


echo "LASTIP=$IP" > /tmp/lastip
echo "LASTCHECK=$(date +%s)" >> /tmp/lastip
updateip(){
curl --user $1:$2 "https://update.spdyn.de/nic/update?hostname=$1&myip=$IP&pass=$2"


}


#enter here your spdns domain and password
updateip "uxxxxx.spdns.eu" "zmdw-c"
updateip "dyxxxxx.spdns.eu" "jcgc-g"
updateip "dm7xxxx.spdns.eu" "cxle-u"
updateip "qwxxxx.spdns.eu" "kuoj-o"





exit
