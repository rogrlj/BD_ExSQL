/*
	Exercicios01
*/

CREATE DATABASE exercicios01
GO
USE exercicios01

CREATE TABLE aluno (
ra			INT				NOT NULL,
nome		VARCHAR(30)		NOT NULL,
sobrenome	VARCHAR(80)		NOT NULL,
rua			VARCHAR(100)	NOT NULL,
numero		INT				NOT NULL,
bairro		VARCHAR(80)		NOT NULL,
cep			INT				NOT NULL,
telefone	INT				NULL		
PRIMARY KEY (ra)
)
GO

CREATE TABLE cursos (
codigo			INT				NOT NULL,
nome			VARCHAR(80)		NOT NULL,
carga_horaria	INT				NOT NULL,
turno			VARCHAR(20)		NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE disciplina (
codigo			INT			NOT NULL,
nome			VARCHAR(80)	NOT NULL,
carga_horaria	INT			NOT NULL,
turno			VARCHAR(20)	NOT NULL,
semestre		INT			NOT NULL
PRIMARY KEY (codigo)
)
GO

EXEC sp_help aluno
EXEC sp_help cursos
EXEC sp_help disciplina

SELECT * FROM aluno
SELECT * FROM cursos
SELECT * FROM disciplina


--Nome e sobrenome, como nome completo dos Alunos Matriculados

SELECT nome + ' ' + sobrenome AS Nome_Completo
FROM aluno

--Rua, nº , Bairro e CEP como Endereço do aluno que não tem telefone

SELECT rua + ', ' + CAST(numero AS VARCHAR(05)) + ' - CEP: ' + CAST(cep AS VARCHAR(08)) AS Endereço
FROM aluno

--Telefone do aluno com RA 12348
SELECT telefone
FROM aluno
WHERE ra = 12348

--Nome e Turno dos cursos com 2800 horas
SELECT nome, turno
FROM cursos
WHERE carga_horaria = 2800

--O semestre do curso de Banco de Dados I noite
SELECT semestre
FROM disciplina
WHERE nome = 'Banco de Dados I' AND turno = 'noite'
