#!/bin/bash
set -e

mysql -u root -prootpassword -e "USE application_db; CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  age INT
);"
