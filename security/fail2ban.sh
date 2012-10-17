#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declaration of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install fail2ban whois
echo -e "Fail2ban installation\t${txtgreen}[OK]${txtrst}"