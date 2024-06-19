#!/bin/bash
docker-compose exec app /bin/bash -c "python3 /app/insert_data.py"
