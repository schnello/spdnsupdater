### What is it for?
This bash script is to be used for the Securepoint Dynamic DNS Service (https://www.spdns.de/).

### How to use?
Add your domain and password into the script.
Example: 
updateip "mydomain.spdns.eu" "zmdw-c"
Execute the script without any special parameter: bash spdnsupdater.sh

### How it works?
1.	Load “lastip” and “lastcheck” from /tmp/lastip (if available)
2.	Get the current ip adress from “http://checkip4.spdyn.de/”
3.	Check if the ip was changed (since the last run)
4.	Checks when the last update was done (atm after 24h the script force the ip update).
5.	Save “lastip” and “lastcheck” to /tmp/lastip
