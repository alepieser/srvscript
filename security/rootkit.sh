#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install chkrootkit
echo -e "Rootkit installation\t${txtgreen}[OK]${txtrst}"

cp /etc/chkrootkit.conf /etc/chkrootkit.conf.bck
sed -i 's/RUN_DAILY="false"/RUN_DAILY="true"/g' /etc/chkrootkit.conf
echo -e "Rootkit configuration\t${txtgreen}[OK]${txtrst}"