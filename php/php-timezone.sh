#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

if [ -d '/etc/php5/conf.d' ]; then
echo "; PHP settings for strtotime
date.timezone = \"$(command cat /etc/timezone)\"" > /etc/php5/conf.d/timezone.ini
echo -e "PHP5 timezone configuration\t${txtgreen}[OK]${txtrst}"
fi