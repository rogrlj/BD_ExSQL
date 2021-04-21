/*
Exercicio SQL_Exercicio_Contraints
*/

CREATE DATABASE ExSQL_Constraints
GO

USE ExSQL_Constraints

CREATE TABLE livro (
codigo_livro	INT			NOT NULL	IDENTITY(1,1),
nome			VARCHAR(50)	NULL,
lingua			VARCHAR(20)	NULL		DEFAULT('PT-BR'),
ano				INT			NULL		CHECK(ano > 1989)
PRIMARY KEY (codigo_livro)
)
GO

CREATE TABLE autor (
codigo_autor	INT			 NOT NULL	IDENTITY(1001,1),
nome			VARCHAR(50)	 NULL		UNIQUE,
nascimento		DATE		 NULL,
pais			VARCHAR(40)	 NULL		CHECK (pais= 'Brasil' OR pais='Alemanha'),
biografia		VARCHAR(200) NULL
PRIMARY KEY (codigo_autor)
)
GO

CREATE TABLE livro_autor (
livroCodigo_livro	INT		NOT NULL,
autorCodigo_autor	INT		NOT NULL
PRIMARY KEY (livroCodigo_livro, autorCodigo_autor)
FOREIGN KEY (livroCodigo_livro) REFERENCES livro(codigo_livro),
FOREIGN KEY (autorCodigo_autor) REFERENCES autor(codigo_autor)
)
GO

CREATE TABLE edicoes (
isbn				INT				NOT NULL,
preco				DECIMAL(7,2)	NULL		CHECK(preco >= 0),
ano					INT				NULL		CHECK(ano >= 1993),
num_paginas			INT				NULL		CHECK(num_paginas >= 0),
qtd_estoque			INT				NULL,
livroCodigo_livro	INT				NOT NULL
PRIMARY KEY (isbn)
FOREIGN KEY (livroCodigo_livro) REFERENCES livro(codigo_livro)
)
GO

CREATE TABLE editora (
codigo_editora	INT			NOT NULL	IDENTITY(5501,1),
nome			VARCHAR(50)	NULL		UNIQUE,
logradouro		VARCHAR(50)	NULL,
numero			INT			NULL		CHECK(numero >= 0),
cep				CHAR(8)		NULL,
telefone		CHAR(11)	NULL
PRIMARY KEY(codigo_editora)
)
GO

CREATE TABLE edicoes_editora (
edicoes_isbn			INT NOT NULL,
editoraCodigo_editora	INT NOT NULL
PRIMARY KEY (edicoes_isbn, editoraCodigo_editora)
FOREIGN KEY (edicoes_isbn) REFERENCES edicoes(isbn),
FOREIGN KEY (editoraCodigo_editora) REFERENCES editora(codigo_editora)
)
GO

EXEC sp_help livro
EXEC sp_help autor
EXEC sp_help livro_autor
EXEC sp_help edicoes
EXEC sp_help editora
EXEC sp_help edicoes_editora
