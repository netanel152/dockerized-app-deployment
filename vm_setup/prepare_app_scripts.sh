#!/bin/bash

set -e

# Set permissions and convert line endings for app scripts
echo -e "\nPreparing app scripts...\n"
scripts=(
    "app/insert_data.sh"
    "app/read_data.sh"
    "run_insert.sh"
    "run_read.sh"
    "run_insert_py.sh"
    "run_read_py.sh"
    "app/insert_data.py"
    "app/read_data.py"
)

# Iterate over each script and set permissions
for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        echo -e "Setting permissions on $script"
        chmod +x "$script" || echo "Setting permissions on $script failed"
    else
        echo "Script $script not found, skipping."
    fi
done

# Convert line endings
dos2unix app/insert_data.sh || echo "Converting line endings for insert_data.sh failed"
dos2unix app/read_data.sh || echo "Converting line endings for read_data.sh failed"
