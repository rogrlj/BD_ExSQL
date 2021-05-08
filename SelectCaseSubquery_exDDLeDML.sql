USE exercicioDDLeDML

EXEC sp_help users
EXEC sp_help projects
EXEC sp_help users_has_projects

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects


--Fazer uma consulta que retorne id, nome, email, username e caso a senha 
--seja diferente de 123mudar, mostrar ******** (8 asteriscos), caso contrário, mostrar a própria senha.

SELECT id, nome, email, username, 
		CASE
			WHEN senha = '123mudar' THEN
					senha
			ELSE
				'********'
		END AS senha
FROM users

--Considerando que o projeto 10001 durou 15 dias, fazer uma consulta que mostre
--o nome do projeto, descrição, data, data_final do projeto realizado por usuário de e-mail aparecido@empresa.com

SELECT nome AS nome_do_projeto,
		descricao AS descrição,
		CONVERT(CHAR(10), dt_project, 103) AS data,
		CONVERT(CHAR(10),DATEADD (DAY, 15, dt_project), 103) AS data_final
FROM projects
WHERE id IN 
(
	SELECT projects_id
	FROM users_has_projects
	WHERE users_id IN
	(
		SELECT id
		FROM users
		WHERE email = 'aparecido@empresa.com'
	)
)

--Fazer uma consulta que retorne o nome e o email dos usuários que estão envolvidos no projeto de nome Auditoria

SELECT nome, email
FROM users
WHERE id IN
(
	SELECT users_id
	FROM users_has_projects
	WHERE projects_id IN
	(
		SELECT id 
		FROM projects
		WHERE nome = 'Auditoria'
	)
)

--Considerando que o custo diário do projeto,  cujo nome tem o termo Manutenção,
--é de 79.85 e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final e custo_total do projeto

SELECT nome AS nome_do_projeto,
		descricao AS descrição,
		CONVERT(CHAR(10), dt_project, 103) AS data,
		CONVERT(CHAR(10), '2014-09-16', 103) AS data_final,
		CAST(DATEDIFF(DAY, dt_project, '2014-09-16') AS DECIMAL(7,2)) * 79.85 AS custo_total
FROM projects
WHERE nome LIKE '%Manutenção%'


