#!/bin/bash

LOG_FILE=/app/logs/mysql_query.log

# Ensure the log directory exists with correct permissions
mkdir -p /app/logs
chmod 755 /app/logs

if [[ ! -d /app/logs ]]; then
    echo "Log directory was not created successfully" >&2
    exit 1
fi

# Ensure the log file exists
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
}

# Function to prompt for input
prompt_for_input() {
    local prompt_message="$1"
    local input_var

    read -p "$prompt_message" input_var
    while [[ -z "$input_var" ]]; do
        echo "Input cannot be empty. Please enter a valid value."
        read -p "$prompt_message" input_var
    done

    echo "$input_var"
}

# Function to prompt for age
prompt_for_age() {
    local input_var

    read -p "Enter age: " input_var
    while ! [[ "$input_var" =~ ^[0-9]+$ ]]; do
        echo "Age must be a number. Please enter a valid age."
        read -p "Enter age: " input_var
    done

    echo "$input_var"
}

# Function to check if name exists in MySQL
name_exists() {
    local name="$1"
    local database="${MYSQL_DATABASE:-user_data_db}"

    local result=$(mysql --defaults-extra-file=/app/env.cnf -se "SELECT COUNT(*) FROM users WHERE Name='$name';" "$database")
    echo "$result"
}

# Function to generate a GUID
generate_guid() {
    cat /proc/sys/kernel/random/uuid
}

# Function to insert data into MySQL
insert_data() {
    local id="$1"
    local name="$2"
    local age="$3"
    local database="${MYSQL_DATABASE:-user_data_db}"

    mysql --defaults-extra-file=/app/env.cnf -e "INSERT INTO users (ID, Name, Age) VALUES ('$id', '$name', $age);" "$database" &>>"$LOG_FILE"

    if [[ $? -eq 0 ]]; then
        log_message "Successfully inserted user: ID=$id, Name=$name, Age=$age"
    else
        log_message "Failed to insert user: ID=$id, Name=$name, Age=$age"
    fi
}

# Main script execution
main() {
    local id
    local name
    local age

    while true; do
        name=$(prompt_for_input "Enter name: ")
        if [[ $(name_exists "$name") -eq 0 ]]; then
            break
        else
            echo "Name already exists. Please enter a different name."
        fi
    done

    age=$(prompt_for_age)
    id=$(generate_guid)

    insert_data "$id" "$name" "$age"
}

main
