#!/bin/sh
#
# Created by: Alexandre Servoz
# Version: 1.0

# Delete all existing rules
iptables -F
iptables -X

# Default Drop
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Connection established
iptables -A INPUT -i venet0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o venet0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow incoming SSH
iptables -t filter -A INPUT -i venet0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Ping
iptables -t filter -t filter -A INPUT -i venet0 -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p icmp -j ACCEPT

# Whois iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 43 -j ACCEPT

# DNS
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p udp --dport 53 -j ACCEPT

# HTTP/S OUTPUT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 443 -j ACCEPT

# FTP OUTPUT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 21 -j ACCEPT

# BLACKLIST IP's
# iptables -A INPUT -s "BLOCK_THIS_IP" -j DROP

iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
iptables -A FORWARD -j DROP
