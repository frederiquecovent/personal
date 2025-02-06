#!/usr/bin/env bash

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 ! -s 10.10.1.0/24 -j DNAT --to-destination 10.10.1.131:80
sudo iptables -A FORWARD -p tcp -d 10.10.1.131 --dport 80 -j ACCEPT

sudo iptables -t nat -A PREROUTING -p tcp --dport 443 ! -s 10.10.1.0/24 -j DNAT --to-destination 10.10.1.131:443
sudo iptables -A FORWARD -p tcp -d 10.10.1.131 --dport 443 -j ACCEPT

exit 0
