/*
Exercícios DDL e DML – Banco de Dados
*/

CREATE DATABASE exercicioDDLeDML
GO
USE exercicioDDLeDML

CREATE TABLE users (
id			INT				NOT NULL	IDENTITY(1,1),
nome		VARCHAR(45)		NOT NULL,
username	VARCHAR(45)		NOT NULL	UNIQUE,
senha		VARCHAR(45)		NOT NULL	DEFAULT('123mudar'),
email		VARCHAR(45)		NOT NULL
PRIMARY KEY (id)
)
GO

CREATE TABLE projects (
id			INT				NOT NULL	IDENTITY(1001,1),
nome		VARCHAR(45)		NOT NULL,
descricao	VARCHAR(45)		NOT NULL,
dt_project	DATE			NOT NULL	CHECK(dt_project > '2014-09-01')
PRIMARY KEY (id)
)
GO

CREATE TABLE users_has_projects (
users_id	INT		NOT NULL,
projects_id INT		NOT NULL
PRIMARY KEY (users_id, projects_id)
FOREIGN KEY (users_id) REFERENCES users(id),
FOREIGN KEY (projects_id) REFERENCES projects(id)
)
GO

EXEC sp_help users
EXEC sp_help projects
EXEC sp_help users_has_projects

ALTER TABLE users
DROP CONSTRAINT UQ__users__F3DBC57276E6AF00

ALTER TABLE users
ALTER COLUMN username VARCHAR(10) NOT NULL

ALTER TABLE users
ADD CONSTRAINT UQ_username UNIQUE (username)

ALTER TABLE users
ALTER COLUMN senha VARCHAR(8) NOT NULL

INSERT INTO users (nome, username, senha, email) VALUES
('Maria', 'Rh_maria', '' , 'maria@empresa.com')

SELECT * FROM users

UPDATE users
SET senha = '123mudar'
WHERE id = 1

INSERT INTO users (nome, username, email) VALUES
('Paulo', 'Ti_paulo', 'paulo@empresa.com'),
('Ana', 'Rh_ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', 'aparecido@empresa.com')

UPDATE users
SET senha = '123@456'
WHERE id = 2

UPDATE users
SET senha = '55@!cido'
WHERE id = 5

ALTER TABLE projects
ALTER COLUMN descricao VARCHAR(45) NULL

INSERT INTO projects (nome, descricao, dt_project) VALUES
('Re-folha', 'Refatoração das Folhas', '2014-09-05'),
('Manutenção PCs', 'Manutenção PCs', '2014-09-06'),
('Auditoria', NULL, '2014-09-07')

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects

DELETE projects
WHERE id <= 1006

DBCC CHECKIDENT ('projects', RESEED, 1000)

INSERT INTO users_has_projects (users_id, projects_id) VALUES
(1, 1001),
(5, 1001),
(3, 1003),
(4, 1002),
(2, 1002)

UPDATE projects
SET dt_project = '2014-09-12'
WHERE nome = 'Manutenção PCs'

UPDATE users
SET username = 'Rh_cido'
WHERE nome = 'Aparecido'

UPDATE users
SET senha = '888@*'
WHERE username = 'Rh_maria' AND senha = '123mudar'

DELETE users_has_projects
WHERE users_id = 2