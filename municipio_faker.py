import random
from faker import Faker
import mysql.connector

fake = Faker()

# Connect to your MySQL database
db_connection = mysql.connector.connect(
    host="172.21.1.2",
    user="root",
    password="123456",
    database="dadosAnalytics"
)
cursor = db_connection.cursor()

# Generate fake municipalities
especializacoes = set()
for _ in range(100):
    especializacoes.add(fake.escializacao())

for especializacao in especializacoes:
    cursor.execute("INSERT INTO tb_especializacao  (nome_escializacao) VALUES (%s)", (especializacao))

# Commit changes and close the connection
db_connection.commit()
cursor.close()
db_connection.close()
