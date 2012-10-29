#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# Install mysql
apt-get install mysql-server mysql-client
echo -e "Mysql server installation\t${txtgreen}[OK]${txtrst}"

# Secure mysql
mysql_secure_installation
echo -e "Mysql server configuration\t${txtgreen}[OK]${txtrst}"