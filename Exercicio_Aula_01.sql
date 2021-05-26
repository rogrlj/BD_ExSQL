/*
	Exercicio_Aula_01
*/

CREATE DATABASE exAula_01
GO
USE exAula_01

CREATE TABLE clientes (
cod			INT				NOT NULL,
nome		VARCHAR(80)		NOT NULL,
logradouro	VARCHAR(100)	NULL,
numero		INT				NULL		CHECK (numero >=0),
telefone	CHAR(9)			NULL		CHECK(LEN(telefone) = 9)
PRIMARY KEY (cod)
)
GO

CREATE TABLE autores (
cod			INT				NOT NULL,
nome		VARCHAR(70)		NOT NULL,
pais		VARCHAR(15)		NOT NULL,
biografia	VARCHAR(200)	NOT NULL
PRIMARY KEY (cod)
)
GO

CREATE TABLE corredor (
cod		INT			NOT NULL,
tipo	VARCHAR(50)	NOT NULL
PRIMARY KEY (cod)
)
GO

CREATE TABLE livros(
cod				INT			NOT NULL,
cod_autor		INT			NOT NULL,
cod_corredor	INT			NOT NULL,
nome			VARCHAR(50)	NOT NULL,
pag				INT			NOT NULL,
idioma			VARCHAR(30)	NOT NULL
PRIMARY KEY (cod)
FOREIGN KEY (cod_autor) REFERENCES autores (cod),
FOREIGN KEY (cod_corredor) REFERENCES corredor (cod)
)
GO

CREATE TABLE emprestimo (
cod_cli		INT			NOT NULL,
data		DATETIME	NOT NULL,
cod_livro	INT			NOT NULL
PRIMARY KEY (cod_cli, data, cod_livro)
FOREIGN KEY (cod_cli) REFERENCES clientes (cod),
FOREIGN KEY (cod_livro) REFERENCES livros (cod)
)
GO

EXEC sp_help clientes
EXEC sp_help autores
EXEC sp_help corredor
EXEC sp_help livros
EXEC sp_help emprestimo

SELECT * FROM autores
SELECT * FROM clientes
SELECT * FROM corredor
SELECT * FROM livros
SELECT * FROM emprestimo

--1) Fazer uma consulta que retorne o nome do cliente 
--e a data do empréstimo formatada padrão BR (dd/mm/yyyy)

--SQL2
SELECT DISTINCT c.nome AS Nome_Cliente,
		CONVERT(CHAR(10), e.data, 103) AS Data_Emprestimo
FROM clientes c INNER JOIN emprestimo e
ON c.cod = e.cod_cli

--SQL3
SELECT c.nome AS Nome_Cliente,
		CONVERT(CHAR(10), e.data, 103) AS Data_Emprestimo
FROM clientes c, emprestimo e
WHERE c.cod = e.cod_cli


--2) Fazer uma consulta que retorne Nome do autor e Quantos livros 
--foram escritos por Cada autor, ordenado pelo número de livros. 
--Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.

--SQL2
SELECT CASE 
			WHEN LEN(a.nome) > 25 THEN
				SUBSTRING(a.nome, 1, 13)
			ELSE
				a.nome
			END AS Nome_Autor,
			COUNT(l.cod_autor) AS Qtde_Livros_Escritos
FROM autores a INNER JOIN livros l
ON a.cod = l.cod_autor
GROUP BY a.nome
ORDER BY Qtde_Livros_Escritos DESC

--SQL3
SELECT CASE 
			WHEN LEN(a.nome) > 25 THEN
				SUBSTRING(a.nome, 1, 13)
			ELSE
				a.nome
			END AS Nome_Autor,
			COUNT(l.cod_autor) AS Qtde_Livros_Escritos
FROM autores a, livros l
WHERE a.cod = l.cod_autor
GROUP BY a.nome
ORDER BY Qtde_Livros_Escritos DESC

--3) Fazer uma consulta que retorne o nome do autor e o país 
--de origem do livro com maior número de páginas cadastrados no sistema

--SQL2
SELECT a.nome AS Nome_Autor,
		a.pais AS Pais_Origem
FROM autores a INNER JOIN livros l
ON a.cod = l.cod_autor
WHERE l.pag IN
(
	SELECT MAX(pag) 
	FROM livros
)
GROUP BY a.nome, a.pais

--SQL3
SELECT a.nome AS Nome_Autor,
		a.pais AS Pais_Origem
FROM autores a, livros l
WHERE a.cod = l.cod_autor
	AND l.pag IN
(
	SELECT MAX(pag) 
	FROM livros
)
GROUP BY a.nome, a.pais

--4) Fazer uma consulta que retorne nome e endereço 
--concatenado dos clientes que tem livros emprestados

--SQL2
SELECT DISTINCT c.nome AS Nome_Cliente,
		c.logradouro + ', ' + CAST(c.numero AS VARCHAR(05)) AS Endereco
FROM clientes c INNER JOIN emprestimo e
ON c.cod = e.cod_cli

--SQL3
SELECT DISTINCT c.nome AS Nome_Cliente,
		c.logradouro + ', ' + CAST(c.numero AS VARCHAR(05)) AS Endereco
FROM clientes c, emprestimo e
WHERE c.cod = e.cod_cli

/*
5) Nome dos Clientes, sem repetir e, concatenados como
enderço_telefone, o logradouro, o numero e o telefone) dos
clientes que Não pegaram livros. Se o logradouro e o 
número forem nulos e o telefone não for nulo, mostrar só o telefone. Se o telefone 
for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. 
Se os três existirem, mostrar os três.
O telefone deve estar mascarado XXXXX-XXXX
*/

