import os
import logging
import mysql.connector
from mysql.connector import Error
import configparser

# Configure logging
logging.basicConfig(filename='/app/insert_data.log', level=logging.INFO,
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
    config.read('/app/env.cnf')

    db_config = {
        'user': config['client']['user'],
        'password': config['client']['password'],
        'host': config['client']['host'],
        'database': config['client']['database'],
        'ssl_ca': config['client']['ssl-ca'],
        'ssl_cert': config['client']['ssl-cert'],
        'ssl_key': config['client']['ssl-key']
    }

    connection = None
    try:
        connection = mysql.connector.connect(**db_config)
        
        if connection.is_connected():
            cursor = connection.cursor()
            insert_query = "INSERT INTO users (Name, Age) VALUES (%s, %s)"
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
        if connection and connection.is_connected():
            cursor.close()
            connection.close()
            logging.info("MySQL connection is closed.")

if __name__ == "__main__":
    main()
