/*
Exercicio SQL_DDL DML 2
*/

CREATE DATABASE exSQL_DDL_MDL_2
GO
USE exSQL_DDL_MDL_2

CREATE TABLE filme (
id		INT			NOT NULL	IDENTITY(1001,1),
titulo	VARCHAR(40)	NOT NULL,
ano		INT			NULL		CHECK (ano <= 2021)
PRIMARY KEY (id)
)
GO

CREATE TABLE estrela (
id		INT			NOT NULL	IDENTITY(9901,1),
nome	VARCHAR(50)	NOT NULL
PRIMARY KEY (id)
)
GO

CREATE TABLE filme_estrela (
filmeId		INT		NOT NULL,
estrelaId	INT		NOT NULL
PRIMARY KEY (filmeId, estrelaId)
FOREIGN KEY (filmeId) REFERENCES filme(id),
FOREIGN KEY (estrelaId) REFERENCES estrela(id)
)
GO

CREATE TABLE dvd (
num				INT		NOT NULL	IDENTITY(1001,1),
dt_fabricacao	DATE	NOT NULL	CHECK (dt_fabricacao < '2021-04-20'),
fimeId			INT		NOT NULL
PRIMARY KEY (num)
FOREIGN KEY (fimeId) REFERENCES filme(id)
)
GO

CREATE TABLE cliente (
num_cadastro	INT				NOT NULL	IDENTITY(5501,1),
nome			VARCHAR(70)		NOT NULL,
logradouro		VARCHAR(150)	NOT NULL,
numero			INT				NOT NULL	CHECK (numero >=0),
cep				CHAR(8)			NULL
PRIMARY KEY (num_cadastro)
)
GO

CREATE TABLE locacao (
dvdNum				INT				NOT NULL,
clienteNum_cadastro	INT				NOT NULL,
data_locacao		DATE			NOT NULL	DEFAULT ('2021-04-20'),
data_devolucao		DATE			NOT NULL	CHECK (data_devolucao > data_locacao),
valor				DECIMAL(7,2)	NOT NULL	CHECK (valor>=0)
PRIMARY KEY (dvdNum, clienteNum_cadastro, data_locacao)
FOREIGN KEY (dvdNum) REFERENCES dvd(num),
FOREIGN KEY (clienteNum_cadastro) REFERENCES cliente (num_cadastro)
)
GO

ALTER TABLE estrela
ADD nomeReal VARCHAR(50) NULL

EXEC sp_help estrela

ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL

EXEC sp_help filme
EXEC sp_help estrela
EXEC sp_help filme_estrela
EXEC sp_help dvd
EXEC sp_help cliente
EXEC sp_help locacao

INSERT INTO filme (titulo, ano) VALUES
('Whiplash', 2015),
('Birdman', 2015),
('Interestelar', 2014),
('A Culpa é das estrelas', 2014),
('Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
('Sing', 2016)

SELECT * FROM filme

INSERT INTO estrela VALUES 
('Michael Keaton', 'Michael John Douglas')

SELECT * FROM estrela

INSERT INTO estrela VALUES 
('Emma Stone', 'Emily Jean Stone'),
('Miles Teller', NULL),
('Steve Carell', 'Steven John Carell'),
('Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO filme_estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

SELECT * FROM filme_estrela

DBCC CHECKIDENT ('dvd', RESEED, 10000)


INSERT INTO dvd (dt_fabricacao, fimeId) VALUES
('2020-12-02', 1001),
('2019-10-18', 1002),
('2020-04-03', 1003),
('2020-12-02', 1001),
('2019-10-18', 1004),
('2020-04-03', 1002),
('2020-12-02', 1005),
('2019-10-18', 1002),
('2020-04-03', 1003)

SELECT * FROM dvd

DELETE dvd
WHERE num <= 10008

INSERT INTO cliente (nome, logradouro, numero, cep) VALUES
('Matilde Luz', 'Rua Síria', 150, '03086040'),
('Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
('Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
('Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
('Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

SELECT * FROM cliente


INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50)

SELECT * FROM locacao

INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE data_locacao = '2021-02-18' AND clienteNum_cadastro = 5502

UPDATE locacao
SET valor = 3.10
WHERE data_locacao = '2021-02-24' AND clienteNum_cadastro = 5501

UPDATE dvd
SET dt_fabricacao = '2019-07-14'
WHERE num = 10005

UPDATE estrela
SET nomeReal = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

DELETE filme
WHERE titulo = 'Sing'