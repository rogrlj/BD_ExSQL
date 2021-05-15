USE exercicioDDLeDML

EXEC sp_help users
EXEC sp_help projects
EXEC sp_help users_has_projects

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects

--a) Adicionar User
--(6; Joao; Ti_joao; 123mudar; joao@empresa.com)

INSERT INTO users (nome, username, email) VALUES
('João', 'Ti_joao', 'joao@empresa.com')

--b) Adicionar Project
--(10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)

INSERT INTO projects VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-09-12')

--c) Consultar:
--1) Id, Name e Email de Users, Id, Name, Description e Data de Projects, dos usuários que
--participaram do projeto Name Re-folha

--SQL2
SELECT us.id AS Id_User, us.nome AS Nome_User, us.email AS Email_User,
		pj.id AS Id_Project, pj.nome AS Nome_Project, pj.descricao AS Descriçao_Project,
		CONVERT (CHAR(10), pj.dt_project, 103) AS Data_Projeto
FROM users us INNER JOIN users_has_projects up
ON us.id = up.users_id
INNER JOIN projects pj
ON pj.id = up.projects_id
WHERE pj.nome = 'Re-folha'


--SQL3
SELECT us.id AS Id_User, us.nome AS Nome_User, us.email AS Email_User,
		pj.id AS Id_Project, pj.nome AS Nome_Project, pj.descricao AS Descriçao_Project,
		CONVERT (CHAR(10), pj.dt_project, 103) AS Data_Projeto 
FROM users us, projects pj, users_has_projects up
WHERE us.id = up.users_id 
		AND pj.id = up.projects_id
		AND pj.nome = 'Re-folha'


--2) Name dos Projects que não tem Users

SELECT pj.nome 
FROM projects pj LEFT OUTER JOIN users_has_projects up
ON pj.id = up.projects_id
WHERE up.projects_id IS NULL

--3) Name dos Users que não tem Projects

SELECT us.nome
FROM users us LEFT OUTER JOIN users_has_projects up
ON us.id = up.users_id
WHERE up.users_id IS NULL