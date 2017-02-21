#!/bin/bash
IPT="sudo iptables"
PUB_IF="et0"
LO_IF="lo"
allow_ssh="103.14.121.148/30"
BLOCKED_IP=/home/blocked.ips
SPOOFIP="127.0.0.0/8 192.168.0.0/16 172.16.0.0/12 10.0.0.0/8 169.254.0.0/16 240.0.0.0/4 255.255.255.255/32 168.254.0.0/16 224.0.0.0/4 240.0.0.0/5 248.0.0.0/5 192.0.2.0/24"
BADIPS=$( [[ -f ${blocked_ips} ]] && egrep -v "^#|^$" ${blocked_ips} )

$IPT -F
$IPT -A INPUT -i $LO_IF -j ACCEPT
$IPT -A OUTPUT -o $LO_IF -j ACCEPT
$IPT -A INPUT -i $PUB_IF -p tcp ! --syn -m state --state NEW -j DROP
$IPT -I INPUT -i $PUB_IF -f -j DROP
$IPT -I INPUT -i $PUB_IF -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
$IPT -I INPUT -i $PUB_IF -p tcp --tcp-flags ALL ALL -j DROP
$IPT -A INPUT -i $PUB_IF -p tcp --tcp-flags ALL NONE -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix "NULL Packets"
$IPT -A INPUT -i $PUB_IF -p tcp --tcp-flags ALL NONE -j DROP
$IPT -A INPUT -i $PUB_IF -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
$IPT -I INPUT -p tcp --dport 22 -s 0/0 -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p icmp --icmp-type 8 -s 0/0 -m state --state NEW,ESTABLISHED,RELATED -m limit --limit 100/sec -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p icmp --icmp-type 0 -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -I INPUT  -i $PUB_IF -p tcp -s 0/0 --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p tcp --sport 80 -d 0/0 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF  -p tcp -s 0/0 --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p tcp --sport 443 -d 0/0 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
$IPT -A OUTPUT -o $PUB_IF -p udp --dport 123 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p udp --sport 123 -m state --state ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p tcp --sport 587 -m state --state ESTABLISHED -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p tcp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p tcp --sport 465 -m state --state ESTABLISHED -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p tcp --dport 465 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p tcp --sport 110 -m state --state ESTABLISHED -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p tcp --dport 110 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p tcp --sport 995 -m state --state ESTABLISHED -j ACCEPT
$IPT -I OUTPUT -o $PUB_IF -p tcp --dport 995 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p udp --sport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -A OUTPUT -o $PUB_IF -p udp --dport 53 -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p udp --dport 53 -j ACCEPT
$IPT -I INPUT -i $PUB_IF -p tcp --dport 53 -j ACCEPT
$IPT -A INPUT -m limit --limit 5/m --limit-burst 10 -j LOG --log-prefix "DEFAULT DROP"
#$IPT -A INPUT -j DROP 
exit 0
