#!/bin/bash

set -e

# Install Docker Engine
echo -e "\nInstalling Docker Engine...\n"
sudo apt-get update || echo "Package database update failed"
sudo apt-get upgrade -y || echo "Package upgrade failed"
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    dos2unix \
    openssh-server \
    python3 \
    python3-pip \
    python3-mysql.connector || echo "Package installation failed"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - || echo "Adding Docker GPG key failed"
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" || echo "Adding Docker APT repository failed"
sudo apt-get update || echo "Package database update failed"
sudo apt-get install -y docker-ce || echo "Docker CE is already installed"
