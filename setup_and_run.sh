#!/bin/bash

set -e

# Function to check the exit status of the last executed command
check_status() {
    if [ $? -ne 0 ]; then
        echo -e "\nError: $1 failed.\n"
        exit 1
    fi
}

# Function to install SSH service and start it
install_and_start_ssh() {
    echo -e "\nInstalling SSH service...\n"
    sudo apt-get install -y openssh-server || echo "SSH service is already installed"
    check_status "SSH installation"

    echo -e "\nStarting SSH service...\n"
    sudo systemctl enable ssh || echo "SSH service already enabled"
    check_status "SSH service enable"
    sudo systemctl start ssh || echo "SSH service already started"
    check_status "SSH service start"

    echo -e "\nVerifying SSH service...\n"
    sudo systemctl status ssh
    check_status "SSH service status"
}

# Function to configure firewall to allow SSH and ICMP
configure_firewall() {
    echo -e "\nAllowing SSH through the firewall...\n"
    sudo ufw allow ssh || echo "SSH already allowed through the firewall"
    check_status "Firewall allow SSH"

    echo -e "\nAllowing ICMP echo requests through the firewall...\n"
    sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT || echo "ICMP echo requests already allowed"
    check_status "Allow ICMP echo requests"

    echo -e "\nAllowing TCP port 22 through the firewall...\n"
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT || echo "TCP port 22 already allowed"
    check_status "Allow TCP port 22"

    echo -e "\nEnabling the firewall...\n"
    sudo ufw --force enable || echo "Firewall already enabled"
    check_status "Firewall enable"

    echo -e "\nChecking firewall status...\n"
    sudo ufw status
    check_status "Firewall status"
}

# Function to install Docker
install_docker() {
    echo -e "\nUpdating package database...\n"
    sudo apt-get update || echo "Package database update failed"
    check_status "Package database update"

    echo -e "\nUpgrading packages...\n"
    sudo apt-get upgrade -y || echo "Package upgrade failed"
    check_status "Package upgrade"

    echo -e "\nInstalling required packages...\n"
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        dos2unix \
        openssh-server \
        python3 \
        python3-pip || echo "Package installation failed"
    check_status "Package installation"

    echo -e "\nAdding Docker’s official GPG key...\n"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - || echo "Adding Docker GPG key failed"
    check_status "Docker GPG key add"

    echo -e "\nAdding Docker’s APT repository...\n"
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" || echo "Adding Docker APT repository failed"
    check_status "Docker APT repository add"

    echo -e "\nUpdating package database again...\n"
    sudo apt-get update || echo "Package database update failed"
    check_status "Package database update"

    echo -e "\nInstalling Docker CE...\n"
    sudo apt-get install -y docker-ce || echo "Docker CE is already installed"
    check_status "Docker CE installation"

    echo -e "\nDocker CE installed successfully.\n"
}

# Function to install Docker Compose
install_docker_compose() {
    echo -e "\nDownloading Docker Compose...\n"
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose || echo "Docker Compose download failed"
    check_status "Docker Compose download"

    echo -e "\nApplying executable permissions to the Docker Compose binary...\n"
    sudo chmod +x /usr/local/bin/docker-compose || echo "Setting permissions for Docker Compose failed"
    check_status "Docker Compose permissions"

    echo -e "\nVerifying Docker Compose installation...\n"
    docker-compose --version || echo "Docker Compose installation verification failed"
    check_status "Docker Compose installation verification"
}

# Function to set permissions and convert line endings
prepare_scripts() {
    echo -e "\nSetting executable permissions on scripts...\n"
    chmod +x app/insert_data.sh || echo "Setting permissions on insert_data.sh failed"
    check_status "Permissions on insert_data.sh"
    chmod +x app/read_data.sh || echo "Setting permissions on read_data.sh failed"
    check_status "Permissions on read_data.sh"
    chmod +x run_insert.sh || echo "Setting permissions on run_insert.sh failed"
    check_status "Permissions on run_insert.sh"
    chmod +x run_read.sh || echo "Setting permissions on run_read.sh failed"
    check_status "Permissions on run_read.sh"

    echo -e "\nConverting line endings to Unix format if necessary...\n"
    dos2unix app/insert_data.sh || echo "Converting line endings for insert_data.sh failed"
    check_status "Line endings conversion for insert_data.sh"
    dos2unix app/read_data.sh || echo "Converting line endings for read_data.sh failed"
    check_status "Line endings conversion for read_data.sh"
}

# Function to build and run Docker containers
build_and_run_containers() {
    echo -e "\nBuilding and running Docker containers...\n"
    docker-compose up --build -d || echo "Docker containers build and run failed"
    check_status "Docker containers build and run"
}

# Main script execution
echo -e "\nStarting script execution...\n"

install_and_start_ssh &
configure_firewall &
install_docker &

wait # Wait for background processes to finish

install_docker_compose
prepare_scripts
build_and_run_containers

echo -e "\nSetup and run complete!\n"
