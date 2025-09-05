-- ==========================================
-- DROP DAS TABELAS
-- ==========================================
DROP TABLE IF EXISTS transacoes CASCADE;
DROP TABLE IF EXISTS contas CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- ==========================================
-- CRIAÇÃO DAS TABELAS
-- ==========================================

-- Tabela de Clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    endereco TEXT,
    telefone VARCHAR(15)
);

-- Tabela de Contas
CREATE TABLE contas (
    id_conta SERIAL PRIMARY KEY,
    numero_conta VARCHAR(10) UNIQUE NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0,
    id_cliente INT REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabela de Transações
CREATE TABLE transacoes (
    id_transacao SERIAL PRIMARY KEY,
    id_conta INT REFERENCES contas(id_conta) ON DELETE CASCADE,
    tipo VARCHAR(15) CHECK (tipo IN ('Depósito', 'Saque', 'Transferência')),
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destino_transferencia INT REFERENCES contas(id_conta)
);

-- ==========================================
-- INSERÇÃO DE DADOS
-- ==========================================

-- Inserindo clientes
INSERT INTO clientes (nome, cpf, endereco, telefone) VALUES
('João Silva', '12345678900', 'Rua A, 123', '11999990000'),
('Maria Oliveira', '98765432100', 'Rua B, 456', '11988887777');

-- Inserindo contas
INSERT INTO contas (numero_conta, saldo, id_cliente) VALUES
('000123', 1500.00, 1),
('000456', 2300.00, 2);

-- Inserindo transações iniciais
INSERT INTO transacoes (id_conta, tipo, valor) VALUES
(1, 'Depósito', 500.00),
(2, 'Saque', 200.00);

-- ==========================================
-- ATIVIDADE
-- ==========================================

-- 1) INSERIR UM NOVO CLIENTE NO SISTEMA
INSERT INTO clientes (nome, cpf, endereco, telefone)
VALUES ('Pedro Santos', '11122233344', 'Rua C, 789', '11977776666');

-- 2) CRIAR UMA CONTA PARA O NOVO CLIENTE
INSERT INTO contas (numero_conta, saldo, id_cliente)
VALUES ('000789', 500.00, (SELECT id_cliente FROM clientes WHERE nome = 'Pedro Santos'));

-- 3) REALIZAR UMA TRANSFERÊNCIA DE R$100,00
-- Registrar a transação
INSERT INTO transacoes (id_conta, tipo, valor, destino_transferencia)
VALUES (
    (SELECT id_conta FROM contas WHERE numero_conta = '000123'),
    'Transferência',
    100.00,
    (SELECT id_conta FROM contas WHERE numero_conta = '000789')
);

-- Atualizar saldo da conta de origem (000123)
UPDATE contas
SET saldo = saldo - 100.00
WHERE numero_conta = '000123';

-- Atualizar saldo da conta de destino (000789)
UPDATE contas
SET saldo = saldo + 100.00
WHERE numero_conta = '000789';

-- 4) LISTAR TODAS AS CONTAS COM SALDOS ATUALIZADOS
SELECT contas.numero_conta, clientes.nome, ROUND(contas.saldo, 2) AS saldo_atual
FROM contas
INNER JOIN clientes ON contas.id_cliente = clientes.id_cliente;
