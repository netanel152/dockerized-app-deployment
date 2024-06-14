#!/bin/bash

mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT * FROM users;"
