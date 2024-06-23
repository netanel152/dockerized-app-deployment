#!/bin/bash

LOG_FILE=/app/logs/mysql_query.log

if [ -f .env ]; then
    set -a
    . ./.env
    set +a
fi

mkdir -p /app/logs
chmod 755 /app/logs

if [[ ! -d /app/logs ]]; then
    echo "Log directory was not created successfully" >&2
    exit 1
fi

touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Log file was not created successfully" >&2
    exit 1
fi

log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >>"$LOG_FILE"
    if [[ $? -ne 0 ]]; then
        echo "Failed to write to log file" >&2
        exit 1
    fi
}

check_status() {
    local status="$1"
    local output="$2"

    if [[ $status -eq 0 ]]; then
        if [[ -n "$output" ]]; then
            log_message "Successfully retrieved data from users table."
            echo "$output"
        else
            log_message "Query executed successfully but no data was retrieved."
            echo "Query executed successfully but no data was retrieved."
        fi
    else
        log_message "Failed to retrieve data from users table. Error: $output"
        echo "Failed to retrieve data from users table. Error: $output"
    fi
}

main() {
    local mysql_output
    local mysql_status

    export MYSQL_PWD="$MYSQL_ROOT_PASSWORD"
    mysql_output=$(mysql -u"$MYSQL_USER" -h"$MYSQL_HOST" -D"$MYSQL_DATABASE" -se "SELECT * FROM users;" 2>&1) mysql_status=$?
    unset MYSQL_PWD

    check_status $mysql_status "$mysql_output"
}

main
