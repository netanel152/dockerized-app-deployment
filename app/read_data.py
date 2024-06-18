import logging
import mysql.connector
from mysql.connector import Error

# Configure logging
logging.basicConfig(filename='/app/read_data.log', level=logging.INFO,
                    format='%(asctime)s:%(levelname)s:%(message)s')

def main():
    # Read database credentials from env.cnf
    config = {
        'option_files': '/app/env.cnf'
    }

    try:
        connection = mysql.connector.connect(**config)
        
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
            logging.info("MySQL connection is closed.")

if __name__ == "__main__":
    main()
