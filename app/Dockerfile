# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    mysql-client \
    python3-mysql.connector \
    python3-venv

# Copy the current directory contents into the container at /app
COPY . /app

# Set the working directory in the container
WORKDIR /app

# Make the Python scripts executable
RUN chmod +x /app/insert_data.py /app/read_data.py

# Make the Shell scripts executable
RUN chmod +x /app/insert_data.sh /app/read_data.sh

# Expose any ports the app needs (if any)
EXPOSE 8080

# Run the script to keep the container running
ENTRYPOINT ["tail", "-f", "/dev/null"]
