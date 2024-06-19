#!/bin/bash

set -e

# Install Docker Compose
echo -e "\nInstalling Docker Compose...\n"
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose || echo "Docker Compose download failed"
sudo chmod +x /usr/local/bin/docker-compose || echo "Setting permissions for Docker Compose failed"
docker-compose --version || echo "Docker Compose installation verification failed"
