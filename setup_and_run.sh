#!/bin/bash

set -e

# Function to check the exit status of the last executed command
check_status() {
    if [ $? -ne 0 ]; then
        echo -e "\nError: $1 failed.\n"
        exit 1
    fi
}

echo -e "\nStarting setup and run process...\n"

./install_ssh_service.sh
check_status "SSH installation and start"

./configure_firewall_rules.sh
check_status "Firewall configuration"

./install_docker_engine.sh
check_status "Docker installation"

./install_docker_compose.sh
check_status "Docker Compose installation"

./generate_ssl_certificates.sh
check_status "SSL certificates generation"

./prepare_app_scripts.sh
check_status "App scripts preparation"

./build_and_deploy_containers.sh
check_status "Docker containers build and deploy"

echo -e "\nSetup and run complete!\n"
