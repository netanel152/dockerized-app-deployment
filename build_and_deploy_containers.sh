#!/bin/bash

set -e

# Build and run Docker containers
echo -e "\nBuilding and deploying Docker containers...\n"
docker-compose up --build -d || echo "Docker containers build and run failed"
