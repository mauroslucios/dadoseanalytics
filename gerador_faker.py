import random
from faker import Faker
import mysql.connector

fake = Faker()

# Conectar ao banco de dados
db_connection = mysql.connector.connect(
    host="172.21.1.2",
    user="root",
    password="123456",
    database="dadosAnalytics"
)
cursor = db_connection.cursor()

# 🚀 1. GERAR MUNICÍPIOS SEM DUPLICAÇÃO
cursor.execute("SELECT nome_municipio FROM tb_municipios")
municipios_existentes = {row[0] for row in cursor.fetchall()}  # Set para evitar duplicatas

municipalities = set()
while len(municipalities) < 100:
    city = fake.city()
    if city not in municipios_existentes:
        municipalities.add(city)

for municipality in municipalities:
    cursor.execute("INSERT INTO tb_municipios (nome_municipio) VALUES (%s)", (municipality,))

# 🚀 2. RECUPERAR MUNICÍPIOS INSERIDOS
cursor.execute("SELECT id_municipio FROM tb_municipios")
municipios_existentes = [row[0] for row in cursor.fetchall()]

# 🚀 3. GERAR PACIENTES
for _ in range(1000):
    nome = fake.name()
    idade = random.randint(0, 100)
    sexo = random.choice(['M', 'F'])
    etnia = random.choice(['Branca', 'Preta', 'Parda', 'Amarela', 'Indígena'])
    nivel_social = random.choice(['Baixo', 'Médio', 'Alto'])
    id_municipio = random.choice(municipios_existentes)  # Escolhe um município válido

    cursor.execute("""
        INSERT INTO tb_pacientes (nome, idade, sexo, etnia, nivel_social, id_municipio)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (nome, idade, sexo, etnia, nivel_social, id_municipio))

# 🚀 4. FAZER COMMIT PARA GARANTIR QUE OS PACIENTES FORAM INSERIDOS
db_connection.commit()

# 🚀 5. RECUPERAR IDs REAIS DOS PACIENTES
cursor.execute("SELECT id_paciente FROM tb_pacientes")
pacientes_existentes = [row[0] for row in cursor.fetchall()]

# 🚀 6. GERAR COMORBIDADES SEM DUPLICAÇÃO
comorbidities = ['Diabetes', 'Hipertensão', 'Asma', 'Obesidade', 'Câncer']

cursor.execute("SELECT nome_comorbidade FROM tb_comorbidades")
comorbidades_existentes = {row[0] for row in cursor.fetchall()}

for comorbidity in comorbidities:
    if comorbidity not in comorbidades_existentes:
        cursor.execute("INSERT INTO tb_comorbidades (nome_comorbidade) VALUES (%s)", (comorbidity,))

# 🚀 7. FAZER COMMIT PARA GARANTIR QUE AS COMORBIDADES FORAM INSERIDAS
db_connection.commit()

# 🚀 8. RECUPERAR IDs REAIS DAS COMORBIDADES
cursor.execute("SELECT id_comorbidade FROM tb_comorbidades")
comorbidades_existentes = [row[0] for row in cursor.fetchall()]

# 🚀 9. GERAR RELACIONAMENTOS PACIENTE-COMORBIDADE SEM DUPLICAÇÃO
relacoes_existentes = set()

for _ in range(2000):
    id_paciente = random.choice(pacientes_existentes)  # Escolhendo apenas pacientes válidos
    id_comorbidade = random.choice(comorbidades_existentes)

    if (id_paciente, id_comorbidade) not in relacoes_existentes:
        relacoes_existentes.add((id_paciente, id_comorbidade))
        cursor.execute("""
            INSERT INTO tb_pacienteComorbidades (id_paciente, id_comorbidade)
            VALUES (%s, %s)
        """, (id_paciente, id_comorbidade))

# 🚀 10. COMMIT FINAL E FECHAR CONEXÃO
db_connection.commit()
cursor.close()
db_connection.close()
