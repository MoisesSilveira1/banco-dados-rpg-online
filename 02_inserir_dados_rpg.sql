-- =====================================================================
-- Avaliacao 3 - Inserir os dados do jogo de RPG online (DML)
-- Banco de Dados - SENAI | Aluno: Moises Silveira
-- Pre-requisito: executar antes 01_criar_tabelas_rpg.sql
-- =====================================================================

USE RPGOnline;
GO

-- 1) USUARIOS (dados ficticios)
INSERT INTO Usuarios (Email, Senha) VALUES ('arthur.knight@email.com',  'senha_arthur_01');
INSERT INTO Usuarios (Email, Senha) VALUES ('lia.arcana@email.com',     'senha_lia_02');
INSERT INTO Usuarios (Email, Senha) VALUES ('bruno.sombra@email.com',   'senha_bruno_03');
INSERT INTO Usuarios (Email, Senha) VALUES ('clara.luz@email.com',      'senha_clara_04');
GO

-- 2) CLASSES
INSERT INTO Classes (Nome, Descricao) VALUES ('Guerreiro', 'Combatente corpo a corpo com alta resistencia e dano fisico.');
INSERT INTO Classes (Nome, Descricao) VALUES ('Mago',      'Usuario de magias de ataque a distancia com baixa defesa.');
INSERT INTO Classes (Nome, Descricao) VALUES ('Arqueiro',  'Atacante a distancia, agil e preciso.');
INSERT INTO Classes (Nome, Descricao) VALUES ('Clerigo',   'Suporte capaz de curar aliados e proteger o grupo.');
GO

-- 3) HABILIDADES
INSERT INTO Habilidades (Nome) VALUES ('Golpe Poderoso');
INSERT INTO Habilidades (Nome) VALUES ('Escudo Divino');
INSERT INTO Habilidades (Nome) VALUES ('Bola de Fogo');
INSERT INTO Habilidades (Nome) VALUES ('Raio Gelido');
INSERT INTO Habilidades (Nome) VALUES ('Flecha Perfurante');
INSERT INTO Habilidades (Nome) VALUES ('Cura Menor');
INSERT INTO Habilidades (Nome) VALUES ('Furtividade');
GO

-- 4) CLASSES_HABILIDADES (quais habilidades cada classe possui)
-- Guerreiro (1)
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (1, 1);  -- Golpe Poderoso
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (1, 2);  -- Escudo Divino
-- Mago (2)
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (2, 3);  -- Bola de Fogo
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (2, 4);  -- Raio Gelido
-- Arqueiro (3)
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (3, 5);  -- Flecha Perfurante
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (3, 7);  -- Furtividade
-- Clerigo (4)
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (4, 6);  -- Cura Menor
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId) VALUES (4, 2);  -- Escudo Divino
GO

-- 5) PERSONAGENS (UsuarioId e ClasseId referenciam as tabelas acima)
INSERT INTO Personagens (NomePersonagem, UsuarioId, ClasseId) VALUES ('Sir Arthur',    1, 1);
INSERT INTO Personagens (NomePersonagem, UsuarioId, ClasseId) VALUES ('Lia Arcana',    2, 2);
INSERT INTO Personagens (NomePersonagem, UsuarioId, ClasseId) VALUES ('Sombra Veloz',  3, 3);
INSERT INTO Personagens (NomePersonagem, UsuarioId, ClasseId) VALUES ('Irma Clara',    4, 4);
INSERT INTO Personagens (NomePersonagem, UsuarioId, ClasseId) VALUES ('Arthur Mago',   1, 2);
GO

-- 6) UPDATE: corrigir o nome de um personagem
UPDATE Personagens
SET NomePersonagem = 'Arthur, o Arcano'
WHERE NomePersonagem = 'Arthur Mago';
GO

-- 7) DELETE: remover uma habilidade vinculada a uma classe
DELETE FROM Classes_Habilidades
WHERE ClasseId = 3 AND HabilidadeId = 7;  -- Arqueiro deixa de ter Furtividade
GO

-- 8) SELECT: conferir os dados inseridos
SELECT * FROM Usuarios;
SELECT * FROM Classes;
SELECT * FROM Habilidades;
SELECT * FROM Classes_Habilidades;
SELECT * FROM Personagens;
GO

-- Consulta com JOIN: personagem, dono e classe
SELECT p.PersonagemId, p.NomePersonagem, u.Email AS Usuario, c.Nome AS Classe
FROM Personagens p
INNER JOIN Usuarios u ON u.UsuarioId = p.UsuarioId
INNER JOIN Classes  c ON c.ClasseId  = p.ClasseId;
GO

-- Consulta com JOIN: habilidades de cada classe
SELECT c.Nome AS Classe, h.Nome AS Habilidade
FROM Classes_Habilidades ch
INNER JOIN Classes     c ON c.ClasseId     = ch.ClasseId
INNER JOIN Habilidades h ON h.HabilidadeId = ch.HabilidadeId
ORDER BY c.Nome, h.Nome;
GO
