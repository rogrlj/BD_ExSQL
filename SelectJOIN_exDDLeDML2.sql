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


--1) Consultar num_cadastro do cliente, nome do cliente, 
--data_locacao (Formato dd/mm/aaaa), Qtd_dias_alugado (total de 
--dias que o filme ficou alugado), titulo do filme, ano do filme 
--da locação do cliente cujo nome inicia com Matilde

--SQL2
SELECT cli.num_cadastro AS Num_Cadstro_Cliente,
		cli.nome AS Nome_Cliente,
		CONVERT(CHAR(10), loc.data_locacao, 103) AS Data_locacao,
		DATEDIFF(DAY,  loc.data_locacao, loc.data_devolucao) AS Qtd_dias_alugado,
		film.titulo AS Titulo_Filme, film.ano AS Ano_Filme
FROM cliente cli INNER JOIN locacao loc
ON cli.num_cadastro = loc.clienteNum_cadastro
INNER JOIN dvd dvd
ON dvd.num = loc.dvdNum
INNER JOIN filme film
ON film.id = dvd.fimeId
WHERE cli.nome LIKE 'Matilde%'

--SQL3
SELECT cli.num_cadastro AS Num_Cadstro_Cliente,
		cli.nome AS Nome_Cliente,
		CONVERT(CHAR(10), loc.data_locacao, 103) AS Data_locacao,
		DATEDIFF(DAY,  loc.data_locacao, loc.data_devolucao) AS Qtd_dias_alugado,
		film.titulo AS Titulo_Filme, film.ano AS Ano_Filme
FROM cliente cli, locacao loc, dvd dvd, filme film
WHERE cli.num_cadastro = loc.clienteNum_cadastro
		AND dvd.num = loc.dvdNum
		AND film.id = dvd.fimeId
		AND cli.nome LIKE 'Matilde%'

--2) Consultar nome da estrela, nome_real da estrela, 
--título do filme dos filmes cadastrados do ano de 2015

--SQL2
SELECT est.nome AS Nome_Estrela, est.nomeReal AS Nome_Real_Estrela,
		film.titulo AS Titulo_Filme
FROM estrela est INNER JOIN filme_estrela fe
ON est.id = fe.estrelaId
INNER JOIN filme film
ON film.id = fe.filmeId
WHERE film.ano = 2015

--SQL3
SELECT est.nome AS Nome_Estrela, est.nomeReal AS Nome_Real_Estrela,
		film.titulo AS Titulo_Filme
FROM estrela est, filme_estrela fe, filme film
WHERE est.id = fe.estrelaId
		AND film.id = fe.filmeId
		AND film.ano = 2015

--3) Consultar título do filme, data_fabricação do dvd 
--(formato dd/mm/aaaa), caso a diferença do ano do filme 
--com o ano atual seja maior que 6, deve aparecer a diferença
--do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos),
--caso contrário só a diferença (Exemplo: 4).

--SQL2
SELECT film.titulo AS Titulo_Filme,
		CONVERT(CHAR(10), dvd.dt_fabricacao, 103) AS Data_Fabricação_DVD,
		CASE
			WHEN (DATENAME(YEAR,GETDATE())- film.ano) > 6 THEN
				CAST(DATENAME(YEAR,GETDATE())- film.ano AS VARCHAR(03))  + ' anos' 
			ELSE
				CAST(DATENAME(YEAR,GETDATE())- film.ano AS VARCHAR(03))
			END AS Dif_Ano_Filme_Hoje
FROM filme film INNER JOIN dvd dvd
ON film.id = dvd.fimeId

--SQL3
SELECT film.titulo AS Titulo_Filme,
		CONVERT(CHAR(10), dvd.dt_fabricacao, 103) AS Data_Fabricação_DVD,
		CASE
			WHEN (DATENAME(YEAR,GETDATE())- film.ano) > 6 THEN
				CAST(DATENAME(YEAR,GETDATE())- film.ano AS VARCHAR(03))  + ' anos' 
			ELSE
				CAST(DATENAME(YEAR,GETDATE())- film.ano AS VARCHAR(03))
			END AS Dif_Ano_Filme_Hoje
FROM filme film, dvd dvd
WHERE film.id = dvd.fimeId
