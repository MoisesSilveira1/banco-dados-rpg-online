-- =====================================================================
-- Avaliacao 2 - Criar as tabelas do projeto de jogo de RPG online (DDL)
-- Banco de Dados - SENAI | Aluno: Moises Silveira
-- SGBD: SQL Server
-- Referencia: diagrama_jogo_RPG (USUARIOS, PERSONAGENS, CLASSES,
--             HABILIDADES e CLASSES_HABILIDADES)
-- =====================================================================

-- 1) Criar o banco de dados do projeto e seleciona-lo
CREATE DATABASE RPGOnline;
GO

USE RPGOnline;
GO

-- 2) Criar as tabelas, das menos dependentes (sem chave estrangeira)
--    para as mais dependentes.

-- USUARIOS: 1 usuario possui N personagens
CREATE TABLE Usuarios
(
     UsuarioId INT PRIMARY KEY IDENTITY
    ,Email     VARCHAR(120) NOT NULL UNIQUE
    ,Senha     VARCHAR(255) NOT NULL
);
GO

-- CLASSES: 1 classe possui N personagens e N habilidades
CREATE TABLE Classes
(
     ClasseId  INT PRIMARY KEY IDENTITY
    ,Nome      VARCHAR(50) NOT NULL UNIQUE
    ,Descricao VARCHAR(255)
);
GO

-- HABILIDADES: associada a N classes (via CLASSES_HABILIDADES)
CREATE TABLE Habilidades
(
     HabilidadeId INT PRIMARY KEY IDENTITY
    ,Nome         VARCHAR(80) NOT NULL UNIQUE
);
GO

-- PERSONAGENS: pertence a 1 usuario e a 1 classe (duas chaves estrangeiras)
CREATE TABLE Personagens
(
     PersonagemId   INT PRIMARY KEY IDENTITY
    ,NomePersonagem VARCHAR(60) NOT NULL
    ,UsuarioId      INT NOT NULL
    ,ClasseId       INT NOT NULL
    ,CONSTRAINT FK_Personagens_Usuarios FOREIGN KEY (UsuarioId)
         REFERENCES Usuarios (UsuarioId)
    ,CONSTRAINT FK_Personagens_Classes  FOREIGN KEY (ClasseId)
         REFERENCES Classes (ClasseId)
);
GO

-- CLASSES_HABILIDADES: tabela associativa que resolve o relacionamento
-- N:N entre CLASSES e HABILIDADES (chave primaria composta)
CREATE TABLE Classes_Habilidades
(
     ClasseId     INT NOT NULL
    ,HabilidadeId INT NOT NULL
    ,CONSTRAINT PK_Classes_Habilidades PRIMARY KEY (ClasseId, HabilidadeId)
    ,CONSTRAINT FK_ClassesHabilidades_Classes FOREIGN KEY (ClasseId)
         REFERENCES Classes (ClasseId)
    ,CONSTRAINT FK_ClassesHabilidades_Habilidades FOREIGN KEY (HabilidadeId)
         REFERENCES Habilidades (HabilidadeId)
);
GO

-- 3) Conferir se as tabelas foram criadas conforme o diagrama
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO
