-- ==========================================
-- CRIAÇÃO DO BANCO DE DADOS
-- ==========================================
CREATE DATABASE rede_games;

-- ==========================================
-- DROP DAS TABELAS
-- ==========================================
DROP TABLE IF EXISTS compra_jogo CASCADE;
DROP TABLE IF EXISTS compra CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS jogo CASCADE;
DROP TABLE IF EXISTS loja CASCADE;

-- ==========================================
-- CRIAÇÃO DAS TABELAS
-- ==========================================

CREATE TABLE loja (
    id_loja SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL
);

CREATE TABLE jogo (
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    ano_lancamento INT NOT NULL,
    genero VARCHAR(100) NOT NULL
);

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    cidade VARCHAR(255) NOT NULL
);

CREATE TABLE compra (
    id_compra SERIAL PRIMARY KEY,
    data_compra DATE NOT NULL,
    id_cliente INT NOT NULL REFERENCES cliente(id_cliente),
    id_loja INT NOT NULL REFERENCES loja(id_loja)
);

CREATE TABLE compra_jogo (
    id_compra INT NOT NULL REFERENCES compra(id_compra),
    id_jogo INT NOT NULL REFERENCES jogo(id_jogo),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (id_compra, id_jogo)
);
