#!/bin/bash

set -e

# Function to check the exit status of the last executed command
check_status() {
    if [ $? -ne 0 ]; then
        echo -e "\nError: $1 failed.\n"
        exit 1
    fi
}

# Generate SSL certificates
echo -e "\nGenerating SSL certificates...\n"
mkdir -p mysql/ssl_certs
cd mysql/ssl_certs

# Generate CA key and certificate
echo -e "\nGenerating CA key and certificate...\n"
openssl genrsa -out ca-key.pem 2048
check_status "Generating CA key"
openssl req -new -x509 -nodes -days 365 -key ca-key.pem -out ca-cert.pem -subj "/CN=Certificate Authority"
check_status "Generating CA certificate"

# Generate server key and certificate request
echo -e "\nGenerating server key and certificate...\n"
openssl genrsa -out server-key.pem 2048
check_status "Generating server key"
openssl req -new -key server-key.pem -out server-req.pem -subj "/CN=MySQL Server"
check_status "Generating server certificate request"
openssl x509 -req -in server-req.pem -days 365 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem
check_status "Signing server certificate"

# Generate client key and certificate request
echo -e "\nGenerating client key and certificate...\n"
openssl genrsa -out client-key.pem 2048
check_status "Generating client key"
openssl req -new -key client-key.pem -out client-req.pem -subj "/CN=MySQL Client"
check_status "Generating client certificate request"
openssl x509 -req -in client-req.pem -days 365 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem
check_status "Signing client certificate"

# Set permissions for SSL certificates
echo -e "\nSetting permissions for SSL certificates...\n"
chmod 644 ca-cert.pem client-cert.pem server-cert.pem
chmod 600 ca-key.pem client-key.pem server-key.pem

# Copy client certificates to app directory
cd ../..
mkdir -p app/ssl_certs
cp mysql/ssl_certs/ca-cert.pem app/ssl_certs/
cp mysql/ssl_certs/client-cert.pem app/ssl_certs/
cp mysql/ssl_certs/client-key.pem app/ssl_certs/

# Set permissions for the copied certificates
chmod 644 app/ssl_certs/ca-cert.pem app/ssl_certs/client-cert.pem
chmod 600 app/ssl_certs/client-key.pem

echo "SSL certificates generated and permissions set successfully."
