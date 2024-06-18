FROM ubuntu:latest

RUN apt-get update && apt-get install -y mysql-client

COPY . /app
WORKDIR /app

COPY env.cnf /root/env.cnf

RUN chmod +x /app/insert_data.sh /app/read_data.sh
RUN chmod +x /app/insert_data.py /app/read_data.py

ENTRYPOINT ["tail", "-f", "/dev/null"]
