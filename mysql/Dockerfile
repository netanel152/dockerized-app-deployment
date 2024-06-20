FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=user_data_db

COPY init_db.sql /docker-entrypoint-initdb.d/
# COPY ssl_certs/ca-cert.pem /etc/mysql/ssl/ca-cert.pem
# COPY ssl_certs/server-cert.pem /etc/mysql/ssl/server-cert.pem
# COPY ssl_certs/server-key.pem /etc/mysql/ssl/server-key.pem
# COPY env_ssl.cnf /etc/mysql/env_ssl.cnf

RUN chmod 644 /docker-entrypoint-initdb.d/init_db.sql
# RUN chown -R mysql:mysql /etc/mysql/ssl
# RUN chmod 644 /etc/mysql/ssl/ca-cert.pem
# RUN chmod 644 /etc/mysql/ssl/server-cert.pem
# RUN chmod 600 /etc/mysql/ssl/server-key.pem

EXPOSE 3306
