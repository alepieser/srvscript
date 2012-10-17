#!/bin/sh
#
# Originally created by biapy.org

txtrst=$(tput sgr0) 	 # Text reset
txtgreen=$(tput setaf 2) # Green

if [ -d '/etc/php5/conf.d' ]; then
echo "; PHP settings for strtotime
date.timezone = \"$(command cat /etc/timezone)\"" > /etc/php5/conf.d/timezone.ini
echo -e "PHP5 timezone configuration\t${txtgreen}[OK]${txtrst}"
fi