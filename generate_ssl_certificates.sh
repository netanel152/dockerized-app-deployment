#!/bin/bash

# Check for openssl availability
if ! command -v openssl &>/dev/null; then
    echo "openssl could not be found. Please install it to proceed."
    exit 1
fi

generate_ssl_certificates() {
    openssl genrsa -out client-key.pem 2048
    check_status "Generating client key"
    openssl req -new -key client-key.pem -out client-req.pem -subj "/CN=MySQL Client"
    check_status "Generating client certificate request"
    openssl x509 -req -in client-req.pem -days 365 -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem
    check_status "Signing client certificate"
}

set_permissions() {
    echo -e "\nSetting permissions for SSL certificates...\n"
    chmod 644 ca-cert.pem client-cert.pem server-cert.pem
    chmod 600 ca-key.pem client-key.pem server-key.pem
}

copy_client_certificates() {
    local app_ssl_dir="app/ssl_certs"
    if [ ! -d "$app_ssl_dir" ]; then
        mkdir -p "$app_ssl_dir"
    fi
    cp mysql/ssl_certs/ca-cert.pem "$app_ssl_dir/"
    cp mysql/ssl_certs/client-cert.pem "$app_ssl_dir/"
    cp mysql/ssl_certs/client-key.pem "$app_ssl_dir/"
}

set_permissions_copied_certs() {
    chmod 644 app/ssl_certs/ca-cert.pem app/ssl_certs/client-cert.pem
    chmod 600 app/ssl_certs/client-key.pem
}

# Main execution
generate_ssl_certificates
set_permissions
copy_client_certificates
set_permissions_copied_certs

echo "SSL certificates generated and permissions set successfully."
