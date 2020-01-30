#!/bin/sh
echo 1 > /proc/sys/net/ipv4/ip_forward
/sbin/iptables -t nat -A POSTROUTING -o wan0 -j MASQUERADE
/sbin/iptables -A FORWARD -i wan0 -o lan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i lan0 -o wan0 -j ACCEPT
