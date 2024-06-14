# Dockerize Application Deployment for Integration Engineers

## Overview

This project demonstrates how to deploy a web application using Docker containers. It includes a MySQL database container and an application container with scripts to insert and read data. Additionally, it provides a setup for a virtual machine to host the containers and instructions for running the scripts over SSH.

## Prerequisites

- Docker
- Docker Compose
- VirtualBox (for OVA image)
- Git (optional, for cloning the repository)

## Project Structure

- **docker-compose.yml**: Defines and configures the Docker services for the project, including MySQL and the application container.
- **mysql/init-db.sh**: Script to initialize the MySQL database and create the `users` table if it doesn't exist.
- **app/Dockerfile**: Dockerfile to build the application container.
- **app/insert-data.sh**: Script to insert data into the MySQL database.
- **app/read-data.sh**: Script to read data from the MySQL database.
- **vm-setup/setup.sh**: Script to set up Docker and Docker Compose on the virtual machine.
- **vm-setup/network-setup.sh**: Script to configure network settings for Docker containers.

## Setup and Usage

### Using Docker Compose

1. **Clone the Repository**

   Clone the repository to your local machine using Git:

   ```sh
   git clone https://github.com/your-username/dockerized-app-deployment.git
   cd dockerized-app-deployment
   ```

2. **Start the Docker Containers**

   Start the MySQL and application containers using Docker Compose:

   ```sh
      docker-compose up -d
   ```

3. **Insert Data into the Database**

   Run the following command to insert data into the MySQL database:

   ```sh
      docker exec -it app-container /usr/local/bin/insert-data.sh
   ```

4. **Read Data from the Database**

   Run the following command to read data from the MySQL database:

   ```sh
      docker exec -it app-container /usr/local/bin/read-data.sh
   ```

### Setting Up the VM

1.  **Run the Setup Script**

On your virtual machine, run the setup script to install Docker and Docker Compose, and start the Docker services:

```sh
 sudo bash vm-setup/setup.sh
```

2.  **Configure the Network**

    Run the network setup script to configure network settings for Docker containers:

```sh
   sudo bash vm-setup/network-setup.sh
```

### Running Scripts Over SSH

1.  **Connect to the VM via SSH**

Connect to your virtual machine using SSH:

```sh
   ssh user@vm-ip-address
```

2. **Run the Insert Data Script**

   On the virtual machine, run the insert data script:

   ```sh
      docker exec -it app-container /usr/local/bin/insert-data.sh
   ```

3. **Run the Read Data Script**

   On the virtual machine, run the read data script:

   ```sh
      docker exec -it app-container /usr/local/bin/read-data.sh
   ```
