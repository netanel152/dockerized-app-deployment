#!/bin/bash

read -p "Enter name: " name
read -p "Enter age: " age

mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "INSERT INTO users (name, age) VALUES ('${name}', ${age});"
