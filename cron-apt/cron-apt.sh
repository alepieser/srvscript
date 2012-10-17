#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install cron-apt
echo "Cron-APT installation \t ${txtgreen}[OK]${txtrst}"

echo ' '
read -p "Enter e-mail to send upgrade: " email
echo ' '
cp /etc/cron-apt/config /etc/cron-apt/config.bck
sed -i 's/# APTCOMMAND=\/usr\/bin\/apt-get/APTCOMMAND=\/usr\/bin\/apt-get/g' /etc/cron-apt/config
sed -i 's/# MAIL="\/var\/log\/cron-apt\/mail"/MAIL="\/var\/log\/cron-apt\/mail"/g' /etc/cron-apt/config
sed -i 's/# MAILTO="root"/MAILTO="$(email)"/g' /etc/cron-apt/config
sed -i 's/# MAILON="error"/MAILON="upgrade"/g' /etc/cron-apt/config
echo -e "Cron-APT configuration \t ${txtgreen}[OK]${txtrst}"

wget -q $(url)/apt/security.sources.list --no-check-certificate
if [ $? -ne 0 ]
then echo -e "Download security source list\t ${txtred}[ERROR]${txtrst}"
else 
	mv security.sources.list /etc/apt/security.sources.list
	sed -i 's/#  OPTIONS="-o quiet=1 -o Dir::Etc::SourceList=\/etc\/apt\/security.sources.list"/OPTIONS="-o quiet=1 -o Dir::Etc::SourceList=\/etc\/apt\/security.sources.list"/g' /etc/cron-apt/config
	echo -e "Apply security source list\t${txtgreen}[OK]${txtrst}"
fi

wget -q $(url)/cron-apt/cron_apt-update.sh
if [ $? -ne 0 ]
then echo -e "Download cron_apt-update script\t ${txtred}[ERROR]${txtrst}"
else
	chmod +x cron_apt-update.sh
	mv cron_apt-update.sh /etc/cron.daily/cron_apt-update
	echo -e "Apply cron_apt-update script\t${txtgreen}[OK]${txtrst}"
fi