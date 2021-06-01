CREATE DATABASE exaula2
GO
USE exaula2
GO

CREATE TABLE fornecedor (
ID				INT				NOT NULL	PRIMARY KEY,
nome			VARCHAR(50)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
numero			INT				NOT NULL,
complemento		VARCHAR(30)		NOT NULL,
cidade			VARCHAR(70)		NOT NULL
)
GO

CREATE TABLE cliente (
cpf			CHAR(11)		NOT NULL		PRIMARY KEY,
nome		VARCHAR(50)		NOT NULL,	
telefone	VARCHAR(9)		NOT NULL,
)
GO

CREATE TABLE produto (
codigo		INT				NOT NULL	PRIMARY KEY,
descricao	VARCHAR(50)		NOT NULL,
fornecedor	INT				NOT NULL,
preco		DECIMAL(7,2)	NOT NULL
FOREIGN KEY (fornecedor) REFERENCES fornecedor(ID)
)
GO

CREATE TABLE venda (
codigo			INT				NOT NULL,
produto			INT				NOT NULL,
cliente			CHAR(11)		NOT NULL,
quantidade		INT				NOT NULL,
data			DATE			NOT NULL
PRIMARY KEY (codigo, produto, cliente, data)
FOREIGN KEY (produto) REFERENCES produto (codigo),
FOREIGN KEY (cliente) REFERENCES cliente (cpf)
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


--Quantos produtos não foram vendidos (nome da coluna qtd_prd_nao_vend) ?	

SELECT COUNT(p.codigo) AS qtd_prd_nao_vend
FROM produto p LEFT OUTER JOIN venda v
ON p.codigo = v.produto
WHERE v.produto IS NULL


--Descrição do produto, Nome do fornecedor, count() do produto nas vendas	

--SQL2
SELECT p.descricao AS Descricao_Produto,
		f.nome AS Nome_Fornecedor,
		COUNT (v.produto) AS Count_Produto
		--COUNT (v.produto) * v.quantidade AS Qtde_Vendida
FROM venda v INNER JOIN produto p
ON p.codigo = v.produto
INNER JOIN fornecedor f
ON f.ID = p.fornecedor
GROUP BY p.descricao, f.nome

--SQL3
SELECT p.descricao AS Descricao_Produto,
		f.nome AS Nome_Fornecedor,
		COUNT (v.produto) AS Count_Produto
		--COUNT (v.produto) * v.quantidade AS Qtde_Vendida
FROM venda v, produto p, fornecedor f
WHERE p.codigo = v.produto
		AND f.ID = p.fornecedor
GROUP BY p.descricao, f.nome, v.quantidade

--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade	

--SQL2
SELECT c.nome AS Nome_Cliente,
		COUNT(v.produto) * v.quantidade AS Qtde_Comprada
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cliente
GROUP BY c.nome, v.quantidade 
ORDER BY Qtde_Comprada

--SQL3
SELECT c.nome AS Nome_Cliente,
		COUNT(v.produto) * v.quantidade AS Qtde_Comprada
FROM cliente c, venda v
WHERE c.cpf = v.cliente
GROUP BY c.nome, v.quantidade 
ORDER BY Qtde_Comprada

--Descrição do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos

--SQL2
SELECT p.descricao AS Descricao_Produto,
		v.quantidade AS Quantidade_Vendas
FROM produto p INNER JOIN venda v
ON p.codigo = v.produto
WHERE p.preco IN 
(
	SELECT MIN(preco)
	FROM produto
)
GROUP BY p.descricao, v.quantidade

--SQL3
SELECT p.descricao AS Descricao_Produto,
		v.quantidade AS Quantidade_Vendas
FROM produto p, venda v
WHERE p.codigo = v.produto
	AND p.preco IN 
(
	SELECT MIN(preco)
	FROM produto
)
GROUP BY p.descricao, v.quantidade


--Nome do Fornecedor e Quantos produtos cada um fornece	

--SQL2
SELECT f.nome AS Nome_Fornecedor,
		COUNT(p.fornecedor) as Qtde_Produtos_Fornecidos
FROM fornecedor f INNER JOIN produto p
ON f.ID = p.fornecedor
GROUP BY f.nome

--SQL3
SELECT f.nome AS Nome_Fornecedor,
		COUNT(p.fornecedor) as Qtde_Produtos_Fornecidos
FROM fornecedor f, produto p
WHERE f.ID = p.fornecedor
GROUP BY f.nome

--Considerando que hoje é 20/10/2019, consultar, sem repetições, 
--o código da compra, nome do cliente, telefone do cliente 
--(Mascarado XXXX-XXXX ou XXXXX-XXXX) e quantos dias da data da compra	

--SQL2
SELECT DISTINCT V.codigo AS Codigo_Compra,
		c.nome AS Nome_Cliente,
		CASE	
			WHEN LEN(c.telefone) = 8 THEN
				SUBSTRING(c.telefone, 1, 4) + '-' +SUBSTRING(c.telefone, 5, 4)
			ELSE
				SUBSTRING(c.telefone, 1, 5) + '-' +SUBSTRING(c.telefone, 6, 4)
			END AS Telefone_Cliente,
			DATEDIFF(DAY, v.data, '2019-10-20') AS Qtde_Dias_Compra
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cliente

--SQL3

SELECT DISTINCT V.codigo AS Codigo_Compra,
		c.nome AS Nome_Cliente,
		CASE	
			WHEN LEN(c.telefone) = 8 THEN
				SUBSTRING(c.telefone, 1, 4) + '-' +SUBSTRING(c.telefone, 5, 4)
			ELSE
				SUBSTRING(c.telefone, 1, 5) + '-' +SUBSTRING(c.telefone, 6, 4)
			END AS Telefone_Cliente,
			DATEDIFF(DAY, v.data, '2019-10-20') AS Qtde_Dias_Compra
FROM cliente c, venda v
WHERE c.cpf = v.cliente

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade 
--comprada dos clientes que compraram mais de 2 produtos	

--SQL2
SELECT SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' +
		SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS CPF_Cliente,
		c.nome AS Nome_Cliente,
		COUNT(v.produto) * v.quantidade AS Qtde_Comprada
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cliente
GROUP BY c.cpf, c.nome, v.quantidade
HAVING COUNT(v.produto) > 2

--SQL3
SELECT SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' +
		SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS CPF_Cliente,
		c.nome AS Nome_Cliente,
		COUNT(v.produto) * v.quantidade AS Qtde_Comprada
FROM cliente c, venda v
WHERE c.cpf = v.cliente
GROUP BY c.cpf, c.nome, v.quantidade
HAVING COUNT(v.produto) > 2

--Sem repetições, Código da venda, CPF do cliente, mascarado (XXX.XXX.XXX-XX), 
--Nome do Cliente e Soma do valor_total gasto(valor_total_gasto = preco do produto * quantidade de venda).Ordenar por nome do cliente	

--SQL2
SELECT DISTINCT v.codigo AS Codigo_Venda,
		SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' +
		SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS CPF_Cliente,
		c.nome AS Nome_Cliente,
		SUM(p.preco * v.quantidade) AS Valor_Total
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cliente
INNER JOIN produto p
ON p.codigo = v.produto
GROUP BY v.codigo, c.cpf, c.nome
ORDER BY c.nome

--SQL3
SELECT DISTINCT v.codigo AS Codigo_Venda,
		SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' +
		SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS CPF_Cliente,
		c.nome AS Nome_Cliente,
		SUM(p.preco * v.quantidade) AS Valor_Total
FROM cliente c, venda v, produto p
WHERE c.cpf = v.cliente
	AND p.codigo = v.produto
GROUP BY v.codigo, c.cpf, c.nome
ORDER BY c.nome

--Código da venda, data da venda em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva o dia da semana por extenso	
	--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever segunda-feira, assim por diante, até caso dia 7, escrever sábado

SELECT DISTINCT codigo AS Codigo_Venda,
		CONVERT(CHAR(10), data, 103) AS Data_Venda,
		Dia_Semana = CASE DATEPART(WEEKDAY, data)
		WHEN 1 THEN
			'Domingo'
		WHEN 2 THEN
			'Segunda-feira'
		WHEN 3 THEN
			'Terça-feira'
		WHEN 4 THEN
			'Quarta-feira'
		WHEN 5 THEN
			'Quinta-feira'
		WHEN 6 THEN
			'Sexta-feira'
		WHEN 7 THEN
			'Sábado'
		END
FROM venda