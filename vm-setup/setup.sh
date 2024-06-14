#!/bin/bash

sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker

# Clone the project repository or copy the project files
# Assuming files are copied to /home/user/integration-engineer-task
cd /home/user/integration-engineer-task
docker-compose up -d
