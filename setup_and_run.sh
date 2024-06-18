#!/bin/bash

set -e

# Function to install Docker
install_docker() {
    echo "Updating package database..."
    sudo apt-get update

    echo "Installing required packages..."
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    echo "Adding Docker’s official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    echo "Adding Docker’s APT repository..."
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

    echo "Updating package database again..."
    sudo apt-get update

    echo "Installing Docker CE..."
    sudo apt-get install -y docker-ce

    echo "Verifying Docker installation..."
    sudo docker run hello-world
}

# Function to install Docker Compose
install_docker_compose() {
    echo "Downloading Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    echo "Applying executable permissions to the Docker Compose binary..."
    sudo chmod +x /usr/local/bin/docker-compose

    echo "Verifying Docker Compose installation..."
    docker-compose --version
}

# Function to set permissions and convert line endings
prepare_scripts() {
    echo "Setting executable permissions on scripts..."
    chmod +x app/insert_data.sh
    chmod +x app/read_data.sh
    chmod +x run_insert.sh
    chmod +x run_read.sh

    echo "Converting line endings to Unix format if necessary..."
    sudo apt-get install -y dos2unix
    dos2unix app/insert_data.sh
    dos2unix app/read_data.sh
}

# Function to build and run Docker containers
build_and_run_containers() {
    echo "Building and running Docker containers..."
    docker-compose up --build -d
}

# Function to insert data
insert_data() {
    echo "Inserting data..."
    ./run_insert.sh
}

# Function to read data
read_data() {
    echo "Reading data..."
    ./run_read.sh
}

# Main script execution
install_docker
install_docker_compose
prepare_scripts
build_and_run_containers
insert_data
read_data

echo "Setup and run complete!"
