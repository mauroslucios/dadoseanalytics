-- Criação de Banco de Dados e Tabelas
create database clinica;

-- Colocar o banco de dados clinica como padrão
use clinica;


-- Criando tabela tipo telefone
create table tb_tipo_telefone(
    tel_id_tipo int(11) auto_increment primary key,
    tipo_telefone varchar(12) not null
);

-- Criando tabela telefone
create table tb_telefone(
    tel_id int(11) auto_increment primary key,
    tel_numero varchar(20) not null,
    tel_ddd char(3) not null,
    tel_id_tipo int(11) not null,
    foreign key(tel_id_tipo) references tb_tipo_telefone(tel_id_tipo)
)engine=InnoDB;

-- Criando tabela tipo endereço
create table tb_tipo_endereco(
    end_tipo_id int(11) auto_increment primary key,
    tipo_endereco varchar(12) not null
);

-- Criando tabela endereço
create table tb_endereco(
end_id int(11) auto_increment primary key,
end_rua varchar(100) not null,
end_numero int(11) not null,
end_bairro varchar(100) not null,
end_cidade varchar(100) not null,
end_cep varchar(10) not null,
end_estado char(2) not null,
end_tipo_id int not null,
foreign key(end_tipo_id) references tb_tipo_endereco(end_tipo_id)
)engine=InnoDB;

-- Criando especialidade
create table tb_especialidade(
    esp_id int(11) auto_increment primary key,
    especialidade varchar(30) not null
);

-- Criando tabela médico
create table tb_medico(
    med_id int(11) auto_increment primary key,
    med_nome varchar(50) not null,
    med_crm varchar(10) not null unique,
    med_email varchar(50) not null unique
)engine=InnoDB;

-- Criando tabela paciente
create table tb_paciente(
    pac_id int(11) auto_increment primary key,
    pac_nome varchar(50) not null,
    pac_cpf varchar(11) not null unique,
    pac_data_nascimento date not null,
    pac_sexo char(1) not null,
    pac_email varchar(50) not null unique
)engine=InnoDB;

-- Criando tabela consulta
create table tb_consulta(
    con_id int(11) auto_increment primary key,
    con_data date not null,
    con_hora time not null,
    med_id int(11) not null,
    pac_id int(11) not null,
    foreign key(med_id) references tb_medico(med_id),
    foreign key(pac_id) references tb_paciente(pac_id),
    status_consulta varchar(15) not null
)engine=InnoDB;


mysql> show tables;
+-------------------+
| Tables_in_clinica |
+-------------------+
| tb_consulta       |
| tb_endereco       |
| tb_especialidade  |
| tb_medico         |
| tb_paciente       |
| tb_telefone       |
| tb_tipo_endereco  |
| tb_tipo_telefone  |
+-------------------+

-- Modificar o collate das tabelas
ALTER TABLE tb_consulta
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE tb_endereco
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE tb_especialidade
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE tb_medico
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE tb_paciente
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE tb_telefone
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE tb_tipo_endereco
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE tb_tipo_telefone
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- Verificar o collate
SELECT DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'clinica';

SELECT COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'clinica' AND TABLE_NAME = 'tb_consulta';


-- Show create table
SHOW CREATE TABLE nome_tabela;

-- criando tabela com collate
CREATE TABLE exemplo (
    coluna1 VARCHAR(100) NOT NULL
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
