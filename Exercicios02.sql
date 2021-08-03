/*
	Exercicios02
*/

CREATE DATABASE exercicios02
GO
USE exercicios02

CREATE TABLE carro (
placa	CHAR(07)	NOT NULL,
marca	VARCHAR(50)	NOT NULL,
modelo	VARCHAR(80)	NOT NULL,
cor		VARCHAR(50)	NOT NULL,
ano		INT			NOT NULL
PRIMARY KEY (placa)
)
GO

CREATE TABLE pecas(
codigo	INT				NOT NULL,
nome	VARCHAR(80)		NOT NULL,
valor	DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE cliente (
nome		VARCHAR(80)		NOT NULL,
logradouro	VARCHAR(200)	NOT NULL,
numero		INT				NOT NULL,
bairro		VARCHAR(80)		NOT NULL,
telefone	CHAR(08)		NOT NULL,
carro		CHAR(07)		NOT NULL
PRIMARY KEY (carro)
FOREIGN KEY	(carro) REFERENCES carro (placa)
)
GO

CREATE TABLE servico(
carro		CHAR(07)		NOT NULL,
peca		INT				NOT NULL,
quantidade	INT				NOT NULL,
valor		DECIMAL(7,2)	NOT NULL,
data		DATE			NOT NULL
PRIMARY KEY (carro, peca, data)
FOREIGN KEY (carro) REFERENCES carro (placa),
FOREIGN KEY (peca) REFERENCES pecas (codigo)
)
GO

EXEC sp_help carro
EXEC sp_help pecas
EXEC sp_help cliente
EXEC sp_help servico

SELECT * FROM carro
SELECT * FROM pecas
SELECT * FROM cliente
SELECT * FROM servico

--1-Consultar em Subqueries
--	a-Telefone do dono do carro Ka, Azul

SELECT SUBSTRING( telefone, 1, 4) + '-' + SUBSTRING( telefone, 5, 4) AS Telefone
FROM cliente
WHERE carro IN
(
	SELECT placa
	FROM carro
	WHERE modelo = 'Ka' AND cor = 'Azul'
)

--	b-Endereço concatenado do cliente que fez o serviço do dia 02/08/2020
SELECT logradouro + ', ' + CAST(numero AS CHAR(07)) AS Endereço
FROM cliente
WHERE carro IN
(
	SELECT placa
	FROM carro
	WHERE placa IN
	(
		SELECT carro
		FROM servico
		WHERE data = '2020-08-02'
	)
)


--2-Consultar:
--	a-Placas dos carros de anos anteriores a 2001

SELECT placa
FROM carro
WHERE ano < 2001

--	b-Marca, modelo e cor, concatenado dos carros posteriores a 2005

SELECT marca + ' ' + modelo + ' ' + cor AS Carro
FROM carro
WHERE ano > 2001

--	c-Código e nome das peças que custam menos de R$80,00

SELECT codigo, nome
FROM pecas
WHERE valor < 80.0