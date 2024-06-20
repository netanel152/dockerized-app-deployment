#!/bin/bash

LOG_FILE=/app/logs/mysql_query.log

# Ensure the log directory exists with correct permissions
mkdir -p /app/logs
chmod 755 /app/logs

if [[ ! -d /app/logs ]]; then
    echo "Log directory was not created successfully" >&2
    exit 1
fi

# Ensure the log file exists with correct permissions
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Log file was not created successfully" >&2
    exit 1
fi

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >>"$LOG_FILE"
    if [[ $? -ne 0 ]]; then
        echo "Failed to write to log file" >&2
        exit 1
    fi
}

# Function to check MySQL command status and print message
check_status() {
    local status="$1"
    local output="$2"

    if [[ $status -eq 0 ]]; then
        if [[ -n "$output" ]]; then
            log_message "Successfully retrieved data from users table."
        else
            log_message "Query executed successfully but no data was retrieved."
        fi
    else
        log_message "Failed to retrieve data from users table. Error: $output"
        echo "Failed to retrieve data from users table. Error: $output"
    fi
}

# Connect to MySQL and read data using the env.cnf file for credentials
mysql_output=$(mysql --defaults-extra-file=/app/env.cnf -e "SELECT * FROM users;" "${MYSQL_DATABASE:-user_data_db}" 2>&1)
mysql_status=$?

# Print the MySQL output
echo "$mysql_output"

# Check the status of the MySQL command and print/log the appropriate message
check_status $mysql_status "$mysql_output"
