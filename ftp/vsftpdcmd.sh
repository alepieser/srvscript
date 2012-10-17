#!/bin/sh
#
# script to manage vsftp user
# Created by: Alexandre Servoz
#
# Version: 1.0


init_system() {
	echo "Init virtual user for vsftpd "
	mkdir /etc/vsftpd
	mkdir /etc/vsftpd/vsftpd_user_conf
	touch  /etc/vsftpd/login.txt
	touch  /etc/vsftpd/user_list
	chmod 600 /etc/vsftpd/login.txt
	chmod 600 /etc/vsftpd/user_list
	cp /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bck
	echo "auth required /lib/security/pam_userdb.so db=/etc/vsftpd/login" > /etc/pam.d/vsftpd
	echo "account required /lib/security/pam_userdb.so db=/etc/vsftpd/login" >> /etc/pam.d/vsftpd
	echo "	[OK]"
}

add_user() {
	clear
	
	directory=/etc/vsftpd/vsftpd_user_conf/
	
	read -p "Enter username (login) : " name
	echo ' '
	read -p "Enter password (password) : " password
	echo ' '
	read -p "User account type (Admin/User) (a/u) : " type
	echo ' '
	# We make a copy of file "admin" or "user" corresponding of choice made
	if [ $type = "a" ]; then
		echo $name >> /etc/vsftpd/login.txt
		echo $password >> /etc/vsftpd/login.txt
		echo " " >> /etc/vsftpd/login.txt
		db4.8_load  -T -t hash -f /etc/vsftpd/login.txt /etc/vsftpd/login.db
		chmod 600 /etc/vsftpd/login.db
		cp $directory/admin $directory/$name
		echo ' '
		echo 'Admin account "'$name'" was created successfully !'
		read -p "Press a key to quit." -n 1 key
		exit
	elif [ $type = "u" ]; then
		echo $name >> /etc/vsftpd/login.txt
		echo $password >> /etc/vsftpd/login.txt
		echo " " >> /etc/vsftpd/login.txt
		db4.8_load  -T -t hash -f /etc/vsftpd/login.txt /etc/vsftpd/login.db
		chmod 600 /etc/vsftpd/login.db
		cp $directory/user $directory/$name
		echo ' '
		echo 'User account "'$name'" was created successfully !'
		read -p "Press a key to quit." -n 1 key
		exit
	else
		read -p "Error, please enter (a/u) : " type2
		if [ $type2 = "a" ]; then
			echo $name >> /etc/vsftpd/login.txt
			echo $name >> /etc/vsftpd/login.txt
			echo $password >> /etc/vsftpd/login.txt
			echo " " >> /etc/vsftpd/login.txt
			db4.8_load  -T -t hash -f /etc/vsftpd/login.txt /etc/vsftpd/login.db
			chmod 600 /etc/vsftpd/login.db
			cp $directory/admin $directory/$name
			echo ' '
			echo 'Admin account "'$name'" was created successfully !'
			read -p "Press a key to quit." -n 1 key
			exit
		elif [ $type2 = "u" ]; then
			echo $name >> /etc/vsftpd/login.txt
			echo $password >> /etc/vsftpd/login.txt
			echo " " >> /etc/vsftpd/login.txt
			db4.8_load  -T -t hash -f /etc/vsftpd/login.txt /etc/vsftpd/login.db
			chmod 600 /etc/vsftpd/login.db
			cp $directory/user $directory/$name
			echo ' '
			echo 'User account "'$name'" was created successfully !'
			read -p "Press a key to quit." -n 1 key
			exit
		else
			echo "Error no user created."
			read -p "Press a key to quit." -n 1 key
			exit
		fi
	fi
}

remove_user() {
	echo "Not developed yet !"
}

case "$1" in
init)
	init_system
;;
addusr)
	add_user
;;
rmusr)
	remove_user
;;
start)
	service vsftpd start
;;
stop)
	service vsftpd stop
;;
restart)
	service vsftpd restart
;;
clean)
*)
	echo "Usage: vsftpdcmd {int|addusr|rmuser|start|stop|restart|clean}"
	exit 1
esac

exit 0