#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# Install exim
apt-get install exim4 bsd-mailx
echo -e "Mail server relay installation\t${txtgreen}[OK]${txtrst}"

# Configure exim
dpkg-reconfigure exim4-config
cp /etc/exim4/update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf.bck
wget -q $url/mail/update-exim4.conf --no-check-certificate
mv update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf
chown root:Debian-exim /etc/exim4/update-exim4.conf.conf
cp /etc/exim4/passwd.client /etc/exim4/passwd.client.bck
echo ' '
read -p "Enter email address: " email
read -p "Enter email password: " password
echo "*.google.com:${email}:${password}" > /etc/exim4/passwd.client
chown root:Debian-exim /etc/exim4/passwd.client
update-exim4.conf
/etc/init.d/exim4 restart

# Firewall rules
if [ -e '/etc/fail2ban/jail.local' ]; then
	sed -i 's/iptables -A INPUT -j DROP//g' /etc/network/firewall
	sed -i 's/iptables -A OUTPUT -j DROP//g' /etc/network/firewall
	sed -i 's/iptables -A FORWARD -j DROP//g' /etc/network/firewall
	
	echo -e "\n# SMTP Output" >> /etc/network/firewall
	echo "iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 587 -j ACCEPT" >> /etc/network/firewall
	
	echo "iptables -A INPUT -j DROP" >> /etc/network/firewall
	echo "iptables -A OUTPUT -j DROP" >> /etc/network/firewall
	echo "iptables -A FORWARD -j DROP" >> /etc/network/firewall
	
	/etc/network/firewall
	iptables-save -c > /etc/iptables.rules
	echo -e "Firewall update for SMTP\t${txtgreen}[OK]${txtrst}"
else
	echo -e "Firewall script doesn't exist\t${txtred}[OK]${txtrst}"
fi

# Test to send a mail
echo "Server Mail Test Message " | mail -s "Just Test" alexandre.servoz@gmail.com

echo -e "Mail server relay configuration\t${txtgreen}[OK]${txtrst}"
