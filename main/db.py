import mysql.connector
import os

config = {
        'user': 'root',
        'password': 'root',
        'host': 'db',
        'port': '3306',
    }
connection = mysql.connector.connect(**config)
cursor = connection.cursor(buffered=True)

cursor.execute('SHOW DATABASES')
if ('omegabank',) not in cursor:
    cursor.execute('CREATE DATABASE omegabank')
else:
    cursor.execute('DROP DATABASE omegabank')
    cursor.execute('CREATE DATABASE omegabank')

cursor.close()
connection.close()

config = {
        'user': 'root',
        'password': 'root',
        'host': 'db',
        'port': '3306',
        'database': 'omegabank'
    }
connection = mysql.connector.connect(**config)
cursor = connection.cursor(buffered=True)

cursor.execute('SHOW TABLES')

# if ('users',) not in cursor:
#     cursor.execute('CREATE TABLE users')

for folder in os.listdir('/app/OmegaBank'):
    if folder != 'CEO':
        for user in os.listdir(f"/app/OmegaBank/{folder}"):
            if user.startswith('ACC'):

                if (user.lower(),) not in cursor:
                    cursor.execute(f'CREATE TABLE {user.lower()} (amount VARCHAR(10), date VARCHAR(10), time VARCHAR(10))')
                with open(f'/app/OmegaBank/{folder}/{user}/Transaction_History.txt', 'r') as f:
                    lines = f.readlines()
                    for line in lines:

                        line = line.split()
                        if len(line)==4:
                            cursor.execute(f'INSERT INTO {user.lower()} (amount, date, time) VALUES ("{line[1]}", "{line[2]}", "{line[3]}")')
                            connection.commit()

cursor.close()
connection.close()





