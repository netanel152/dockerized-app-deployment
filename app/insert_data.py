import logging
import mysql.connector
from mysql.connector import Error
import configparser
import os

# Ensure the logs directory exists
log_directory = '/app/logs'
log_file = os.path.join(log_directory, 'mysql_query.log')

if not os.path.exists(log_directory):
    os.makedirs(log_directory)

# Ensure the log file exists
if not os.path.exists(log_file):
    with open(log_file, 'w') as file:
        pass

# Configure logging
logging.basicConfig(filename=log_file, level=logging.INFO,
                    format='%(asctime)s:%(levelname)s:%(message)s')

def get_input(prompt, validation_fn, error_message):
    while True:
        user_input = input(prompt)
        if validation_fn(user_input):
            return user_input
        else:
            print(error_message)

def is_non_empty_string(s):
    return bool(s.strip())

def is_positive_integer(s):
    return s.isdigit()

def main():
    name = get_input("Enter name: ", is_non_empty_string, "Name cannot be empty. Please enter a valid name.")
    age = get_input("Enter age: ", is_positive_integer, "Age must be a number. Please enter a valid age.")

    # Read database credentials from env.cnf
    config = configparser.ConfigParser()
    try:
        config.read('/app/env.cnf')
        db_config = {
            'user': config['client']['user'],
            'password': config['client']['password'],
            'host': config['client']['host'],
            'database': config['client']['database']
        }

    except Exception as e:
        logging.error(f"Error reading config file: {e}")
        print(f"Error reading config file: {e}")
        return

    connection = None
    try:
        connection = mysql.connector.connect(**db_config)
        if connection.is_connected():
            logging.info("Connected to the MySQL database.")
            print("Connected to the MySQL database.")  # Print to verify
            cursor = connection.cursor()
            insert_query = "INSERT INTO users (ID, Name, Age) VALUES (UUID(), %s, %s)"
            cursor.execute(insert_query, (name, age))
            connection.commit()
            logging.info(f"Inserted {name}, {age} into the database.")
            print("Data inserted successfully.")
        else:
            logging.error("Failed to connect to MySQL database.")
            print("Failed to connect to MySQL database.")
    
    except Error as e:
        logging.error(f"Error: {e}")
        print(f"Failed to insert data into MySQL table. Error: {e}")
    
    finally:
        if connection is not None and connection.is_connected():
            cursor.close()
            connection.close()
            logging.info("MySQL connection is closed.")
            print("MySQL connection is closed.")  # Print to verify

if __name__ == "__main__":
    main()
