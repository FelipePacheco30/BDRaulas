-- ==========================================
-- DROP DAS TABELAS NA ORDEM CORRETA
-- ==========================================
DROP TABLE IF EXISTS transacoes CASCADE;
DROP TABLE IF EXISTS contas CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- ==========================================
-- CRIAÇÃO DAS TABELAS
-- ==========================================

-- Tabela de Clientes
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50)
);

-- Tabela de Contas
CREATE TABLE contas (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(id),
    saldo NUMERIC(10,2) NOT NULL
);

-- Tabela de Transações
CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    conta_id INT NOT NULL REFERENCES contas(id),
    tipo VARCHAR(20) CHECK (tipo IN ('Depósito','Saque')),
    valor NUMERIC(10,2) NOT NULL,
    data_transacao DATE NOT NULL
);

-- ==========================================
-- INSERÇÃO DE DADOS EXEMPLO
-- ==========================================

-- Inserindo Clientes
INSERT INTO clientes (nome, cidade) VALUES
('Ana', 'São Paulo'),
('Bruno', 'Jacareí'),
('Carlos', 'São José'),
('Diana', 'Jacareí'),
('Eduardo', 'São Paulo');

-- Inserindo Contas
INSERT INTO contas (cliente_id, saldo) VALUES
(1, 5000),
(2, 3500),
(3, 7200),
(4, 4100),
(5, 6000);

-- Inserindo Transações
INSERT INTO transacoes (conta_id, tipo, valor, data_transacao) VALUES
(1, 'Depósito', 1000, '2025-08-01'),
(1, 'Saque', 500, '2025-08-05'),
(2, 'Depósito', 1500, '2025-08-03'),
(3, 'Saque', 200, '2025-08-04'),
(4, 'Depósito', 300, '2025-08-02'),
(5, 'Saque', 1000, '2025-08-06'),
(2, 'Saque', 700, '2025-08-07'),
(3, 'Depósito', 400, '2025-08-08'),
(4, 'Saque', 300, '2025-08-09');

-- ==========================================
-- ATIVIDADE INDIVIDUAL – FUNÇÕES DE AGREGAÇÃO
-- ==========================================

-- 1) Contar quantos clientes estão cadastrados
-- Retorna o total de registros na tabela 'clientes'
SELECT COUNT(*) AS total_clientes
FROM clientes;

-- 2) Calcular o saldo total armazenado no banco
-- Soma todos os valores da coluna 'saldo' da tabela 'contas'
SELECT SUM(saldo) AS saldo_total
FROM contas;

-- 3) Descobrir a média dos saques feitos
-- Calcula a média de todos os valores da coluna 'valor' 
-- da tabela 'transacoes' onde o tipo é 'Saque'
SELECT AVG(valor) AS media_saques
FROM transacoes
WHERE tipo = 'Saque';
