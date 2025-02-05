#!/usr/bin/env bash

# Remove the NAT rules for port 80 and 443
sudo iptables -t nat -D PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.10.1.131:80
sudo iptables -D FORWARD -p tcp -d 10.10.1.131 --dport 80 -j ACCEPT

sudo iptables -t nat -D PREROUTING -p tcp --dport 443 -j DNAT --to-destination 10.10.1.131:443
sudo iptables -D FORWARD -p tcp -d 10.10.1.131 --dport 443 -j ACCEPT

exit 0
