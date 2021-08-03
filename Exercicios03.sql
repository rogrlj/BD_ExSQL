/*
	Exercicios03
*/

CREATE DATABASE exercicios03
GO
USE exercicios03

CREATE TABLE pacientes(
cpf			CHAR(11)		NOT NULL,
nome		VARCHAR(80)		NOT NULL,
rua			VARCHAR(200)	NOT NULL,
numero		INT				NOT NULL,
bairro		VARCHAR(80)		NOT NULL,
telefone	CHAR(08)		NULL
PRIMARY KEY (cpf)
)
GO

CREATE TABLE medico(
codigo			INT				NOT NULL,
nome			VARCHAR(80)		NOT NULL,
especialidade	VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE prontuario(
data			DATE			NOT NULL,
cpf_paciente	CHAR(11)		NOT NULL,
codigo_medico	INT				NOT NULL,
diagnostico		VARCHAR(200)	NOT NULL,
medicamento		VARCHAR(200)	NOT NULL
PRIMARY KEY (data, cpf_paciente, codigo_medico)
FOREIGN KEY (cpf_paciente) REFERENCES pacientes (cpf),
FOREIGN KEY (codigo_medico) REFERENCES medico (codigo)
)
GO

EXEC sp_help pacientes
EXEC sp_help medico
EXEC sp_help prontuario

SELECT * FROM pacientes
SELECT * FROM medico
SELECT * FROM prontuario

--1-Consultar:
--	a-Nome e Endereço (concatenado) dos pacientes com mais de 50 anos

--IMPOSSIVEL REALIZAR, A IDADE E NEM A DATA DE NASCIMENTO DOS PACIENTES FORAM FORNECIDOS

--	b-Qual a especialidade de Carolina Oliveira

SELECT especialidade
FROM medico
WHERE nome = 'Carolina Oliveira'

--	c-Qual medicamento receitado para reumatismo

SELECT medicamento 
FROM prontuario
WHERE diagnostico = 'Reumatismo'


--2-Consultar em subqueries:
--	a-Diagnóstico e Medicamento do paciente José Rubens em suas consultas

SELECT diagnostico, medicamento
FROM prontuario
WHERE cpf_paciente IN
(
	SELECT cpf
	FROM pacientes
	WHERE nome = 'José Rubens'
)

--	b-Nome e especialidade do(s) Médico(s) que atenderam José Rubens. Caso a 
--	  especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras 
--	  concatenada com um ponto final (.)

SELECT nome AS Nome_Medico,
		CASE
			WHEN LEN(especialidade) > 3 THEN
				SUBSTRING(especialidade, 1 , 3) + '.'
			ELSE
				especialidade
			END AS Especialidade
FROM medico
WHERE codigo IN
(
	SELECT codigo_medico
	FROM prontuario
	WHERE cpf_paciente IN
	(
		SELECT cpf
		FROM pacientes
		WHERE nome = 'José Rubens'
	)
)

--	c-CPF (Com a máscara XXX.XXX.XXX-XX), Nome, Endereço completo
--	  (Rua, nº - Bairro), Telefone (Caso nulo, mostrar um traço (-)) 
--	  dos pacientes do médico Vinicius

SELECT SUBSTRING(cpf, 1, 3) + '.' + SUBSTRING(cpf, 4, 3) + '.' +
		SUBSTRING(cpf, 7, 3) + '-' + SUBSTRING(cpf, 10, 2) AS CPF,
		nome AS Nome_Paciente,
		rua + ', ' + CAST(numero AS CHAR(05)) + ' - ' + bairro AS Endereço,
		CASE
			WHEN telefone IS NULL THEN
				'-'
			ELSE
				SUBSTRING( telefone, 1, 4) + '-' + SUBSTRING( telefone, 5, 4)
			END AS Telefone
FROM pacientes
WHERE cpf IN
(
	SELECT cpf_paciente
	FROM prontuario
	WHERE codigo_medico IN
	(
		SELECT codigo
		FROM medico
		WHERE nome LIKE '%Vinicius%'
	)
)

--	d-Quantos dias fazem da consulta de Maria Rita até hoje

SELECT DATEDIFF(DAY, data, GETDATE()) AS Dias_da_Consulta
FROM prontuario
WHERE cpf_paciente in
(
	SELECT cpf
	FROM pacientes
	WHERE nome = 'Maria Rita'
)


--3-Alterar o telefone da paciente Maria Rita, para 98345621

UPDATE pacientes
SET telefone = '98345621'
WHERE nome = 'Maria Rita'

--4-Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto

UPDATE pacientes
SET rua = 'Voluntários da Pátria'
WHERE nome = 'Joana de Souza'

UPDATE pacientes
SET numero = 1980
WHERE nome = 'Joana de Souza'

UPDATE pacientes
SET bairro = 'Jd. Aeroporto'
WHERE nome = 'Joana de Souza'