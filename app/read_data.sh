#!/bin/bash

LOG_FILE=/app/read_data.log

# Connect to MySQL and read data
mysql -h "${MYSQL_HOST:-localhost}" -u "${MYSQL_USER:-root}" -p"${MYSQL_PASSWORD:-root}" "${MYSQL_DATABASE:-user_data_db}" -e "SELECT * FROM users;"
