#!/bin/bash

if [ -f .env ]; then
    set -a
    . ./.env
    set +a
fi

LOG_FILE="/app/logs/mysql_query.log"

mkdir -p /app/logs && chmod 755 /app/logs || {
    echo "Failed to create or set permissions on log directory" >&2
    exit 1
}

touch "$LOG_FILE" && chmod 644 "$LOG_FILE" || {
    echo "Failed to create or set permissions on log file" >&2
    exit 1
}

log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >>"$LOG_FILE"
}

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

validate_and_prompt() {
    local prompt_message="$1"
    local validation_regex="$2"
    local error_message="$3"
    local input_var
    read -p "$prompt_message" input_var
    while ! [[ "$input_var" =~ $validation_regex ]]; do
        echo "$error_message"
        read -p "$prompt_message" input_var
    done
    echo "$input_var"
}

execute_mysql_query() {
    local query="$1"
    export MYSQL_PWD="$MYSQL_ROOT_PASSWORD"
    local result=$(mysql -u"$MYSQL_USER" -h"$MYSQL_HOST" -D"$MYSQL_DATABASE" -se "$query")
    unset MYSQL_PWD
    echo "$result"
}

insert_data() {
    local id="$1"
    local name="$2"
    local age="$3"
    local query="INSERT INTO users (ID, Name, Age) VALUES ('$id', '$name', $age);"
    if execute_mysql_query "$query"; then
        log_message "Successfully inserted user: ID=$id, Name=$name, Age=$age"
        echo "Successfully inserted user: ID=$id, Name=$name, Age=$age"
    else
        log_message "Failed to insert user: ID=$id, Name=$name, Age=$age"
        echo "Failed to insert user: ID=$id, Name=$name, Age=$age"
    fi
}

main() {
    local id name age

    while true; do
        name=$(prompt_for_input "Enter name: ")
        if [[ $(execute_mysql_query "SELECT COUNT(*) FROM users WHERE Name='$name';") -eq 0 ]]; then
            break
        else
            echo "Name already exists. Please enter a different name."
        fi
    done

    age=$(validate_and_prompt "Enter age: " "^[0-9]+$" "Age must be a number. Please enter a valid age.")
    id=$(cat /proc/sys/kernel/random/uuid)

    insert_data "$id" "$name" "$age"
}

main
