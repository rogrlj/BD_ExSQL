/*
	Exercicios04
*/

CREATE DATABASE exercicios04
GO
USE exercicios04

CREATE TABLE cliente (
cpf			CHAR(11)		NOT NULL,
nome		VARCHAR(80)		NOT NULL,
telefone	CHAR(08)		NOT NULL
PRIMARY KEY (cpf)
)
GO

CREATE TABLE fornecedor(
id			INT				NOT NULL,
nome		VARCHAR(80)		NOT NULL,
logradouro	VARCHAR(200)	NOT NULL,
numero		INT				NOT NULL,
complemento	VARCHAR(200)	NOT NULL,
cidade		VARCHAR(100)	NOT NULL
PRIMARY KEY (id)
)
GO

CREATE TABLE produto (
codigo		INT				NOT NULL,
descricao	VARCHAR(200)	NOT NULL,
fornecedor	INT				NOT NULL,
preco		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (fornecedor) REFERENCES fornecedor (id)
)
GO

CREATE TABLE venda (
codigo		INT				NOT NULL,
produto		INT				NOT NULL,
cliente		CHAR(11)		NOT NULL,
quantidade	INT				NOT NULL,
valor_total	DECIMAL(7,2)	NOT NULL,
data		DATE			NOT NULL
PRIMARY KEY (codigo, produto, cliente)
FOREIGN KEY (produto) REFERENCES produto (codigo),
FOREIGN KEY	(cliente) REFERENCES cliente (cpf)
)
GO

EXEC sp_help cliente
EXEC sp_help fornecedor
EXEC sp_help produto
EXEC sp_help venda

SELECT * FROM cliente
SELECT * FROM fornecedor
SELECT * FROM produto
SELECT * FROM venda

--Consultar no formato dd/mm/aaaa:
--Data da Venda 4

SELECT CONVERT(CHAR(10), data, 103) AS Data_Venda 
FROM venda
WHERE codigo = 4

--Inserir na tabela Fornecedor, a coluna Telefone	
--e os seguintes dados:	
--	1	7216-5371
--	2	8715-3738
--	4	3654-6289

ALTER TABLE fornecedor
ADD telefone CHAR(08) NULL

UPDATE fornecedor
SET telefone = '72165371'
WHERE id = 1

UPDATE fornecedor
SET telefone = '87153738'
WHERE id = 2

UPDATE fornecedor
SET telefone = '36546289'
WHERE id = 4

SELECT * FROM fornecedor

--Consultar por ordem alfabética de nome, o nome, 
--o enderço concatenado e o telefone dos fornecedores

SELECT nome AS Nome_Fornecedor,
		logradouro + ', ' + CAST(numero AS CHAR(07)) + 
		' - ' + complemento + ' - ' + cidade AS Endereço
FROM fornecedor
ORDER BY nome

--Consultar:
--	1-Produto, quantidade e valor total do comprado por Julio Cesar

--SQL2
SELECT p.descricao AS Produto,
		v.quantidade AS Quantidade,
		v.valor_total AS Valor_Total
FROM venda v INNER JOIN cliente c
ON v.cliente = c.cpf
INNER JOIN produto p
ON p.codigo = v.produto
WHERE c.nome = 'Julio Cesar'

--SQL3
SELECT p.descricao AS Produto,
		v.quantidade AS Quantidade,
		v.valor_total AS Valor_Total
FROM venda v, cliente c, produto p
WHERE v.cliente = c.cpf
	AND p.codigo = v.produto
	AND c.nome = 'Julio Cesar'

--	2-Data, no formato dd/mm/aaaa e valor total do 
--    produto comprado por  Paulo Cesar

--SQL2
SELECT CONVERT(CHAR(10), v.data, 103) AS Data_Venda,
		v.valor_total AS Valor_Total
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cliente
WHERE c.nome = 'Paulo Cesar'

--SQL3
SELECT CONVERT(CHAR(10), v.data, 103) AS Data_Venda,
		v.valor_total AS Valor_Total
FROM cliente c, venda v
WHERE c.cpf = v.cliente
	AND c.nome = 'Paulo Cesar'

--	3-Consultar, em ordem decrescente, o nome e o preço de todos os produtos 

SELECT descricao AS Nome_Produto,
		preco AS Preço
FROM produto
ORDER BY descricao DESC
--ORDER BY preco DESC
