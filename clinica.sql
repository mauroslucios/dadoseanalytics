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

