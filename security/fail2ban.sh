#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declaration of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install fail2ban whois
echo -e "Fail2ban installation\t${txtgreen}[OK]${txtrst}"

if [ ! -e '/etc/fail2ban/jail.local' ]; then
  	touch '/etc/fail2ban/jail.local'
fi

read -p "Do you enable ssh rule (y/n):" choice
if [ $choice = "y" ]; then	
if [ -z "$(grep "[ssh]" '/etc/fail2ban/jail.local')" ]; then
echo "[ssh]
enabled = true
" >> '/etc/fail2ban/jail.local'
fi

if [ -z "$(grep "[ssh-ddos]" '/etc/fail2ban/jail.local')" ]; then
echo "[ssh-ddos]
enabled = true
" >> '/etc/fail2ban/jail.local'
fi
fi

read -p "Do you enable vsftpd rule (y/n):" choice
if [ $choice = "y" ]; then	
if [ -z "$(grep "[vsftpd]" '/etc/fail2ban/jail.local')" ]; then
echo "[vsftpd]
enabled = true
" >> '/etc/fail2ban/jail.local'
fi
fi

read -p "Do you enable apache rule (y/n):" choice
if [ $choice = "y" ]; then	
if [ -z "$(grep "[apache]" '/etc/fail2ban/jail.local')" ]; then
echo "[apache]
enabled = true
" >> '/etc/fail2ban/jail.local'
fi
# apache-multiport
# apache-noscript
# apache-overflows
fi

/etc/init.d/fail2ban restart