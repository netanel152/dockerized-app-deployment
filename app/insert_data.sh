#!/bin/bash

if [ -f .env ]; then
    set -a
    . ./.env
    set +a
fi

LOG_FILE=/app/logs/mysql_query.log

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

prompt_for_age() {
    local input_var

    read -p "Enter age: " input_var
    while ! [[ "$input_var" =~ ^[0-9]+$ ]]; do
        echo "Age must be a number. Please enter a valid age."
        read -p "Enter age: " input_var
    done

    echo "$input_var"
}

name_exists() {
    local name="$1"
    local query="SELECT COUNT(*) FROM users WHERE Name='$name';"
    local result

    result=$(mysql -u"$MYSQL_USER" -p"$MYSQL_ROOT_PASSWORD" -h"$MYSQL_HOST" -D"$MYSQL_DATABASE" -se "$query")
    echo "$result"
}

generate_guid() {
    cat /proc/sys/kernel/random/uuid
}

insert_data() {
    local id="$1"
    local name="$2"
    local age="$3"

    local query="INSERT INTO users (ID, Name, Age) VALUES ('$id', '$name', $age);"

    mysql -u"$MYSQL_USER" -p"$MYSQL_ROOT_PASSWORD" -h"$MYSQL_HOST" -D"$MYSQL_DATABASE" -e "$query" &>>"$LOG_FILE"
    if [[ $? -eq 0 ]]; then
        log_message "Successfully inserted user: ID=$id, Name=$name, Age=$age"
        echo "Successfully inserted user: ID=$id, Name=$name, Age=$age"
    else
        log_message "Failed to insert user: ID=$id, Name=$name, Age=$age"
        echo "Failed to insert user: ID=$id, Name=$name, Age=$age"
    fi
}

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
