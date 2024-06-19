CREATE DATABASE IF NOT EXISTS user_data_db;

USE user_data_db;

CREATE TABLE IF NOT EXISTS users (
    Name TEXT,
    Age INT
);

-- Use mysql_native_password for the root user
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';

-- Grant all privileges to 'root' user from any host
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
