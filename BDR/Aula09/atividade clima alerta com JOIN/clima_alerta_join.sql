-- ==========================================
-- DROP DAS TABELAS 
-- ==========================================
DROP TABLE IF EXISTS alerta CASCADE;
DROP TABLE IF EXISTS relato CASCADE;
DROP TABLE IF EXISTS evento CASCADE;
DROP TABLE IF EXISTS telefone CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS localizacao CASCADE;
DROP TABLE IF EXISTS estado CASCADE;
DROP TABLE IF EXISTS tipo_evento CASCADE;

-- ==========================================
-- CRIAÇÃO DAS TABELAS
-- ==========================================

-- Tipos de Evento
CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Estados
CREATE TABLE estado (
    sigla_estado CHAR(2) PRIMARY KEY,
    nome_estado VARCHAR(100) NOT NULL
);

-- Localização
CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL REFERENCES estado(sigla_estado)
);

-- Usuários
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

-- Telefones
CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Eventos
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(30) CHECK (status IN ('Ativo','Em Monitoramento','Resolvido')),
    id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);

-- Relatos
CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Alertas
CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('Baixo','Médio','Alto','Crítico')),
    id_evento INT NOT NULL REFERENCES evento(id_evento)
);

-- ==========================================
-- INSERTS
-- ==========================================

-- Tipo de evento 
INSERT INTO tipo_evento (nome, descricao)
VALUES 
('Queimada', 'Incêndio florestal em área de vegetação');

-- Estados
INSERT INTO estado (sigla_estado, nome_estado)
VALUES 
('SP', 'São Paulo'),
('RJ', 'Rio de Janeiro'),
('MG', 'Minas Gerais'),
('PR', 'Paraná'),
('GO', 'Goiás');

-- Localizações 
INSERT INTO localizacao (latitude, longitude, cidade, sigla_estado)
VALUES 
(-23.2237, -45.9009, 'Jacareí', 'SP'),
(-22.9035, -43.2096, 'Rio de Janeiro', 'RJ'),
(-19.9167, -43.9345, 'Belo Horizonte', 'MG'),
(-25.4284, -49.2733, 'Curitiba', 'PR'),
(-16.6869, -49.2648, 'Goiânia', 'GO');

-- Usuários
INSERT INTO usuario (nome, email, senha_hash)
VALUES 
('João Silva', 'joao@email.com', 'hash123'),
('Maria Oliveira', 'maria@email.com', 'hash456');

-- Telefones
INSERT INTO telefone (numero, id_usuario)
VALUES 
('11999999999', 1),
('21988888888', 2);

-- Eventos 
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES 
('Queimada zona norte', 'Queimada intensa na zona rural de Jacareí', '2025-08-27 14:30:00', 'Em Monitoramento', 1, 1),
('Queimada rodovia', 'Queimada de médio porte próxima à rodovia no RJ', '2025-06-25 15:20:00', 'Ativo', 1, 2),
('Queimada zona sul', 'Queimada forte na zona sul de BH', '2025-04-27 14:30:00', 'Em Monitoramento', 1, 3),
('Queimada sítio verde', 'Queimada leve em área de chácara em Curitiba', '2025-07-25 15:20:00', 'Ativo', 1, 4),
('Queimada parque central', 'Grande queimada no parque central de Goiânia', '2025-09-01 20:15:00', 'Ativo', 1, 5);

-- Relatos
INSERT INTO relato (texto, data_hora, id_evento, id_usuario)
VALUES 
('A fumaça está aumentando rapidamente', '2025-08-27 15:00:00', 1, 1),
('Visibilidade prejudicada na rodovia', '2025-06-25 15:40:00', 2, 2);

-- Alertas
INSERT INTO alerta (mensagem, data_hora, nivel, id_evento)
VALUES 
('Risco alto de intoxicação pela fumaça', '2025-08-27 15:10:00', 'Alto', 1),
('Evite transitar pela rodovia', '2025-06-25 15:50:00', 'Crítico', 2);

-- ==========================================
-- CONSULTAS
-- ==========================================

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

-- Select com order by e limit
SELECT * FROM evento
ORDER BY data_hora DESC
LIMIT 3;


-- ==========================================
-- CONSULTAS DO EXERCÍCIO
-- ==========================================

-- Consulta A:
-- Retorna título do evento e nome do tipo de evento.
-- INNER JOIN → apenas eventos que possuem tipo associado.
SELECT 
    e.titulo,
    te.nome AS tipo_evento
FROM evento AS e
INNER JOIN tipo_evento AS te 
    ON e.id_tipo_evento = te.id_tipo_evento;


-- Consulta B:
-- Retorna título do evento, cidade e sigla do estado.
-- INNER JOIN → apenas eventos com localização registrada.
SELECT 
    e.titulo,
    l.cidade,
    l.sigla_estado
FROM evento AS e
INNER JOIN localizacao AS l 
    ON e.id_localizacao = l.id_localizacao;


-- Consulta C:
-- Retorna título, tipo de evento e cidade.
-- LEFT JOIN → garante que todos os eventos apareçam, mesmo que algum não tenha localização.
SELECT 
    e.titulo,
    te.nome AS tipo_evento,
    l.cidade
FROM evento AS e
LEFT JOIN tipo_evento AS te 
    ON e.id_tipo_evento = te.id_tipo_evento
LEFT JOIN localizacao AS l 
    ON e.id_localizacao = l.id_localizacao;


-- Consulta D:
-- Mesma lógica da Consulta B, mas usando RIGHT JOIN (inversão da ordem das tabelas).
-- Resultado equivalente, porém menos intuitivo.
SELECT 
    e.titulo,
    l.cidade,
    l.sigla_estado
FROM localizacao AS l
RIGHT JOIN evento AS e 
    ON e.id_localizacao = l.id_localizacao;


-- Consulta E:
-- Mostra a quantidade de eventos por cidade.
-- Uso de JOIN + GROUP BY + ORDER BY → análise agregada clara.
SELECT 
    l.cidade,
    COUNT(e.id_evento) AS qtd_eventos
FROM localizacao AS l
INNER JOIN evento AS e 
    ON e.id_localizacao = l.id_localizacao
GROUP BY l.cidade
ORDER BY qtd_eventos DESC;

