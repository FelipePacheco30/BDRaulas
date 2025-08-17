-- Criação das tabelas 
CREATE TABLE Livro (
    idLivro SERIAL PRIMARY KEY,
    titulo VARCHAR(255),
    anoPublicacao VARCHAR(20),
    isbn VARCHAR(100)
);

CREATE TABLE Autor (
    idAutor SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    nacionalidade VARCHAR(100)
);

CREATE TABLE Cliente (
    idCliente SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(100),
    telefone VARCHAR(50)
);

CREATE TABLE Emprestimo (
    idEmprestimo SERIAL PRIMARY KEY,
    dataEmprestimo DATE,
    dataDevolucao DATE,
    idCliente INT REFERENCES Cliente(idCliente)
);

CREATE TABLE LivroAutor (
    idLivro INT REFERENCES Livro(idLivro),
    idAutor INT REFERENCES Autor(idAutor),
    PRIMARY KEY (idLivro, idAutor)
);

CREATE TABLE EmprestimoLivro (
    idEmprestimo INT REFERENCES Emprestimo(idEmprestimo),
    idLivro INT REFERENCES Livro(idLivro),
    PRIMARY KEY (idEmprestimo, idLivro)
);
