#!/bin/bash

LOG_FILE=/app/read_data.log

# Connect to MySQL and read data using the env.cnf file for credentials
mysql --defaults-extra-file=/app/env.cnf -e "SELECT * FROM users;" "${MYSQL_DATABASE:-user_data_db}"
