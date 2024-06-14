FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

COPY insert-data.sh /usr/local/bin/
COPY read-data.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/insert-data.sh
RUN chmod +x /usr/local/bin/read-data.sh

CMD ["bash"]
