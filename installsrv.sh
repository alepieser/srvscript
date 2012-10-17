#! /bin/sh

url="http://dl.dropbox.com/u/1962494/scripts"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

bash_config() {
	echo -n ""
	cp ~/.bashrc ~/.bashrc.bck
	sed -i 's/# export LS_OPTIONS/export LS_OPTIONS/g' /root/.bashrc
	sed -i 's/# eval/eval/g' /root/.bashrc
	sed -i 's/# alias ls/alias ls/g' /root/.bashrc
	sed -i 's/# alias ll/alias ll/g' /root/.bashrc
	sed -i 's/# alias l/alias l/g' /root/.bashrc
	source /root/.bashrc
	echo -e "Update bash configuration \t ${txtgreen}[OK]${txtrst}"
}

vim_config() {
	cp /etc/vim/vimrc /etc/vim/vimrc.bck
	sed -i 's/"syntax on/syntax on/g' /etc/vim/vimrc
	echo "set number" >> /etc/vim/vimrc
	echo -e "Update vim configuration \t ${txtgreen}[OK]${txtrst}"
}

apt_config() {
	cp /etc/apt/sources.list /etc/apt/sources.list.bck
	
	wget -q $(url)/source.list
	if [ $? -ne 0 ]
	then echo -e "Update APT source: source.list \t ${txtred}[ERROR]${txtrst}"
	fi
	mv source.list /etc/apt/sources.list

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
}

cron_apt() {
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

	wget -q $(url)/security.sources.list
	if [ $? -ne 0 ]
	then echo -e "Download security source list\t ${txtred}[ERROR]${txtrst}"
	else 
		mv security.sources.list /etc/apt/security.sources.list
		sed -i 's/#  OPTIONS="-o quiet=1 -o Dir::Etc::SourceList=\/etc\/apt\/security.sources.list"/OPTIONS="-o quiet=1 -o Dir::Etc::SourceList=\/etc\/apt\/security.sources.list"/g' /etc/cron-apt/config
		echo -e "Apply security source list\t${txtgreen}[OK]${txtrst}"
	fi

	wget -q $(url)/cron_apt-update.txt
	if [ $? -ne 0 ]
	then echo -e "Download cron_apt-update script\t ${txtred}[ERROR]${txtrst}"
	else
		chmod +x cron_apt-update.txt
		mv cron_apt-update.txt /etc/cron.daily/cron_apt-update
		echo -e "Apply cron_apt-update script\t${txtgreen}[OK]${txtrst}"
	fi
}

secure_nobody() {
	echo "/bin/false" >> /etc/shells
	chsh -s /bin/false nobody
	echo -e "User Nobody security\t ${txtgreen}[OK]${txtrst}"
}

ntp_config() {
	apt-get install ntp ntpdate
	echo -e "NTP installation\t ${txtgreen}[OK]${txtrst}"

	cp /etc/ntp.conf /etc/ntp.conf.bck
	sed -i 's/server 0.debian/server 0.fr/g' /etc/ntp.conf
	sed -i 's/server 1.debian/server 1.fr/g' /etc/ntp.conf
	sed -i 's/server 2.debian/server 2.fr/g' /etc/ntp.conf
	sed -i 's/server 3.debian/server 3.fr/g' /etc/ntp.conf
	/etc/init.d/ntp restart
	echo -e "NTP configuration\t ${txtgreen}[OK]${txtrst}"
}

firewall_config() {
	wget -q $(url)/firewall.txt
	if [ $? -ne 0 ]
	then echo -e "Download firewall script\t ${txtred}[ERROR]${txtrst}"
	else
		chmod +x firewall.txt
		mv firewall.txt /etc/network/firewall
		/etc/network/firewall
		echo -e "Firewall configuration\t${txtgreen}[OK]${txtrst}"
	fi
}

firewall_startup() {
	wget -q $(url)/iptablessave.txt
	if [ $? -ne 0 ]
	then echo -e "Download iptablessave script\t${txtred}[ERROR]${txtrst}"
	else
		chmod +x iptablessave.txt
		mv iptablessave.txt /etc/network/if-post-down.d/iptablessave
		/etc/network/if-post-down.d/iptablessave
		echo -e "Firewall rules saved on reboot\t${txtgreen}[OK]${txtrst}"
	fi

	wget -q $(url)/iptablesload.txt
	if [ $? -ne 0 ]
	then echo -e "Download iptablesload script\t${txtred}[ERROR]${txtrst}"
	else
		chmod +x iptablesload.txt
		mv iptablesload.txt /etc/network/if-post-down.d/iptablesload
		echo -e "Firewall rules loaded on startup\t${txtgreen}[OK]${txtrst}"
	fi
}

fail2ban_install() {
	apt-get install fail2ban whois
	echo -e "Fail2ban installation\t${txtgreen}[OK]${txtrst}"
}

rootkit_config() {
	apt-get install chkrootkit
	echo -e "Rootkit installation\t${txtgreen}[OK]${txtrst}"

	cp /etc/chkrootkit.conf /etc/chkrootkit.conf.bck
	sed -i 's/RUN_DAILY="false"/RUN_DAILY="true"/g' /etc/chkrootkit.conf
	echo -e "Rootkit configuration\t${txtgreen}[OK]${txtrst}"
}

