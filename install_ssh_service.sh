#!/bin/bash

set -e

# Install and start SSH service
echo -e "\nInstalling SSH service...\n"
sudo apt-get install -y openssh-server || echo "SSH service is already installed"
sudo systemctl enable ssh || echo "SSH service already enabled"
sudo systemctl start ssh || echo "SSH service already started"
sudo systemctl status ssh || echo "Failed to verify SSH service status"

exit
