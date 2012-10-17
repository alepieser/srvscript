#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install libapache2-mod-php5
a2enmod php5
/etc/init.d/apache2 force-reload
echo -e "PHP5 installation\t${txtgreen}[OK]${txtrst}"