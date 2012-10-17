#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 	# Text reset
txtred=$(tput setaf 1)   	# Red
txtgreen=$(tput setaf 2) 	# Green

apt-get install apache2-mpm-prefork ssl-cert
wget -q $(url)/apache/a2tool-install.sh --no-check-certificate
if [ $? -ne 0 ]; then 
	echo -e "Download a2tool-install script \t ${txtred}[ERROR]${txtrst}"
else
	chmod +x a2tool-install.sh
	sh a2tool-install.sh
	rm a2tool-install.sh
fi
echo -e "Apache server installation\t${txtgreen}[OK]${txtrst}"

echo ' '
read -p "Do you want install ssl (y/n) : " choice
echo ' '
if [ $choice = "y" ]; then
	apt-get install ssl-cert
	echo -e "SSL installation\t${txtgreen}[OK]${txtrst}"

	iptables -t filter -A INPUT -i venet0 -p tcp --dport 443 -j ACCEPT
	iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 443 -j ACCEPT
	iptables-save -c > /etc/iptables.rules
	echo -e "Firewall update to listen on 443\t${txtgreen}[OK]${txtrst}"
fi

echo ' '
read -p "Do you want activate rewrite module (y/n) : " choice
echo ' '
if [ $choice = "y" ]; then
	a2enmod rewrite
	/etc/init.d/apache2 force-reload
	echo -e "Mode rewrite\t${txtgreen}[OK]${txtrst}"
fi

echo ' '
read -p "Do you want change apache port (y/n) : " choice
echo ' '
if [ $choice = "y" ]; then
	echo ' '
	read -p "Enter the new port : " port
	echo ' '
	if [ "$port" -eq "$port" ] 2> /dev/null; then
		cp /etc/apache2/ports.conf /etc/apache2/ports.conf.bck
		sed -i 's/Listen 80/Listen $(port)/g' /etc/apache2/ports.conf
		sed -i 's/NameVirtualHost *:80/NameVirtualHost *:$(port)/g' /etc/apache2/ports.conf
		echo -e "Apache port change\t${txtred}[OK]${txtrst}"

		iptables -t filter -A INPUT -i venet0 -p tcp --dport $(port) -j ACCEPT
		iptables -t filter -A OUTPUT -o venet0 -p tcp --dport $(port) -j ACCEPT
		iptables-save -c > /etc/iptables.rules
		echo -e "Firewall update to listen on $(port)\t${txtgreen}[OK]${txtrst}"
	else
		echo -e "Apache port change\t${txtred}[ERROR]${txtrst}"
		iptables -t filter -A INPUT -i venet0 -p tcp --dport 80 -j ACCEPT
		iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 80 -j ACCEPT
		iptables-save -c > /etc/iptables.rules
		echo -e "Firewall update to listen on 80\t${txtgreen}[OK]${txtrst}"
	fi
fi

if [ $choice -nq "y" ]; then
	iptables -t filter -A INPUT -i venet0 -p tcp --dport 80 -j ACCEPT
	iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 80 -j ACCEPT
	iptables-save -c > /etc/iptables.rules
	echo -e "Firewall update to listen on 80\t${txtgreen}[OK]${txtrst}"
fi

echo ' '
read -p "Do you want install php module (y/n) : " choice
echo ' '
if [ $choice = "y" ]; then
	wget -q $(url)/php/php-apache-module.sh --no-check-certificate
	if [ $? -ne 0 ]; then 
		echo -e "Download php-apache-module script \t ${txtred}[ERROR]${txtrst}"
	else
		chmod +x php-apache-module.sh
		sh php-apache-module.sh
		rm php-apache-module.sh

		echo ' '
		read -p "Do you want install php extra (y/n) : " choice
		echo ' '
		if [ $choice = "y" ]; then
			wget -q $(url)/php/php-extra.sh --no-check-certificate
			if [ $? -ne 0 ]; then 
				echo -e "Download php-extra script \t ${txtred}[ERROR]${txtrst}"
			else
				chmod +x php-extra.sh
				sh php-extra.sh
				rm php-extra.sh
			fi
		fi
	fi
fi