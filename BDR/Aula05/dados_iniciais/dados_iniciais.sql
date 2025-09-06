-- Criação do Banco de dados
create database clima_alerta;
 
 
-- DROP das tabelas
drop table if exists tipo_evento;
drop table if exists estado;
drop table if exists localizacao;
 
 
--Criação das tabelas
 
-- Tabela de Tipos de Evento
CREATE TABLE tipo_evento (
id_tipo_evento SERIAL PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
descricao TEXT
);
select * from tipo_evento;
 
-- Tabela de Estados
CREATE TABLE estado (
sigla_estado CHAR(2) PRIMARY KEY,
nome_estado VARCHAR(100) NOT NULL
);
select * from tipo_evento;
 
-- Tabela de localização
CREATE TABLE localizacao (
id_localizacao SERIAL PRIMARY KEY,
latitude NUMERIC(9,6) NOT NULL,
longitude NUMERIC(9,6) NOT NULL,
cidade VARCHAR(100) NOT NULL,
sigla_estado CHAR(2) NOT NULL REFERENCES
estado(sigla_estado)
);
select * from localizacao;
 
-- Tabela de Usuários
CREATE TABLE usuario (
id_usuario SERIAL PRIMARY KEY,
nome VARCHAR(150) NOT NULL,
email VARCHAR(150) UNIQUE NOT NULL,
senha_hash VARCHAR(255) NOT NULL
);
select * from usuario;
 
-- Tabela de Telefones do Usuário
CREATE TABLE telefone (
id_telefone SERIAL PRIMARY KEY,
numero VARCHAR(20) NOT NULL,
id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);
select * from telefone;
 
-- Tabela de Eventos
CREATE TABLE evento (
id_evento SERIAL PRIMARY KEY,
titulo VARCHAR(150) NOT NULL,
descricao TEXT,
data_hora TIMESTAMP NOT NULL,
status VARCHAR(30) CHECK (status IN ('Ativo','Em Monitoramento','Resolvido')),
id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);
select * from evento;
 
-- Tabela de Relatos
CREATE TABLE relato (
id_relato SERIAL PRIMARY KEY,
texto TEXT NOT NULL,
data_hora TIMESTAMP NOT NULL,
id_evento INT NOT NULL REFERENCES
evento(id_evento),
id_usuario INT NOT NULL REFERENCES
usuario(id_usuario)
);
select * from relato;
 
-- Tabela de Alertas
CREATE TABLE alerta (
id_alerta SERIAL PRIMARY KEY,
mensagem TEXT NOT NULL,
data_hora TIMESTAMP NOT NULL,
nivel VARCHAR(20) CHECK (nivel IN
('Baixo','Médio','Alto','Crítico')),
id_evento INT NOT NULL REFERENCES
evento(id_evento)
);
select * from alerta;
 
 
-- Inserts
 
INSERT INTO tipo_evento (nome, descricao)
VALUES ('Queimada', 'Incêndio florestal em área de vegetação');
select * from tipo_evento
 
SELECT titulo, status FROM evento WHERE
status = 'Ativo';-- Criação do Banco de dados
create database clima_alerta;
 
 
-- DROP das tabelas
drop table if exists tipo_evento;
drop table if exists estado;
drop table if exists localizacao;
 
 
--Criação das tabelas
 
-- Tabela de Tipos de Evento
CREATE TABLE tipo_evento (
id_tipo_evento SERIAL PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
descricao TEXT
);
select * from tipo_evento;
 
-- Tabela de Estados
CREATE TABLE estado (
sigla_estado CHAR(2) PRIMARY KEY,
nome_estado VARCHAR(100) NOT NULL
);
select * from tipo_evento;
 
-- Tabela de localização
CREATE TABLE localizacao (
id_localizacao SERIAL PRIMARY KEY,
latitude NUMERIC(9,6) NOT NULL,
longitude NUMERIC(9,6) NOT NULL,
cidade VARCHAR(100) NOT NULL,
sigla_estado CHAR(2) NOT NULL REFERENCES
estado(sigla_estado)
);
select * from localizacao;
 
-- Tabela de Usuários
CREATE TABLE usuario (
id_usuario SERIAL PRIMARY KEY,
nome VARCHAR(150) NOT NULL,
email VARCHAR(150) UNIQUE NOT NULL,
senha_hash VARCHAR(255) NOT NULL
);
select * from usuario;
 
-- Tabela de Telefones do Usuário
CREATE TABLE telefone (
id_telefone SERIAL PRIMARY KEY,
numero VARCHAR(20) NOT NULL,
id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);
select * from telefone;
 
-- Tabela de Eventos
CREATE TABLE evento (
id_evento SERIAL PRIMARY KEY,
titulo VARCHAR(150) NOT NULL,
descricao TEXT,
data_hora TIMESTAMP NOT NULL,
status VARCHAR(30) CHECK (status IN ('Ativo','Em Monitoramento','Resolvido')),
id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);
select * from evento;
 
-- Tabela de Relatos
CREATE TABLE relato (
id_relato SERIAL PRIMARY KEY,
texto TEXT NOT NULL,
data_hora TIMESTAMP NOT NULL,
id_evento INT NOT NULL REFERENCES
evento(id_evento),
id_usuario INT NOT NULL REFERENCES
usuario(id_usuario)
);
select * from relato;
 
-- Tabela de Alertas
CREATE TABLE alerta (
id_alerta SERIAL PRIMARY KEY,
mensagem TEXT NOT NULL,
data_hora TIMESTAMP NOT NULL,
nivel VARCHAR(20) CHECK (nivel IN
('Baixo','Médio','Alto','Crítico')),
id_evento INT NOT NULL REFERENCES
evento(id_evento)
);
select * from alerta;
 
 
-- Inserts
 
INSERT INTO tipo_evento (nome, descricao)
VALUES ('Queimada', 'Incêndio florestal em área de vegetação');
select * from tipo_evento



-- Consultas

SELECT titulo, status FROM evento WHERE
status = 'Ativo';''

-- Consultas simples
SELECT id_tipo_evento, nome, descricao FROM tipo_evento;

SELECT id_usuario, nome, email FROM usuario;


-- Consultas com WHERE

SELECT cidade, sigla_estado 
FROM localizacao
WHERE sigla_estado = 'SP';

SELECT titulo, status, data_hora 
FROM evento
WHERE status = 'Ativo';
