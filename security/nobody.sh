#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

echo "/bin/false" >> /etc/shells
chsh -s /bin/false nobody
echo -e "User Nobody security\t ${txtgreen}[OK]${txtrst}"