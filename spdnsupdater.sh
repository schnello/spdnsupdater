#!/bin/bash

# load last IP
LASTIP=0.0.0.0

if [ -f /tmp/lastip ];then
	echo "import lastip"
	source /tmp/lastip
	echo "last ip was $LASTIP"
fi



#get current ip
IP=$(curl -s http://checkip4.spdyn.de/)
echo "current IP is $IP"



#check ip and last check
if [ "$IP" = "$LASTIP" ];then
	if [ "$LASTCHECK" -le "$(( $(date +%s) - 86400 ))" ];then
		echo "force ip update"
	else
	echo "no ip change"
	exit
	fi
fi

#update string
updateip(){
RETURNCODE=$(curl -s --user $1:$2 "https://update.spdyn.de/nic/update?hostname=$1&myip=$IP&pass=$2")



# eval return code

case $RETURNCODE in

	nochg*)
	echo "update done... IP was up2date"
	;;

	good*)
	echo "update done... IP changed to $IP"
	;;

	abuse*)
	echo "update failed: abuse error"
	;;

	badauth*)
	echo "update failed: wrong user or password"
	;;

	numhost*)
	echo "update failed: you try to update more as 20 hosts"
	;;

	notfqdn*)
	echo "update failed: host is not a FQDN"
	;;

	!yours*)
	echo "update failed: host is not assigned to your account"
	;;

	fatal*)
	echo "update failed: host is disabled"
	;;

	nohost*)
	echo "update failed: host not available or deleted"
	;;


esac

}



# load domains and passwords from spdnsupdater.conf
if [ -f ~/.spdnsupdater.conf ];then
	echo "import config from ~/.spdnsupdater.conf "
	source ~/.spdnsupdater.conf 
else
	echo "conf file \"$HOME/.spdnsupdater.conf\" not found"
	exit
fi

# calc end for sequence
e=$(( $(echo ${DOMAIN[*]} | wc -w) - 1 )) 

echo "LASTIP=$IP" > /tmp/lastip
echo "LASTCHECK=$(date +%s)" >> /tmp/lastip

#perform update
for (( i=0; i<=$e; i++ ));do
	echo " "
	echo "Update domain ${DOMAIN[$i]}"
	updateip ${DOMAIN[$i]} ${PASSWORD[$i]}
	echo " "
done



exit
