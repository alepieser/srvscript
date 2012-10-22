#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

echo ' '
read -p "Enter the new root mail: " email
cp /etc/aliases /etc/aliases.bck
sed -i 's/root: [^ ]*/root: '$email'/g' /etc/aliases
newaliases
echo -e "Root mail updated\t${txtgreen}[OK]${txtrst}"