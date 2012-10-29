#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declaration of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# Install php extension for lamp configuration
echo ' '
read -p "Do you want install php lamp extension (y/n) : " choice
if [ $choice = "y" ]; then
	wget -q $url/php/php-extension-lamp.sh --no-check-certificate
	if [ $? -ne 0 ]; then 
		echo -e "Download php-extansion-lamp script\t${txtred}[ERROR]${txtrst}"
	else
		chmod +x php-extension-lamp.sh
		sh php-extension-lamp.sh
		rm php-extension-lamp.sh
	fi
fi

# Install php security
echo ' '
read -p "Do you want install php security (y/n) : " choice
if [ $choice = "y" ]; then
	wget -q $url/php/php-security.sh --no-check-certificate
	if [ $? -ne 0 ]; then 
		echo -e "Download php-security script \t ${txtred}[ERROR]${txtrst}"
	else
		chmod +x php-security.sh
		sh php-security.sh
		rm php-security.sh
	fi
fi

# Configure php mbstring
echo ' '
read -p "Do you want install php mbstring config (y/n) : " choice
if [ $choice = "y" ]; then
	wget -q $url/php/php-mbstring.sh --no-check-certificate
	if [ $? -ne 0 ]; then 
		echo -e "Download php-mbstring script \t ${txtred}[ERROR]${txtrst}"
	else
		chmod +x php-mbstring.sh
		sh php-mbstring.sh
		rm php-mbstring.sh
	fi
fi

# Configure php timezone
echo ' '
read -p "Do you want install php timezone config (y/n) : " choice
if [ $choice = "y" ]; then
	wget -q $url/php/php-timezone.sh --no-check-certificate
	if [ $? -ne 0 ]; then 
		echo -e "Download php-timezone script \t ${txtred}[ERROR]${txtrst}"
	else
		chmod +x php-timezone.sh
		sh php-timezone.sh
		rm php-timezone.sh
	fi
fi

test -x /etc/init.d/apache2 && /etc/init.d/apache2 force-reload
echo -e "PHP5 configuration\t${txtgreen}[OK]${txtrst}"
