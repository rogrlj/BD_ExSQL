USE exercicioDDLeDML

EXEC sp_help users
EXEC sp_help projects
EXEC sp_help users_has_projects

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects

--Quantos projetos não tem usuários associados a ele.
--A coluna deve chamar qty_projects_no_users

SELECT COUNT(pj.id) AS qty_projects_no_users
FROM projects pj LEFT OUTER JOIN users_has_projects up
ON pj.id = up.projects_id
WHERE up.projects_id IS NULL

--Id do projeto, nome do projeto, qty_users_project 
--(quantidade de usuários por projeto) em ordem alfabética
--crescente pelo nome do projeto

--SQL2
SELECT pj.id AS Id_Projeto, 
		pj.nome  AS Nome_Projeto,
		COUNT(up.users_id) AS qty_users_project
FROM projects pj INNER JOIN users_has_projects up
ON pj.id = up.projects_id
GROUP BY pj.id, pj.nome
ORDER BY pj.nome

--SQL3
SELECT pj.id AS Id_Projeto, 
		pj.nome  AS Nome_Projeto,
		COUNT(up.users_id) AS qty_users_project
FROM projects pj, users_has_projects up
WHERE pj.id = up.projects_id
GROUP BY pj.id, pj.nome
ORDER BY pj.nome