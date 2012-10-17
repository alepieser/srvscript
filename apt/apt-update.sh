#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

cp /etc/apt/sources.list /etc/apt/sources.list.bck

wget -q $(url)/apt/source.list --no-check-certificate --output-document="/etc/apt/sources.list"
if [ $? -ne 0 ]
then echo -e "Update APT source: source.list \t ${txtred}[ERROR]${txtrst}"
fi

wget -q http://www.dotdeb.org/dotdeb.gpg
if [ $? -ne 0 ]
then echo -e "Update APT source: dotdeb \t ${txtred}[ERROR]${txtrst}"
fi
cat dotdeb.gpg | apt-key add -
rm dotdeb.gpg
echo -e "Update APT source \t ${txtgreen}[OK]${txtrst}"

echo "APT::Install-Suggests "false";" > /etc/apt/apt.conf.d/nosuggests
echo "APT::Install-Recommends "false";" > /etc/apt/apt.conf.d/norecommends
echo -e "Reconfigure APT to exclude suggests and recommends packets \t ${txtgreen}[OK]${txtrst}"

apt-get autoremove --purge acpid dhcp3-client dhcp3-common ed laptop-detect nano
echo -e "Remove packets unused \t ${txtgreen}[OK]${txtrst}"

apt-get update
apt-get -u dist-upgrade
echo -e "Update the system \t ${txtgreen}[OK]${txtrst}"