mail_server() {
	apt-get install exim4 bsd-mailx
	echo -e "Mail server relay installation\t${txtgreen}[OK]${txtrst}"

	dpkg-reconfigure exim4-config
	cp /etc/exim4/passwd.client /etc/exim4/passwd.client.bck
	vim /etc/exim4/passwd.client
	chown root:Debian-exim /etc/exim4/passwd.client
	update-exim4.conf
	echo "Server Mail Test Message " | mail -s "Just Test" alexandre.servoz@gmail.com
	echo -e "Mail server relay configuration\t${txtgreen}[OK]${txtrst}"
}

ftp_config() {
	apt-get install vsftpd openssl db4.8-util
	echo -e "FTP with TLS installation\t${txtgreen}[OK]${txtrst}"

	mkdir -p /etc/ssl/private
	chmod 600 /etc/ssl/private
	openssl req -x509 -nodes -days 3650 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
	echo -e "Key ssl generated\t${txtgreen}[OK]${txtrst}"

	cp /etc/vsftpd.conf /etc/vsftpd.conf.bck
	wget -q $(url)/vsftpd.conf.txt
	if [ $? -ne 0 ]
	then echo -e "Download vsftpd config\t${txtred}[ERROR]${txtrst}"
	else
		mv vsftpd.conf.txt /etc/vsftpd.conf
		echo -e "Default vsftpd configuration\t${txtgreen}[OK]${txtrst}"
	fi

	wget -q $(url)/vsftpdcmd.sh.txt
	if [ $? -ne 0 ]
	then echo -e "Download vsftpdcmd script\t${txtred}[ERROR]${txtrst}"
	else
		mv vsftpdcmd.sh.txt /etc/vsftpd/vsftpdcmd
		chmod +x /etc/vsftpd/vsftpdcmd
		vsftpdcmd init
		echo -e "vsftpd initialisation\t${txtgreen}[OK]${txtrst}"
	fi
}

mysql_install() {
	apt-get install mysql-server mysql-client
	echo -e "Mysql server installation\t${txtgreen}[OK]${txtrst}"

	mysql_secure_installation
	echo -e "Mysql server configuration\t${txtgreen}[OK]${txtrst}"
}

apache_tool() {
	wget -q "https://raw.github.com/biapy/howto.biapy.com/master/apache2/a2tools" --no-check-certificate --output-document="/usr/bin/a2tools"
	if [ $? -ne 0 ]
	then echo -e "Download a2tool script\t${txtred}[ERROR]${txtrst}"
	else
		chmod +x /usr/bin/a2tools
		echo -e "a2tool initialisation\t${txtgreen}[OK]${txtrst}"
	fi
}

aphp_config1() {
	apt-get apt-get install apache2-mpm-prefork ssl-cert
	echo -e "Apache server installation\t${txtgreen}[OK]${txtrst}"

	a2enmod rewrite
	/etc/init.d/apache2 force-reload
	echo -e "Apache server configuration\t${txtgreen}[OK]${txtrst}"

	apt-get install libapache2-mod-php5
	a2enmod php5
	/etc/init.d/apache2 force-reload
	echo -e "PHP5 installation\t${txtgreen}[OK]${txtrst}"

	php_extension

	php_security_config
	php_mbstring_config
	php_timezone_config
	test -x /etc/init.d/apache2 && /etc/init.d/apache2 force-reload
	echo -e "PHP5 configuration\t${txtgreen}[OK]${txtrst}"
}

php_extension() {
	echo -n "Apache server installation"
	apt-get install php5-mysql php5-curl php5-intl php5-gd php-pear php5-mcrypt
	/etc/init.d/apache2 restart
	echo -e "PHP5 extension installation\t${txtgreen}[OK]${txtrst}"
}

php_security_config() {
	if [ -d '/etc/php5/conf.d' ]; then
		echo '; Harden PHP5 security

; Disable PHP exposure
expose_php = Off

;Dangerous : disable system functions. This can break some administration softwares.
;disable_functions = symlink,shell_exec,exec,proc_close,proc_open,popen,system,dl,passthru,escapeshellarg,escapeshellcmd
' > '/etc/php5/conf.d/security-hardened.ini'
	echo -e "PHP5 configuration security\t${txtgreen}[OK]${txtrst}"
	fi
}

php_mbstring_config() {
if [ -d '/etc/php5/conf.d' ]; then
  echo '; Set mbstring defaults to UTF-8
mbstring.language=UTF-8
mbstring.internal_encoding=UTF-8
mbstring.http_input=UTF-8
mbstring.http_output=UTF-8
mbstring.detect_order=auto' \
    > '/etc/php5/conf.d/mbstring.ini'
  echo -e "PHP5 mbstring configuration\t${txtgreen}[OK]${txtrst}"
fi
}

php_timezone_config() {
if [ -d '/etc/php5/conf.d' ]; then
echo "; PHP settings for strtotime
date.timezone = \"$(command cat /etc/timezone)\"" > /etc/php5/conf.d/timezone.ini
echo -e "PHP5 timezone configuration\t${txtgreen}[OK]${txtrst}"
fi
}

case "$1" in
shell)
	bash_config
;;
vim)
	vim_config
;;
apt)
	apt_config
;;
crapt)
	cron_apt
;;
nobody)
	secure_nobody
;;
firewall)
	firewall_config
;;
fwstartup)
	firewall_startup
;;
fail)
	fail2ban_install
;;
rootkit)
	rootkit_config
;;
mail)
	mail_server
;;
ftp)
	ftp_config
;;
lamp)
	mysql_install
	aphp_config1
;;
*)
	echo "Usage: installsrv {shell|vim|apt|crapt|nobody|firewall|fwstartup|fail|rootkit|mail|lamp|ftp}"
	exit 1
esac

exit 0
