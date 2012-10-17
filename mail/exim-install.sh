#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install exim4 bsd-mailx
echo -e "Mail server relay installation\t${txtgreen}[OK]${txtrst}"

dpkg-reconfigure exim4-config
cp /etc/exim4/passwd.client /etc/exim4/passwd.client.bck
vim /etc/exim4/passwd.client
chown root:Debian-exim /etc/exim4/passwd.client
update-exim4.conf

# Firewall rules
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 587 -j ACCEPT
iptables-save -c > /etc/iptables.rules
echo -e "Firewall update for SMTP\t${txtgreen}[OK]${txtrst}"

# Test to send a mail
echo "Server Mail Test Message " | mail -s "Just Test" alexandre.servoz@gmail.com

echo -e "Mail server relay configuration\t${txtgreen}[OK]${txtrst}"

