#!/bin/bash

LOG_FILE=/app/insert_data.log

# Prompt user for name and age
read -p "Enter name: " name
while [[ -z "$name" ]]; do
    echo "Name cannot be empty. Please enter a valid name."
    read -p "Enter name: " name
done

read -p "Enter age: " age
while ! [[ "$age" =~ ^[0-9]+$ ]]; do
    echo "Age must be a number. Please enter a valid age."
    read -p "Enter age: " age
done

# Connect to MySQL and insert data
mysql -h "${MYSQL_HOST:-mysql}" -u "${MYSQL_USER:-root}" -p"${MYSQL_PASSWORD:-root}" "${MYSQL_DATABASE:-user_data_db}" -e "INSERT INTO users (Name, Age) VALUES ('$name', $age);"
