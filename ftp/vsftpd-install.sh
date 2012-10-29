#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Declartion of global vars
url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

# Install vsftpd and openssl
apt-get install vsftpd openssl db4.8-util
echo -e "FTP with TLS installation\t${txtgreen}[OK]${txtrst}"

# Create a self ssl certificate (10year)
echo -e "\n\n"
read -p "Press a key to start ssl key genertaion" -n 1 key
mkdir -p /etc/ssl/private
chmod 600 /etc/ssl/private
openssl req -x509 -nodes -days 3650 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
echo -e "Key ssl generated\t${txtgreen}[OK]${txtrst}"

# Configure vsftpd
cp /etc/vsftpd.conf /etc/vsftpd.conf.bck
wget -q $url/ftp/vsftpd.conf --no-check-certificate
if [ $? -ne 0 ]; then 
	echo -e "Download vsftpd config\t${txtred}[ERROR]${txtrst}"
else
	mv vsftpd.conf /etc/vsftpd.conf
	chmod 600 /etc/vsftpd.conf
	echo -e "Default vsftpd configuration\t${txtgreen}[OK]${txtrst}"
fi

# Init vsftpd to use virtual user
mkdir /etc/vsftpd
mkdir /etc/vsftpd/vsftpd_user_conf
touch  /etc/vsftpd/login.txt
touch  /etc/vsftpd/user_list
chmod 600 /etc/vsftpd/login.txt
chmod 600 /etc/vsftpd/user_list
cp /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bck
echo "auth required /lib/security/pam_userdb.so db=/etc/vsftpd/login" > /etc/pam.d/vsftpd
echo "account required /lib/security/pam_userdb.so db=/etc/vsftpd/login" >> /etc/pam.d/vsftpd
echo -e "Init vsftpd environnement\t${txtgreen}[OK]${txtrst}"

# Download vsftpdcmd.sh
wget -q $url/ftp/vsftpdcmd.sh --no-check-certificate
if [ $? -ne 0 ]; then
	echo -e "Download vsftpdcmd script\t${txtred}[ERROR]${txtrst}"
else
	mv vsftpdcmd.sh /etc/vsftpd/vsftpdcmd
	chmod +x /etc/vsftpd/vsftpdcmd
	echo -e "vsftpd initialisation\t${txtgreen}[OK]${txtrst}"
fi

# Download admin default config
wget -q $url/ftp/admin.conf --no-check-certificate --output-document="/etc/vsftpd/vsftpd_user_conf/admin"
if [ $? -ne 0 ]; then
	echo -e "Download admin conf\t${txtred}[ERROR]${txtrst}"
fi

# Download user default config
wget -q $url/ftp/user.conf --no-check-certificate --output-document="/etc/vsftpd/vsftpd_user_conf/user"
if [ $? -ne 0 ]; then
	echo -e "Download user conf\t${txtred}[ERROR]${txtrst}"
fi

# FTP Rules 
if [ -e '/etc/network/firewall' ]; then
	if [ -z "$(grep "iptables -t filter -A INPUT -i venet0 -p tcp --dport 5121 -m state --state NEW,ESTABLISHED -j ACCEPT" /etc/network/firewall)" ]; then
		sed -i '/iptables -A INPUT -j DROP/d' /etc/network/firewall
		sed -i '/iptables -A OUTPUT -j DROP/d' /etc/network/firewall
		sed -i '/iptables -A FORWARD -j DROP/d' /etc/network/firewall
	
		echo -e "\n# FTP Input" >> /etc/network/firewall
		echo "iptables -t filter -A INPUT -i venet0 -p tcp --dport 5120 -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/network/firewall
		echo "iptables -t filter -A INPUT -i venet0 -p tcp --dport 5121 -m state --state NEW,ESTABLISHED -j ACCEPT" >> /etc/network/firewall
		echo "iptables -t filter -A INPUT -i venet0 -p tcp --dport 5000:5100 -j ACCEPT" >> /etc/network/firewall
	
		echo -e "\niptables -A INPUT -j DROP" >> /etc/network/firewall
		echo "iptables -A OUTPUT -j DROP" >> /etc/network/firewall
		echo "iptables -A FORWARD -j DROP" >> /etc/network/firewall
	
		/etc/network/firewall
		iptables-save -c > /etc/iptables.rules
		echo -e "Firewall update for FTP\t${txtgreen}[OK]${txtrst}"
	else
		echo -e "Firewall already updated\t${txtgreen}[OK]${txtrst}"
	fi
else
	echo -e "Firewall script doesn't exist\t${txtred}[OK]${txtrst}"
fi

# Specify some specification informations
read -p "Do you want change banner text (y/n):" choice
if [ $choice = "y" ]; then
	read -p "Enter the new banner : " banner
	echo ' '
	echo "ftpd_banner={$banner}" >> /etc/vsftpd.conf
else
	echo "ftpd_banner=Welcome to Nectiz FTP Server" >> /etc/vsftpd.conf
fi

read -p "Do you want change the guest username (y/n):" choice
if [ $choice = "y" ]; then
	read -p "Enter the new username : " guest
	echo ' '
	echo "guest_username=$guest" >> /etc/vsftpd.conf
	echo "nopriv_user=$guest" >> /etc/vsftpd.conf
else
	echo "guest_username=ftp" >> /etc/vsftpd.conf
	echo "nopriv_user=ftp" >> /etc/vsftpd.conf
fi

read -p "Do you want ban the root user (y/n):" choice
if [ $choice = "y" ]; then
	echo "root" >> /etc/vsftpd/user_list
	echo " " >> /etc/vsftpd/user_list
fi

read -p "Do you enable fail2ban (y/n):" choice
if [ $choice = "y" ]; then
	if [ ! -e '/etc/fail2ban/jail.local' ]; then
  		touch '/etc/fail2ban/jail.local'
	fi

if [ -z "$(grep "[vsftpd]" '/etc/fail2ban/jail.local')" ]; then
echo "[vsftpd]
enabled = true
" >> '/etc/fail2ban/jail.local'
fi

	/etc/init.d/fail2ban restart
fi

read -p "Do you create a user (y/n):" choice
if [ $choice = "y" ]; then
	/etc/vsftpd/vsftpdcmd addusr
fi

/etc