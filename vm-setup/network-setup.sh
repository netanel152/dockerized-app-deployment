#!/bin/bash

# Define network settings if necessary
# Example: Expose specific ports or create a Docker network
docker network create app-network
docker network connect app-network mysql-container
docker network connect app-network app-container
