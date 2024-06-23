FROM mysql:latest

COPY init_db.sql /docker-entrypoint-initdb.d/

RUN chmod 644 /docker-entrypoint-initdb.d/init_db.sql

EXPOSE 3306
