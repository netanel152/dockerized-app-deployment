import logging
import mysql.connector
from mysql.connector import Error
import os

log_directory = '/app/logs'
log_file = os.path.join(log_directory, 'mysql_query.log')

if not os.path.exists(log_directory):
    os.makedirs(log_directory)

if not os.path.exists(log_file):
    with open(log_file, 'w') as file:
        pass

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

def load_db_config():
    try:
        db_config = {
            'user': os.getenv('MYSQL_USER'),
            'password': os.getenv('MYSQL_ROOT_PASSWORD'),
            'host': os.getenv('MYSQL_HOST'),
            'database': os.getenv('MYSQL_DATABASE'),
            'use_pure': True,
            'ssl_disabled': True,
        }
        return db_config
    except Exception as e:
        logging.error(f"Error reading config file: {e}")
        raise

def connect_to_db(db_config):
    try:
        connection = mysql.connector.connect(**db_config)
        if connection.is_connected():
            logging.info("Connected to the MySQL database.")
            return connection
        else:
            logging.error("Failed to connect to MySQL database.")
            raise Error("Failed to connect to MySQL database.")
    except Error as e:
        logging.error(f"Database connection error: {e}")
        raise

def user_exists(cursor, name):
    check_query = "SELECT COUNT(*) FROM users WHERE Name = %s"
    cursor.execute(check_query, (name,))
    result = cursor.fetchone()
    return result[0] > 0

def insert_user(cursor, name, age):
    insert_query = "INSERT INTO users (ID, Name, Age) VALUES (UUID(), %s, %s)"
    cursor.execute(insert_query, (name, age))

def main():
    db_config = load_db_config()

    connection = None
    try:
        connection = connect_to_db(db_config)
        cursor = connection.cursor()

        while True:
            name = get_input("Enter name: ", is_non_empty_string, "Name cannot be empty. Please enter a valid name.")
            if user_exists(cursor, name):
                logging.warning(f"Name {name} already exists in the database.")
                print("Name already exists. Please enter a different name.")
            else:
                break

        age = get_input("Enter age: ", is_positive_integer, "Age must be a number. Please enter a valid age.")

        insert_user(cursor, name, age)
        connection.commit()
        logging.info(f"Inserted {name}, {age} into the database.")
        print(f"Successfully inserted user: name: {name}, age: {age}")
    
    except Error as e:
        logging.error(f"Error: {e}")
        print(f"Failed to insert data into MySQL table. Error: {e}")
    
    finally:
        if connection is not None and connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    main()
