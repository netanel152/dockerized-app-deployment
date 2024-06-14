# Dockerized Application Deployment for Integration Engineers

## Overview

This project demonstrates how to deploy a web application using Docker containers. It includes a MySQL database container and an application container with scripts to insert and read data. Additionally, it provides a setup for a virtual machine to host the containers and instructions for running the scripts over SSH.

## Prerequisites

- Docker
- Docker Compose
- VirtualBox (for OVA image)
- Git (optional, for cloning the repository)

## Project Structure


- **docker-compose.yml**: This file defines and configures the Docker services for the project. It specifies the MySQL database container and the application container, including environment variables, ports, and dependencies.

- **mysql/**:
  - **init-db.sh**: A script that initializes the MySQL database by creating the `users` table if it doesn't already exist. This script is executed when the MySQL container starts.

- **app/**:
  - **Dockerfile**: Defines the Docker image for the application container. It uses the latest Ubuntu image, installs necessary packages (e.g., mysql-client), and copies the data insert and read scripts into the container.
  - **insert-data.sh**: A script that prompts the user for a name and age, and inserts this data into the MySQL database.
  - **read-data.sh**: A script that retrieves and displays all records from the `users` table in the MySQL database.

- **vm-setup/**:
  - **setup.sh**: A script that sets up Docker and Docker Compose on the virtual machine, starts the Docker services, and configures the environment.
  - **network-setup.sh**: A script that configures the network settings for the Docker containers, such as creating a Docker network and connecting the containers to it.

- **README.md**: A markdown file providing an overview of the project, prerequisites, detailed setup and run instructions, and additional information about the project structure and best practices.

## How to Run

### Using Docker Compose

1. **Clone the repository:**

   ```sh
   git clone https://github.com/your-username/dockerized-app-deployment.git
   cd dockerized-app-deployment


