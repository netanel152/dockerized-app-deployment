# Dockerize Application Deployment

## Overview

This project demonstrates how to deploy a web application using Docker containers. It includes a MySQL database container and an application container with scripts to insert and read data. Additionally, it provides a setup for a virtual machine to host the containers and instructions for running the scripts over SSH.

## Prerequisites

- Docker
- Docker Compose
- VirtualBox (for OVA image)
- Git (optional, for cloning the repository)

## Project Structure

- **docker-compose.yml**: Defines and configures the Docker services for the project, including MySQL and the application container.
- **generate_ssl_certificates.sh**: This script automates the process of generating SSL certificates.
- **README.md**: Provides a comprehensive overview of the project, including setup instructions, usage guidelines, and descriptions of each component and script within the project.
- **run_insert_py.sh**: Execute a shell script run insert_data.py Python script.
- **run_insert.sh**: Execute a shell script run insert_data.sh Shell script.
- **run_read_py.sh**: Execute a shell script run read_data.py Python script.
- **run_read.sh**: Execute a shell script run read_data.sh Shell script.
- **app/Dockerfile**: Dockerfile to build the application container.
- **app/env.cnf**: Configuration file for mysql environment settings.
- **app/insert_data.py**: Script to insert data into the database.
- **app/read_data.py**: Script to read data from the database.
- **app/insert_data.sh**: Insert data into the MySQL database.
- **app/read_data.sh**: Script to read data from the MySQL database.
- **mysql/Dockerfile**: Dockerfile to build the mysql container.
- **mysql/init_db.sh**: Initialize the MySQL database and create the `users` table if it doesn't exist.
- **vm_setup/configure_firewall_rules.sh**: Configures VM firewall for SSH and ICMP.
- **vm_setup/install_docker_compose.sh**: Installs Docker Compose for container management.
- **vm_setup/install_docker_engine.sh**: Installs Docker Engine for container creation and management.
- **vm_setup/install_ssh_service.sh**: Sets up SSH for secure VM access.
- **vm_setup/prepare_app_scripts.sh**: Prepares application scripts (permissions, line endings).


