FROM ubuntu:latest

RUN apt-get update && apt-get install -y mysql-client

COPY . /app
WORKDIR /app

COPY env.cnf /root/env.cnf

RUN chmod +x /app/insert_data.sh /app/read_data.sh

ENTRYPOINT ["tail", "-f", "/dev/null"]
