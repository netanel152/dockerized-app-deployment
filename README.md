# Dockerize Application Deployment

## Overview

This project demonstrates how to deploy a web application using Docker containers. It includes a MySQL database container and an application container with scripts to insert and read data. Additionally, it provides a setup for a virtual machine to host the containers and instructions for running the scripts over SSH.

## Prerequisites

- Docker
- Docker Compose
- VirtualBox (for OVA image)
- Git (for cloning the repository)

## Project Structure
- **build_and_deploy_containers.sh**: build Docker images and deploying them as containers. It uses `docker-compose up --build -d` to build the images from the Dockerfile's specified in the `docker-compose.yml` file and then starts the containers in detached mode.
- **docker-compose.yml**: Defines and configures the Docker services for the project, including MySQL and the application container.
- **README.md**: Provides a comprehensive overview of the project, including setup instructions, usage guidelines, and descriptions of each component and script within the project.
- **gitignore**:file is used to tell Git which files or directories to ignore in a project.
- **run_insert_py.sh**: Execute a shell script run insert_data.py Python script.
- **run_insert.sh**: Execute a shell script run insert_data.sh Shell script.
- **run_read_py.sh**: Execute a shell script run read_data.py Python script.
- **run_read.sh**: Execute a shell script run read_data.sh Shell script.
- **config.env**: Configuration file for mysql environment settings.
- **app/Dockerfile**: Dockerfile to build the application container.
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

# Project Setup and Execution Guide

## Getting Started

### Accessing Root User
1. Open your terminal on the VM.
2. To switch to the root user, execute either `sudo -s` or `sudo -i`.
   - **Note:** The password for the root user is `150293`.

### Project Files Location
- All necessary files are located at `/home/sf_dockerized-app-deployment`.

- Navigate to the specified path to begin executing the scripts.

## Running Scripts

- Execute the `./build_and_deploy_containers.sh` script located in `/home/sf_dockerized-app-deployment` to build and deploy the containers.

Before running any scripts, ensure you are in the project's root directory.

### Inserting a New User
To insert a new user into the database, you have two options:
- Run `./run_insert.sh` to execute the bash script directly.
- Use `./run_insert_py.sh` to run the Python script via a bash script.

These scripts execute the files located under the `app` folder:
- `insert_data.py`
- `insert_data.sh`

### Reading the Users Table
To read data from the users table, you can:
- Execute `./run_read.sh` for a bash script implementation.
- Run `./run_read_py.sh` to execute the Python script through a bash script.

These scripts call the files under the `app` folder:
- `read_data.py`
- `read_data.sh`

## Additional Information

- **Cloning the Project:** If you're cloning the project from a Git repository, remember to add the `config.env` file to your project locally for proper configuration. it will be in speared file that i will provided you in the mail.