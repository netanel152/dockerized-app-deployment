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

## General checks before the connecting over SSH ##
- Check if you have a ping between the host machine to the virtual machine.
  In the vm please allow ICMP (ping) and ssh traffic:
   ```sh
      sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
      sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
   ```   

- Check if you have a the ssh protocol open in the VM:
   ```sh
      sudo systemctl status ssh
   ```

-Install the SSH service if it's not installed:
   ```sh
      sudo apt-get update
      sudo apt-get install openssh-server
   ```   

-Start the SSH service:
   ```sh
      sudo systemctl start ssh
   ```

-Enable the SSH service to start on boot:
   ```sh
      sudo systemctl enable ssh
   ```

-  Check Firewall Settings  
   -Ensure that the firewall on your VM is not blocking SSH traffic.
   ```sh
      sudo ufw allow ssh
      sudo ufw enable
      sudo ufw status
   ```
   
-Check SSH Configuration
   -Ensure the following lines are correctly set (or not commented out):
      *Port 22
      *ListenAddress 0.0.0.0


1.  **Connect to the VM via SSH**
   -to get the info about the ip address:
   ```sh
      ifconfig
   ```
   then the enp0s3 there you will see the ip that you got over the network card of the host machine
      
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
