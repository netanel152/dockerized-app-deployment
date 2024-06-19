#!/bin/bash

set -e

# Generate SSL certificates
echo -e "\nGenerating SSL certificates...\n"
mkdir -p mysql/ssl_certs
cd mysql/ssl_certs

# Generate CA key and certificate
openssl genrsa -out ca-key.pem 2048
openssl req -new -x509 -nodes -days 365 -key ca-key.pem -out ca-cert.pem -subj "/CN=Certificate Authority"

# Generate server key and certificate request
openssl genrsa -out server-key.pem 2048
openssl req -new -key server-key.pem -out server-req.pem -subj "/CN=MySQL Server"
openssl x509 -req -in server-req.pem -days 365 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem

# Generate client key and certificate request
openssl genrsa -out client-key.pem 2048
openssl req -new -key client-key.pem -out client-req.pem -subj "/CN=MySQL Client"
openssl x509 -req -in client-req.pem -days 365 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem

# Copy client certificates to app directory
cd ../..
mkdir -p app/ssl_certs
cp mysql/ssl_certs/ca-cert.pem app/ssl_certs/
cp mysql/ssl_certs/client-cert.pem app/ssl_certs/
cp mysql/ssl_certs/client-key.pem app/ssl_certs/

echo "SSL certificates generated successfully."