SELECT DISTINCT c.nome AS Nome_Cliente,
		CASE 
			WHEN (c.logradouro IS NULL AND c.numero IS NULL  
					AND c.telefone IS NOT NULL) THEN
				SUBSTRING (c.telefone, 1, 5) + '-' + SUBSTRING (c.telefone, 6, 9)
			ELSE	
				CASE WHEN (c.telefone IS NULL AND c.logradouro IS NOT NULL
						AND c.numero IS NOT NULL) THEN
						c.logradouro + ', ' + CAST(c.numero AS VARCHAR(05))
					ELSE
						c.logradouro + ', ' + CAST(c.numero AS VARCHAR(05)) + ' - ' + 
						SUBSTRING (c.telefone, 1, 5) + '-' + SUBSTRING (c.telefone, 6, 9)
				END
			END AS Endereco_Telefone
FROM clientes c LEFT OUTER JOIN emprestimo e
ON c.cod = e.cod_cli
WHERE e.cod_cli IS NULL

--6) Fazer uma consulta que retorne Quantos livros não foram emprestados

SELECT COUNT (l.cod) AS Qtde_Livros_Nao_Emprestado
FROM livros l LEFT OUTER JOIN emprestimo e 
ON l.cod = e.cod_livro
WHERE e.cod_livro IS NULL

--7) Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e
--quantos livros, ordenados por quantidade de livro

--SQL2
SELECT a.nome AS Nome_Autor,
		c.tipo AS Tipo_Corredor,
		COUNT(l.cod_autor) AS Qtde_Livros
FROM autores a INNER JOIN livros l
ON a.cod = l.cod_autor
INNER JOIN corredor c
ON c.cod = l.cod_corredor
GROUP BY a.nome, c.tipo
ORDER BY Qtde_Livros

--SQL3
SELECT a.nome AS Nome_Autor,
		c.tipo AS Tipo_Corredor,
		COUNT(l.cod_autor) AS Qtde_Livros
FROM autores a, livros l, corredor c
WHERE a.cod = l.cod_autor
		AND c.cod = l.cod_corredor
GROUP BY a.nome, c.tipo
ORDER BY Qtde_Livros

--8) Considere que hoje é dia 18/05/2012, faça uma consulta que 
--apresente o nome do cliente, o nome do livro, o total de dias 
--que cada um está com o livro e, uma coluna que apresente, caso o 
--número de dias seja superior a 4, apresente 'Atrasado', caso contrário,
--apresente 'No Prazo'

--SQL2
SELECT c.nome AS Nome_Cliente,
		l.nome AS Nome_Livro,
		DATEDIFF(DAY, e.data, '2012-05-18') AS Dias_Alugado,
		CASE
			WHEN (DATEDIFF(DAY, e.data, '2012-05-18')) > 4 THEN
				'Atrasado'
			ELSE
				'No Prazo'
			END AS Situação
FROM clientes c INNER JOIN emprestimo e
ON c.cod = e.cod_cli
INNER JOIN livros l
ON l.cod = e.cod_livro

--SQL3
SELECT c.nome AS Nome_Cliente,
		l.nome AS Nome_Livro,
		DATEDIFF(DAY, e.data, '2012-05-18') AS Dias_Alugado,
		CASE
			WHEN (DATEDIFF(DAY, e.data, '2012-05-18')) > 4 THEN
				'Atrasado'
			ELSE
				'No Prazo'
			END AS Situação
FROM clientes c, emprestimo e, livros l
WHERE c.cod = e.cod_cli
	AND l.cod = e.cod_livro

--9) Fazer uma consulta que retorne cod de corredores, 
--tipo de corredores e quantos livros tem em cada corredor

--SQL2
SELECT c.cod AS Codigo_Corredor,
		c.tipo AS Tipo_Corredor,
		COUNT(l.cod_corredor) AS Qtde_Livros_Corredor
FROM corredor c INNER JOIN livros l
ON c.cod = l.cod_corredor
GROUP BY c.cod, c.tipo

--SQL3
SELECT c.cod AS Codigo_Corredor,
		c.tipo AS Tipo_Corredor,
		COUNT(l.cod_corredor) AS Qtde_Livros_Corredor
FROM corredor c, livros l
WHERE c.cod = l.cod_corredor
GROUP BY c.cod, c.tipo

--10) Fazer uma consulta que retorne o Nome dos autores 
--cuja quantidade de livros cadastrado é maior ou igual a 2.

--SQL2
SELECT a.nome
FROM autores a INNER JOIN livros l
ON a.cod = l.cod_autor
GROUP BY a.nome
HAVING COUNT(l.cod_autor) >= 2

--SQL3
SELECT a.nome
FROM autores a, livros l
WHERE a.cod = l.cod_autor
GROUP BY a.nome
HAVING COUNT(l.cod_autor) >= 2

--11) Considere que hoje é dia 18/05/2012, faça uma consulta que
--apresente o nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais

--SQL2
SELECT c.nome AS Nome_Cliente,
		l.nome AS Nome_Livro
FROM clientes c INNER JOIN emprestimo e
ON c.cod = e.cod_cli
INNER JOIN livros l
ON l.cod = e.cod_livro
WHERE (DATEDIFF(DAY, e.data, '2012-05-18')) >= 7

--SQL3
SELECT c.nome AS Nome_Cliente,
		l.nome AS Nome_Livro
FROM clientes c, emprestimo e,  livros l
WHERE c.cod = e.cod_cli
	AND l.cod = e.cod_livro
	AND (DATEDIFF(DAY, e.data, '2012-05-18')) >= 7