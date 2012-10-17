#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

apt-get install vsftpd openssl db4.8-util
echo -e "FTP with TLS installation\t${txtgreen}[OK]${txtrst}"

mkdir -p /etc/ssl/private
chmod 600 /etc/ssl/private
openssl req -x509 -nodes -days 3650 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
echo -e "Key ssl generated\t${txtgreen}[OK]${txtrst}"

cp /etc/vsftpd.conf /etc/vsftpd.conf.bck
wget -q $(url)/ftp/vsftpd.conf --no-check-certificate
if [ $? -ne 0 ]
then echo -e "Download vsftpd config\t${txtred}[ERROR]${txtrst}"
else
	mv vsftpd.conf /etc/vsftpd.conf
	echo -e "Default vsftpd configuration\t${txtgreen}[OK]${txtrst}"
fi

wget -q $(url)/ftp/vsftpdcmd.sh --no-check-certificate
if [ $? -ne 0 ]
then echo -e "Download vsftpdcmd script\t${txtred}[ERROR]${txtrst}"
else
	mv vsftpdcmd.sh /etc/vsftpd/vsftpdcmd
	chmod +x /etc/vsftpd/vsftpdcmd
	vsftpdcmd init
	echo -e "vsftpd initialisation\t${txtgreen}[OK]${txtrst}"
fi

# FTP Rules
iptables -t filter -A INPUT -i venet0 -p tcp --dport 5120 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A INPUT -i venet0 -p tcp --dport 5121 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -i venet0 -p tcp --dport 5000:5100 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 21 -j ACCEPT
iptables-save -c > /etc/iptables.rules
echo -e "Firewall update for FTP\t${txtgreen}[OK]${txtrst}"
