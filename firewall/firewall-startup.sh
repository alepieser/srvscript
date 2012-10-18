#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

wget -q $url/firewall/iptablessave.sh  --no-check-certificate
if [ $? -ne 0 ]
then echo -e "Download iptablessave script\t${txtred}[ERROR]${txtrst}"
else
	chmod +x iptablessave.sh
	mv iptablessave.sh /etc/network/if-post-down.d/iptablessave
	/etc/network/if-post-down.d/iptablessave
	echo -e "Firewall rules saved on reboot\t${txtgreen}[OK]${txtrst}"
fi

wget -q $url/firewall/iptablesload.sh --no-check-certificate
if [ $? -ne 0 ]
then echo -e "Download iptablesload script\t${txtred}[ERROR]${txtrst}"
else
	chmod +x iptablesload.sh
	mv iptablesload.sh /etc/network/if-post-down.d/iptablesload
	echo -e "Firewall rules loaded on startup\t${txtgreen}[OK]${txtrst}"
fi