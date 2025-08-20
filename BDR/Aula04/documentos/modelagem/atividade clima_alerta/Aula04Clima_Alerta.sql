--Criação das tabelas
CREATE TABLE TipoEvento (
    idTipoEvento SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT
);

CREATE TABLE Localizacao (
    idLocalizacao SERIAL PRIMARY KEY,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    cidade VARCHAR(100),
    estado VARCHAR(50)
);

CREATE TABLE Usuario (
    idUsuario SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    senhaHash TEXT
);

CREATE TABLE Evento (
    idEvento SERIAL PRIMARY KEY,
    titulo VARCHAR(255),
    descricao TEXT,
    dataHora TIMESTAMP,
    status VARCHAR(50),
    idTipoEvento INT REFERENCES TipoEvento(idTipoEvento),
    idLocalizacao INT REFERENCES Localizacao(idLocalizacao)
);

CREATE TABLE Relato (
    idRelato SERIAL PRIMARY KEY,
    texto TEXT,
    dataHora TIMESTAMP,
    idEvento INT REFERENCES Evento(idEvento),
    idUsuario INT REFERENCES Usuario(idUsuario)
);

CREATE TABLE Alerta (
    idAlerta SERIAL PRIMARY KEY,
    mensagem TEXT,
    dataHora TIMESTAMP,
    nivel VARCHAR(50),
    idEvento INT REFERENCES Evento(idEvento)
);
