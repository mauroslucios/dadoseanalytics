import random

nomes = ["João", "Maria", "Carlos", "Ana", "Pedro", "Juliana", "Ricardo", "Fernanda", "Marcelo", "Patrícia",
         "Roberto", "Beatriz", "Gustavo", "Camila", "Eduardo", "Larissa", "Renato", "Tatiane", "Fábio", "Gabriela"]

sobrenomes = ["Silva", "Souza", "Oliveira", "Mendes", "Santos", "Ferreira", "Lima", "Costa", "Rocha", "Almeida",
              "Moreira", "Martins", "Ribeiro", "Barbosa", "Carvalho", "Moura", "Pereira", "Araújo", "Vieira", "Campos"]

with open("insert_medicos_clinica.sql", "w", encoding="utf-8") as f:
    f.write("INSERT INTO tb_medico (nome) VALUES\n")

    for i in range(1000):
        nome = f"('{random.choice(nomes)} {random.choice(sobrenomes)}')"
        if i < 999:
            nome += ",\n"
        else:
            nome += ";"

        f.write(nome)

print("Arquivo insert_medicos.sql gerado com sucesso!")
