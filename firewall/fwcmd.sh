#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

case "$1" in
load)
	if [ -f '/etc/iptables.rules' ]; then
		/sbin/iptables-restore < /etc/iptables.rules
	fi
	RETVAL=$?
;;
save)
	if [ -f '/etc/iptables.rules' ]; then
		/sbin/iptables-save > /etc/iptables.rules
	fi
	RETVAL=$?
;;
clean) 	/sbin/iptables -t filter -F
	/sbin/iptables -t nat -F
	/sbin/iptables -t mangle -F
	/sbin/iptables -t raw -F
	/sbin/iptables -t filter -P INPUT ACCEPT
	/sbin/iptables -t filter -P OUTPUT ACCEPT
	/sbin/iptables -t filter -P FORWARD ACCEPT
	/sbin/iptables -t nat -P PREROUTING ACCEPT
	/sbin/iptables -t nat -P POSTROUTING ACCEPT
	/sbin/iptables -t nat -P OUTPUT ACCEPT
	/sbin/iptables -t mangle -P PREROUTING ACCEPT
	/sbin/iptables -t mangle -P OUTPUT ACCEPT
	/sbin/iptables -t mangle -P POSTROUTING ACCEPT
	/sbin/iptables -t mangle -P FORWARD ACCEPT
	/sbin/iptables -t mangle -P INPUT ACCEPT
	/sbin/iptables -t raw -P OUTPUT ACCEPT
	/sbin/iptables -t raw -P PREROUTING ACCEPT
	/sbin/iptables -F	RETVAL=$?;;
reload)	$0 clean && $0 load
	RETVAL=$?;;*)	echo "Usage: $0 { load | save | reload | clean}"
	RETVAL=1esacexit $RETVAL
