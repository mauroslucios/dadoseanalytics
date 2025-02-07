import random
from faker import Faker

# Configurando o Faker para o idioma português
fake = Faker('pt_BR')


def gerar_cpf(cpf_set):
    """Função para gerar um CPF único."""
    while True:
        cpf = fake.cpf()
        if cpf not in cpf_set:
            cpf_set.add(cpf)
            return cpf


def gerar_email(email_set):
    """Função para gerar um email único."""
    while True:
        email = fake.email()
        if email not in email_set:
            email_set.add(email)
            return email


with open('insert_pacientes.sql', 'w', encoding='utf-8') as f:
    f.write("INSERT INTO tb_paciente (id, nome, cpf, data_nascimento, sexo, email) VALUES\n") # noqa
    
    cpf_set = set()
    email_set = set()

    for i in range(1, 1001):
        nome = fake.name()
        cpf = gerar_cpf(cpf_set)
        data_nascimento = fake.date_of_birth(minimum_age=0, maximum_age=100)
        sexo = random.choice(['M', 'F'])
        email = gerar_email(email_set)
        
        f.write(f"({i}, '{nome}', '{cpf}', '{data_nascimento}', '{sexo}', '{email}'),\n")
        
    f.seek(f.tell() - 2, 0)  # Remove a última vírgula
    f.write(";\n")
    print("aqruivo insert_pacientes.sql criado ou atualizado")