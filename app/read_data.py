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

def fetch_users(cursor):
    try:
        select_query = "SELECT * FROM users"
        cursor.execute(select_query)
        rows = cursor.fetchall()
        return rows
    except Error as e:
        logging.error(f"Error fetching data: {e}")
        raise

def main():
    try:
        db_config = load_db_config()
        connection = connect_to_db(db_config)
        
        try:
            cursor = connection.cursor()
            rows = fetch_users(cursor)
            for row in rows:
                print(row)
                logging.info(f"Read data: {row}")
        except Error as e:
            logging.error(f"Error during database operations: {e}")
            print("Failed to read data from MySQL table.")
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()
                logging.info("MySQL connection closed.")
    
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
