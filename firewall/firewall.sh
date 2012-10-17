#!/bin/bash

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

# NTP Out #iptables -t filter -A INPUT -i venet0 -p udp --dport 123 -j ACCEPT
#iptables -t filter -A OUTPUT -o venet0 -p udp --sport 123 -j ACCEPT

# HTTP + HTTPS + SMTP iptables -t filter -A INPUT -i venet0 -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -i venet0 -p tcp --dport 443 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 443 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 587 -j ACCEPT

# FTP
iptables -t filter -A INPUT -i venet0 -p tcp --dport 5120 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A INPUT -i venet0 -p tcp --dport 5121 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -i venet0 -p tcp --dport 5000:5100 -j ACCEPT
iptables -t filter -A OUTPUT -o venet0 -p tcp --dport 21 -j ACCEPT

# log iptables denied calls (access via 'dmesg' command)
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

# BLACKLIST IP's
# iptables -A INPUT -s "BLOCK_THIS_IP" -j DROP

iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
iptables -A FORWARD -j DROP
