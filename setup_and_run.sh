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
    sudo apt-get install -y openssh-server
    check_status "SSH installation"

    echo -e "\nStarting SSH service...\n"
    sudo systemctl enable ssh
    check_status "SSH service enable"
    sudo systemctl start ssh
    check_status "SSH service start"

    echo -e "\nVerifying SSH service...\n"
    sudo systemctl status ssh
    check_status "SSH service status"
}

# Function to configure firewall to allow SSH
configure_firewall() {
    echo -e "\nAllowing SSH through the firewall...\n"
    sudo ufw allow ssh
    check_status "Firewall allow SSH"

    echo -e "\nEnabling the firewall...\n"
    sudo ufw --force enable
    check_status "Firewall enable"

    echo -e "\nChecking firewall status...\n"
    sudo ufw status
    check_status "Firewall status"
}

# Function to install Docker
install_docker() {
    echo -e "\nUpdating package database and installing required packages...\n"
    sudo apt-get update && sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        dos2unix \
        openssh-server
    check_status "Package installation"

    echo -e "\nAdding Docker’s official GPG key...\n"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    check_status "Docker GPG key add"

    echo -e "\nAdding Docker’s APT repository...\n"
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    check_status "Docker APT repository add"

    echo -e "\nUpdating package database again...\n"
    sudo apt-get update
    check_status "Package database update"

    echo -e "\nInstalling Docker CE...\n"
    sudo apt-get install -y docker-ce
    check_status "Docker CE installation"
}

# Function to install Docker Compose
install_docker_compose() {
    echo -e "\nDownloading Docker Compose...\n"
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    check_status "Docker Compose download"

    echo -e "\nApplying executable permissions to the Docker Compose binary...\n"
    sudo chmod +x /usr/local/bin/docker-compose
    check_status "Docker Compose permissions"

    echo -e "\nVerifying Docker Compose installation...\n"
    docker-compose --version
    check_status "Docker Compose installation verification"
}

# Function to set permissions and convert line endings
prepare_scripts() {
    echo -e "\nSetting executable permissions on scripts...\n"
    chmod +x app/insert_data.sh
    check_status "Permissions on insert_data.sh"
    chmod +x app/read_data.sh
    check_status "Permissions on read_data.sh"
    chmod +x run_insert.sh
    check_status "Permissions on run_insert.sh"
    chmod +x run_read.sh
    check_status "Permissions on run_read.sh"

    echo -e "\nConverting line endings to Unix format if necessary...\n"
    dos2unix app/insert_data.sh
    check_status "Line endings conversion for insert_data.sh"
    dos2unix app/read_data.sh
    check_status "Line endings conversion for read_data.sh"
}

# Function to build and run Docker containers
build_and_run_containers() {
    echo -e "\nBuilding and running Docker containers...\n"
    docker-compose up --build -d
    check_status "Docker containers build and run"
}

# Function to insert data
insert_data() {
    echo -e "\nInserting data...\n"
    ./run_insert.sh
    check_status "Data insertion"
}

# Function to read data
read_data() {
    echo -e "\nReading data...\n"
    ./run_read.sh
    check_status "Data reading"
}

# Main script execution
install_and_start_ssh &
configure_firewall &
install_docker &
wait # Wait for background processes to finish

install_docker_compose

prepare_scripts

build_and_run_containers

insert_data

read_data

echo -e "\nSetup and run complete!\n"
