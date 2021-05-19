USE exSQL_Select_Simples

EXEC sp_help filme
EXEC sp_help estrela
EXEC sp_help filme_estrela
EXEC sp_help dvd
EXEC sp_help cliente
EXEC sp_help locacao

SELECT * FROM cliente
SELECT * FROM dvd
SELECT * FROM estrela
SELECT * FROM filme
SELECT * FROM filme_estrela
SELECT * FROM locacao

--Consultar, num_cadastro do cliente, nome do cliente, 
--titulo do filme, data_fabricação do dvd, valor da locação, 
--dos dvds que tem a maior data de fabricação dentre todos os cadastrados.

--SQL2
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente, f.titulo AS Titulo_Filme,
		 d.dt_fabricacao AS Data_Fabricacao_DVD,
		l.valor AS Valor_Locacao
FROM cliente c INNER JOIN locacao l
ON c.num_cadastro = l.clienteNum_cadastro
INNER JOIN dvd d
ON d.num = l.dvdNum
INNER JOIN filme f
ON f.id = d.fimeId
WHERE d.dt_fabricacao IN
(
	SELECT MAX(dt_fabricacao)
	FROM dvd
)

--SQL3
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente, f.titulo AS Titulo_Filme,
		 d.dt_fabricacao AS Data_Fabricacao_DVD,
		l.valor AS Valor_Locacao
FROM cliente c, locacao l, dvd d, filme f
WHERE c.num_cadastro = l.clienteNum_cadastro
	AND d.num = l.dvdNum
	AND f.id = d.fimeId
	AND d.dt_fabricacao IN
(
	SELECT MAX(dt_fabricacao)
	FROM dvd
)


--Consultar, num_cadastro do cliente, nome do cliente, 
--data de locação (Formato DD/MM/AAAA) e a quantidade de DVD´s 
--alugados por cliente (Chamar essa coluna de qtd), por data de locação

--SQL2
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente,
		CONVERT(CHAR(10), l.data_locacao, 103) AS Data_locacao,
		COUNT(l.dvdNum) AS Qtde_DVD_Alugado
FROM cliente c INNER JOIN locacao l
ON c.num_cadastro = l.clienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao
ORDER BY l.data_locacao

--SQL3
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente,
		CONVERT(CHAR(10), l.data_locacao, 103) AS Data_locacao,
		COUNT(l.dvdNum) AS Qtde_DVD_Alugado
FROM cliente c, locacao l
WHERE c.num_cadastro = l.clienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao
ORDER BY l.data_locacao

--Consultar, num_cadastro do cliente, nome do cliente, 
--data de locação (Formato DD/MM/AAAA) e a valor total de todos os
--dvd´s alugados (Chamar essa coluna de valor_total), por data de locação

--SQL2
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente,
		CONVERT(CHAR(10), l.data_locacao, 103) AS Data_locacao,
		SUM(l.valor) as Valor_Total
FROM cliente c INNER JOIN locacao l
ON c.num_cadastro = l.clienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao
ORDER BY l.data_locacao

--SQL3
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente,
		CONVERT(CHAR(10), l.data_locacao, 103) AS Data_locacao,
		SUM(l.valor) as Valor_Total
FROM cliente c, locacao l
WHERE c.num_cadastro = l.clienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao
ORDER BY l.data_locacao

--Consultar num_cadastro do cliente, nome do cliente, 
--Endereço concatenado de logradouro e numero como Endereco, 
--data de locação (Formato DD/MM/AAAA) dos clientes que alugaram mais de 2 filmes simultaneamente

--SQL2
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente,
		c.logradouro + ', ' + CAST(c.numero AS VARCHAR(05)) AS Endereco,
		CONVERT(CHAR(10), l.data_locacao, 103) AS Data_locacao
FROM cliente c INNER JOIN locacao l
ON c.num_cadastro = l.clienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, c.logradouro, c.numero, l.data_locacao
HAVING COUNT(l.dvdNum) > 2

--SQL3
SELECT c.num_cadastro AS Num_Cadastro_Cliente,
		c.nome AS Nome_Cliente,
		c.logradouro + ', ' + CAST(c.numero AS VARCHAR(05)) AS Endereco,
		CONVERT(CHAR(10), l.data_locacao, 103) AS Data_locacao
FROM cliente c, locacao l
WHERE c.num_cadastro = l.clienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, c.logradouro, c.numero, l.data_locacao
HAVING COUNT(l.dvdNum) > 2