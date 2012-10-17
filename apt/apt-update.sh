#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# save current sources list
cp /etc/apt/sources.list /etc/apt/sources.list.bck

# Download the new version
wget -q $(url)/apt/sources.list --no-check-certificate --output-document="/etc/apt/sources.list"
if [ $? -ne 0 ]; then 
	echo -e "Update APT source: sources.list \t ${txtred}[ERROR]${txtrst}"
fi

# Download gpg key of dotndeb
wget -q http://www.dotdeb.org/dotdeb.gpg
if [ $? -ne 0 ]; then 
	echo -e "Update APT source: dotdeb \t ${txtred}[ERROR]${txtrst}"
fi
cat dotdeb.gpg | apt-key add -
rm dotdeb.gpg
echo -e "Update APT source \t ${txtgreen}[OK]${txtrst}"

# Disable suggest package installation
echo ' '
read -p "Do you want disable suggest package (y/n) : " choice
echo ' '
if [ $choice = "y" ]; then
	echo "APT::Install-Suggests "false";" > /etc/apt/apt.conf.d/nosuggests
	echo -e "Reconfigure APT to exclude suggests package\t${txtgreen}[OK]${txtrst}"
fi

# Disable recommends package installation
echo ' '
read -p "Do you want disable recommands package (y/n) : " choice
echo ' '
if [ $choice = "y" ]; then
	echo "APT::Install-Recommends "false";" > /etc/apt/apt.conf.d/norecommends
	echo -e "Reconfigure APT to exclude recommends package\t${txtgreen}[OK]${txtrst}"
fi

# Remove package not used
apt-get autoremove --purge acpid dhcp3-client dhcp3-common ed laptop-detect nano
echo -e "Remove package unused \t ${txtgreen}[OK]${txtrst}"

# Update the system
apt-get update
apt-get -u dist-upgrade
echo -e "Update the system \t ${txtgreen}[OK]${txtrst}"
