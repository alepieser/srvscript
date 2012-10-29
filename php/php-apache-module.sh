#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declaration of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# install php module for apache
apt-get install libapache2-mod-php5

# Enbale the module
a2enmod php5
/etc/init.d/apache2 force-reload

echo -e "PHP5 installation\t${txtgreen}[OK]${txtrst}"