CREATE database rede_games;


DROP TABLE IF EXISTS loja;
DROP TABLE IF EXISTS jogo;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS compra;
DROP TABLE IF EXISTS compra_jogo;



CREATE TABLE loja (
	id_loja SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	cidade VARCHAR(255)
);

CREATE TABLE jogo (
	id_jogo SERIAL PRIMARY KEY,
	titulo VARCHAR(255),
	ano_lancamento INT,
	genero VARCHAR(100)
);

CREATE TABLE cliente (
	id_jogo SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	email VARCHAR(255) UNIQUE NOT NULL,
	
);

CREATE TABLE compra (
	)