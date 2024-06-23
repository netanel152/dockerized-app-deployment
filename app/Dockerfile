# Use an official Ubuntu as a parent image
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    mysql-client \
    python3-mysql.connector \
    python3-venv \
    python3-dotenv

COPY . /app

WORKDIR /app

RUN chmod +x /app/insert_data.py /app/read_data.py

RUN chmod +x /app/insert_data.sh /app/read_data.sh

EXPOSE 8080

ENTRYPOINT ["tail", "-f", "/dev/null"]
