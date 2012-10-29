#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# Get an apache tool developed by biapy.com
wget -q "https://raw.github.com/biapy/howto.biapy.com/master/apache2/a2tools" --no-check-certificate --output-document="/usr/bin/a2tools"
if [ $? -ne 0 ]; then 
	echo -e "Download a2tool script\t${txtred}[ERROR]${txtrst}"
else
	chmod +x /usr/bin/a2tools
	echo -e "a2tool initialisation\t${txtgreen}[OK]${txtrst}"
fi
