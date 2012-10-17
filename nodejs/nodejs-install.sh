#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 0.1

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install python g++ make
mkdir ~/nodejs && cd $_
wget -q -N http://nodejs.org/dist/node-latest.tar.gz
if [ $? -ne 0 ]; then 
	echo -e "Download nodejs archive\t${txtred}[ERROR]${txtrst}"
else
	tar xzvf node-latest.tar.gz && cd `ls -rd node-v*`
	./configure
	make
	make install
	echo -e "Node.js install\t${txtgreen}[OK]${txtrst}"
fi