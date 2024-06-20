#!/bin/bash

set -e

# Configure firewall to allow SSH and ICMP
echo -e "\nConfiguring firewall rules...\n"
sudo ufw allow ssh || echo "SSH already allowed through the firewall"
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT || echo "ICMP echo requests already allowed"
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT || echo "TCP port 22 already allowed"
sudo ufw --force enable || echo "Firewall already enabled"
sudo ufw status || echo "Failed to verify firewall status"
