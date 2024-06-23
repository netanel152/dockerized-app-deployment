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
logging.basicConfig(filename='/app/logs/mysql_query.log', level=logging.INFO,
                    format='%(asctime)s:%(levelname)s:%(message)s')

def main():
    # Read database credentials from env.cnf
    config = configparser.ConfigParser()
    config.read('/app/env.cnf')

    db_config = {
        'user': config['client']['user'],
        'password': config['client']['password'],
        'host': config['client']['host'],
        'database': config['client']['database'],
        'use_pure': True,
        'ssl_disabled': True,
    }
    try:
        connection = mysql.connector.connect(**db_config)
        
        if connection.is_connected():
            cursor = connection.cursor()
            select_query = "SELECT * FROM users"
            cursor.execute(select_query)
            rows = cursor.fetchall()
            
            for row in rows:
                print(row)
                logging.info(f"Read data: {row}")
    
    except Error as e:
        logging.error(f"Error: {e}")
        print("Failed to read data from MySQL table.")
    
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    main()
