#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# Install NTP
apt-get install ntp ntpdate
echo -e "NTP installation\t ${txtgreen}[OK]${txtrst}"

# Change ntp server
cp /etc/ntp.conf /etc/ntp.conf.bck
sed -i 's/server 0.debian/server 0.fr/g' /etc/ntp.conf
sed -i 's/server 1.debian/server 1.fr/g' /etc/ntp.conf
sed -i 's/server 2.debian/server 2.fr/g' /etc/ntp.conf
sed -i 's/server 3.debian/server 3.fr/g' /etc/ntp.conf
etc/init.d/ntp restart
echo -e "NTP configuration\t ${txtgreen}[OK]${txtrst}"

# NTP Firewall
iptables -t filter -A INPUT -i venet0 -p udp --dport 123 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p udp --sport 123 -j ACCEPT
iptables-save -c > /etc/iptables.rules
echo -e "Firewall update for NTP\t${txtgreen}[OK]${txtrst}"