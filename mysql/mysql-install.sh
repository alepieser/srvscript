#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install mysql-server mysql-client
echo -e "Mysql server installation\t${txtgreen}[OK]${txtrst}"

mysql_secure_installation
echo -e "Mysql server configuration\t${txtgreen}[OK]${txtrst}"