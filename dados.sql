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