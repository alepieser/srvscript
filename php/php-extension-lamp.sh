#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install php5-mysql php5-curl php5-intl php5-gd php-pear php5-mcrypt
/etc/init.d/apache2 restart
echo -e "PHP5 extension installation\t${txtgreen}[OK]${txtrst}"