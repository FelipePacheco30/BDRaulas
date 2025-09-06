-- ==========================================
-- INSERÇÃO DE DADOS INICIAIS
-- ==========================================

INSERT INTO loja (nome, cidade) VALUES
('Loja Central', 'São Paulo'),
('Game House', 'Rio de Janeiro'),
('E-Sports Mania', 'Belo Horizonte');

INSERT INTO cliente (nome, email, cidade) VALUES
('Ana Souza', 'ana@email.com', 'São Paulo'),
('Bruno Lima', 'bruno@email.com', 'Rio de Janeiro'),
('Carlos Mendes', 'carlos@email.com', 'Belo Horizonte');

INSERT INTO jogo (titulo, ano_lancamento, genero) VALUES
('FIFA 24', 2023, 'Esporte'),
('The Last of Us Part II', 2020, 'Ação/Aventura'),
('Cyberpunk 2077', 2021, 'RPG');

INSERT INTO compra (data_compra, id_cliente, id_loja) VALUES
('2025-09-01', 1, 1),
('2025-09-02', 2, 2);

-- Inserir jogos em cada compra
INSERT INTO compra_jogo (id_compra, id_jogo, quantidade) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(2, 3, 2);
