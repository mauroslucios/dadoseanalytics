-- Criação da tabela de Municípios
CREATE TABLE municipios(
   id_municipio INT AUTO_INCREMENT PRIMARY KEY,
   nome_municipio varchar(45) NOT null UNIQUE)
   ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela de Pacientes
CREATE TABLE tb_pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    idade INT NOT NULL CHECK (idade >= 0),  -- Corrigindo a referência
    sexo CHAR(1) CHECK (sexo IN ('M', 'm', 'F', 'f')),
    etnia VARCHAR(7) NOT NULL,
    nivel_social VARCHAR(25) NOT NULL,
    id_municipio INT NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_municipio) REFERENCES tb_municipios(id_municipio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela de Comorbidades
CREATE TABLE comorbidades (
   id_comorbidade INT AUTO_INCREMENT PRIMARY KEY,
   nome_comorbidade VARCHAR(45) NOT NULL UNIQUE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- Tabela de relação entre Pacientes e Comorbidades (Muitos-para-Muitos)
CREATE TABLE tb_pacienteComorbidades (
    id_paciente INT NOT NULL,
    id_comorbidade INT NOT NULL,
    PRIMARY KEY (id_paciente,id_comorbidade),
    FOREIGN KEY (id_paciente) REFERENCES tb_pacientes(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_comorbidade) REFERENCES tb_comorbidades(id_comorbidade) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela especialização
CREATE TABLE tb_especializacao(
    id_especializacao INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela de Médicos
CREATE TABLE tb_doutores(
    id_doutor INT AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL,
    id_especializacao INT NOT NULL,
    id_municipio INT NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id_doutor, id_municipio,id_especializacao),
    FOREIGN KEY (id_municipio) REFERENCES tb_municipios(id_municipio)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE tb_doutores
DROP PRIMARY KEY,
ADD PRIMARY KEY (id_doutor);
ALTER TABLE tb_doutores
ADD UNIQUE (id_especializacao);
  
-- Criação da da tabela de medicamentos
CREATE TABLE tb_medicamentos(
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL UNIQUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- Criação da tabela tipo doenças
CREATE TABLE tb_tipo_doencas(
    id_tipo_doenca INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL UNIQUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela de doenças
CREATE TABLE tb_doencas(
    id_doenca INT AUTO_INCREMENT,
    tipo_doenca INT NOT NULL,
    nome VARCHAR(45) NOT NULL UNIQUE,
    PRIMARY KEY(id_doenca, tipo_doenca),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela tratamentos
CREATE TABLE tb_tratamentos(
    id_tratamento INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_doutor INT NOT NULL,
    id_medicamento INT NOT NULL,
    id_doenca INT NOT NULL,
    data_tratamento DATE NOT NULL,
    id_municipio INT NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('Em progresso', 'Completo', 'Cancelado')),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES tb_pacientes(id_paciente) ON DELETE SET NULL,
    FOREIGN KEY (id_doutor) REFERENCES tb_doutores(id_doutor),
    FOREIGN KEY (id_municipio) REFERENCES tb_municipios(id_municipio),
    FOREIGN KEY (id_medicamento) REFERENCES tb_medicamentos(id_medicamento),
    FOREIGN KEY (id_doenca) REFERENCES tb_doencas(id_doenca) -- Adicionei a FK correta para id_doenca
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela de consultas
CREATE TABLE tb_consultas(
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_doutor INT NOT NULL,
    id_municipio INT NOT NULL,
    data_consulta DATE NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES tb_pacientes(id_paciente),
    FOREIGN KEY (id_doutor) REFERENCES tb_doutores(id_doutor),
    FOREIGN KEY (id_municipio) REFERENCES tb_municipios(id_municipio)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
-- Criação da tabela de Óbitos
CREATE TABLE tb_obitos (
    id_obito INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_doutor INT NOT NULL,
    id_municipio INT NOT NULL,
    data_obito DATETIME NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES tb_pacientes(id_paciente),
    FOREIGN KEY (id_doutor) REFERENCES tb_doutores(id_doutor),
    FOREIGN KEY (id_municipio) REFERENCES tb_municipios(id_municipio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
-- Criação da tabela de Curados
CREATE TABLE tb_curados(
    id_curado INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_doutor INT NOT NULL,
    id_municipio INT NOT NULL,
    data_cura DATE NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES tb_pacientes(id_paciente),
    FOREIGN KEY (id_doutor) REFERENCES tb_doutores(id_doutor),
    FOREIGN KEY (id_municipio) REFERENCES tb_municipios(id_municipio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
DELIMITER $$
 
CREATE TRIGGER before_insert_tb_curados
BEFORE INSERT ON tb_curados
FOR EACH ROW
BEGIN
    IF NEW.data_cura > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: data_cura não pode ser no futuro';
    END IF;
END $$
 
DELIMITER ;
DELIMITER $$
 
CREATE TRIGGER before_update_tb_curados
BEFORE UPDATE ON tb_curados
FOR EACH ROW
BEGIN
    IF NEW.data_cura > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: data_cura não pode ser no futuro';
    END IF;
END $$
 
DELIMITER ;
 
-- Adicionar índices para colunas frequentemente utilizadas em filtros
CREATE INDEX idx_pacientes_nome ON tb_pacientes(nome);
CREATE INDEX idx_doutores_nome ON tb_doutores(nome);
CREATE INDEX idx_tratamentos_doencas ON tb_tratamentos(id_doenca);
CREATE INDEX idx_obitos_doenca ON tb_doencas(id_doenca);
CREATE INDEX idx_curados_doenca ON tb_curados(id_curado);
 
-- View para análise de curados por município e doença
CREATE VIEW vw_curados_municipio_doenca AS
SELECT
    tb_municipios.nome_municipio AS municipio,
    tb_doencas.nome AS doenca,
    COUNT(tb_curados.id_curado) AS curados
FROM tb_curados
INNER JOIN tb_tratamentos ON tb_curados.id_paciente = tb_tratamentos.id_paciente
INNER JOIN tb_doencas ON tb_tratamentos.id_doenca = tb_doencas.id_doenca
INNER JOIN tb_municipios ON tb_curados.id_municipio = tb_municipios.id_municipio
GROUP BY tb_municipios.nome_municipio, tb_doencas.nome;
 
-- View para análise de óbitos por município e doença
CREATE VIEW vw_obitos_municipio_doenca AS
SELECT
    tb_municipios.nome_municipio AS municipio,
    tb_doencas.nome AS doenca,
    COUNT(tb_obitos.id_obito) AS obitos
FROM tb_obitos
INNER JOIN tb_tratamentos ON tb_obitos.id_paciente = tb_tratamentos.id_paciente
INNER JOIN tb_doencas ON tb_tratamentos.id_doenca = tb_doencas.id_doenca
INNER JOIN tb_municipios ON tb_obitos.id_municipio = tb_municipios.id_municipio
GROUP BY tb_municipios.nome_municipio, tb_doencas.nome;
 
-- Trigger para registrar alterações na tabela tb_tratamentos
CREATE TABLE tb_tratamentos_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    id_tratamento INT NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_tratamento) REFERENCES tb_tratamentos(id_tratamento)
);
 
DELIMITER $$
 
CREATE TRIGGER trg_tratamentos_update
AFTER UPDATE ON tb_tratamentos
FOR EACH ROW
BEGIN
    -- Só registra no log se o status foi alterado
    IF OLD.status <> NEW.status THEN
        INSERT INTO tb_tratamentos_log (id_tratamento, old_status, new_status, data_alteracao)
        VALUES (NEW.id_tratamento, OLD.status, NEW.status, NOW());
    END IF;
END $$
 
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 0; -- Desativa a verificação de chaves estrangeiras temporariamente

TRUNCATE TABLE tb_pacienteComorbidades;
TRUNCATE TABLE tb_pacientes;
TRUNCATE TABLE tb_doutores;
TRUNCATE TABLE tb_tratamentos;
TRUNCATE TABLE tb_consultas;
TRUNCATE TABLE tb_obitos;
TRUNCATE TABLE tb_curados;
TRUNCATE TABLE tb_municipios; -- Agora pode truncar sem erro

SET FOREIGN_KEY_CHECKS = 1; -- Reativa a verificação de chaves estrangeiras
--------------------------------------------------------------------
INSERT INTO tb_municipios (nome_municipio) VALUES
('Rio de Janeiro'), ('São Paulo'), ('Belo Horizonte'), ('Salvador'), ('Fortaleza'),
('Brasília'), ('Curitiba'), ('Manaus'), ('Recife'), ('Porto Alegre'),
('Belém'), ('Goiânia'), ('São Luís'), ('Maceió'), ('Natal'),
('Teresina'), ('João Pessoa'), ('Campo Grande'), ('Cuiabá'), ('Aracaju'),
('Florianópolis'), ('Macapá'), ('Boa Vista'), ('Palmas'), ('Vitória'),
('Londrina'), ('Niterói'), ('Santos'), ('Uberlândia'), ('Ribeirão Preto'),
('Sorocaba'), ('Juiz de Fora'), ('Joinville'), ('São José dos Campos'), ('Caxias do Sul'),
('Campina Grande'), ('Petrolina'), ('Maringá'), ('Bauru'), ('Foz do Iguaçu'),
('Blumenau'), ('Vila Velha'), ('Canoas'), ('Franca'), ('Anápolis'),
('Pelotas'), ('Mossoró'), ('Chapecó'), ('Cascavel'), ('Imperatriz'),
('Cariacica'), ('Marabá'), ('Rio Branco'), ('Itabuna'), ('Santa Maria'),
('Governador Valadares'), ('Sobral'), ('Caxias'), ('São Carlos'), ('Itaquaquecetuba'),
('Jundiaí'), ('Caruaru'), ('Suzano'), ('Divinópolis'), ('Sete Lagoas'),
('Americana'), ('Luziânia'), ('Barra Mansa'), ('Santa Luzia'), ('Teófilo Otoni'),
('Volta Redonda'), ('Aparecida de Goiânia'), ('Patos de Minas'), ('Parnaíba'), ('Dourados'),
('Linhares'), ('Marília'), ('Novo Hamburgo'), ('Cubatão'), ('Araraquara'),
('São Leopoldo'), ('Passo Fundo'), ('Arapiraca'), ('Varginha'), ('Pouso Alegre'),
('São João de Meriti'), ('Jequié'), ('Itajaí'), ('Taboão da Serra'), ('Itapetininga'),
('Barretos'), ('Paulista'), ('Maricá'), ('Rio Verde'), ('Guarapuava'),
('Santana de Parnaíba'), ('Pindamonhangaba'), ('Paranaguá'), ('Araçatuba'), ('Botucatu');
-------------------------------------
INSERT INTO tb_pacientes (nome, idade, sexo, etnia, nivel_social, id_municipio) VALUES
('Carlos Silva', 45, 'M', 'Branco', 'Média', 1),
('Ana Souza', 32, 'F', 'Pardo', 'Baixa', 2),
('João Pereira', 29, 'M', 'Negro', 'Alta', 3),
('Mariana Oliveira', 51, 'F', 'Branco', 'Média', 4),
('Fernando Rocha', 63, 'M', 'Pardo', 'Baixa', 5),
('Lucas Mendes', 38, 'M', 'Branco', 'Alta', 6),
('Juliana Costa', 27, 'F', 'Indígena', 'Média', 7),
('Paulo Henrique', 54, 'M', 'Negro', 'Baixa', 8),
('Gabriela Nunes', 33, 'F', 'Branco', 'Média', 9),
('Ricardo Almeida', 47, 'M', 'Pardo', 'Alta', 10),
('Amanda Ferreira', 22, 'F', 'Negro', 'Baixa', 11),
('Thiago Ramos', 41, 'M', 'Branco', 'Média', 12),
('Fernanda Lopes', 30, 'F', 'Pardo', 'Alta', 13),
('Eduardo Batista', 28, 'M', 'Indígena', 'Baixa', 14),
('Beatriz Lima', 35, 'F', 'Negro', 'Média', 15),
('Roberto Martins', 50, 'M', 'Branco', 'Alta', 16),
('Tatiane Souza', 37, 'F', 'Pardo', 'Baixa', 17),
('Gustavo Moreira', 42, 'M', 'Negro', 'Média', 18),
('Raquel Andrade', 26, 'F', 'Branco', 'Alta', 19),
('Vinícius Duarte', 48, 'M', 'Pardo', 'Baixa', 20);
-----------------------------------------
INSERT INTO tb_comorbidades (nome_comorbidade) VALUES
('Diabetes'),
('Hipertensão'),
('Asma'),
('Doença Cardíaca'),
('Obesidade'),
('Doença Renal Crônica'),
('Câncer'),
('HIV/AIDS'),
('Doença Pulmonar Crônica'),
('Tuberculose');
----------------------------------------
INSERT INTO tb_pacienteComorbidades (id_paciente, id_comorbidade) VALUES
(1, 1), (1, 3), (2, 2), (2, 4), (3, 5),
(4, 6), (5, 7), (6, 8), (7, 9), (8, 10),
(9, 1), (10, 2), (11, 3), (12, 4), (13, 5),
(14, 6), (15, 7), (16, 8), (17, 9), (18, 10);
------------------------------------------
INSERT INTO tb_doutores (name, id_especializacao, id_municipio) VALUES
('Dr. Pedro Almeida', 1, 1),
('Dra. Luiza Fernandes', 2, 2),
('Dr. Marcos Silva', 3, 3),
('Dra. Vanessa Oliveira', 4, 4),
('Dr. Renato Costa', 5, 5),
('Dra. Helena Lima', 1, 6),
('Dr. Bruno Rocha', 2, 7),
('Dra. Gabriela Nunes', 3, 8),
('Dr. Fábio Martins', 4, 9),
('Dra. Carolina Duarte', 5, 10);
--------------------------
INSERT INTO tb_tratamentos (id_paciente, id_doutor, id_medicamento, id_doenca, data_tratamento, id_municipio, status) VALUES
(1, 1, 1, 1, '2024-01-15', 1, 'Em progresso'),
(2, 2, 2, 2, '2024-02-20', 2, 'Completo'),
(3, 3, 3, 3, '2024-03-10', 3, 'Cancelado'),
(4, 4, 4, 4, '2024-04-05', 4, 'Em progresso'),
(5, 5, 5, 5, '2024-05-12', 5, 'Completo');
----------------------------
INSERT INTO tb_tipo_doencas (id_tipo_doenca, nome) VALUES
(1, 'Bacteriana'),
(2, 'Viral'),
(3, 'Fúngica'),
(4, 'Parasitária'),
(5, 'Genética');

INSERT INTO tb_doencas (id_doenca, tipo_doenca, nome) VALUES
(1, 1, 'Tuberculose'),
(2, 2, 'Covid-19'),
(3, 3, 'Candidíase'),
(4, 4, 'Malária'),
(5, 5, 'Fibrose Cística');
---------------------------
INSERT INTO tb_especializacao (id_especializacao, nome) VALUES
(1, 'Pneumologia'),
(2, 'Infectologia'),
(3, 'Clínica Geral'),
(4, 'Pediatria'),
(5, 'Medicina da Família');
------------------------------------
SELECT * FROM tb_pacientes;
SELECT * FROM tb_doutores;
SELECT * FROM tb_municipios;
---------------------------
INSERT INTO tb_obitos (id_paciente, id_doutor, id_municipio, data_obito)
VALUES
(1, 1, 1, '2024-01-15'),
(2, 2, 2, '2024-02-20'),
(3, 3, 3, '2024-03-10');
--------------------------
INSERT INTO tb_curados (id_paciente, id_doutor, id_municipio, data_cura) 
VALUES
(1, 1, 1, '2024-01-10'),
(2, 2, 2, '2024-02-15'),
(3, 3, 3, '2024-03-20');


