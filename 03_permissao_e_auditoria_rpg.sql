-- =====================================================================
-- Avaliacao 4 - Usuario restrito (somente leitura) + SQL Server Audit
-- Banco de Dados - SENAI | Aluno: Moises Silveira
-- Pre-requisito: executar antes 01_criar_tabelas_rpg.sql e
--                02_inserir_dados_rpg.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- PARTE 1 - PERMISSAO: login/usuario com acesso apenas de consulta
-- ---------------------------------------------------------------------
USE master;
GO

-- Login usado para conectar no SQL Server
CREATE LOGIN leitor_rpg
WITH PASSWORD = 'Leitor@1234', CHECK_POLICY = OFF;
GO

USE RPGOnline;
GO

-- Usuario dentro do banco, ligado ao login
CREATE USER leitor_rpg FOR LOGIN leitor_rpg;
GO

-- Somente leitura: SELECT permitido; INSERT/UPDATE/DELETE continuam negados
GRANT SELECT TO leitor_rpg;
GO

-- Teste de permissao (simula o usuario leitor_rpg)
EXECUTE AS USER = 'leitor_rpg';

    -- Consulta: DEVE funcionar
    SELECT * FROM Personagens;

    -- Insercao: DEVE ser negada
    BEGIN TRY
        INSERT INTO Classes (Nome, Descricao) VALUES ('Bardo', 'Teste');
        PRINT 'ERRO: o usuario conseguiu inserir (nao deveria).';
    END TRY
    BEGIN CATCH
        PRINT 'OK - Insercao negada: ' + ERROR_MESSAGE();
    END CATCH

REVERT;
GO

-- ---------------------------------------------------------------------
-- PARTE 2 - AUDITORIA (SQL Server Audit)
-- Registra em arquivo os eventos ocorridos no banco RPGOnline.
-- A pasta de destino precisa existir (C:\AuditoriaRPG).
-- ---------------------------------------------------------------------
USE master;
GO

EXEC master.sys.xp_create_subdir 'C:\AuditoriaRPG';
GO

-- 2.1) Auditoria no nivel do servidor, com destino em arquivo
--      Atraso de fila: 1000 ms | Em caso de falha: continuar
--      Tamanho maximo do arquivo: 100 MB | Arquivos de substituicao: ilimitado
CREATE SERVER AUDIT AuditoriaRPGOnline
TO FILE
(
     FILEPATH = 'C:\AuditoriaRPG\'
    ,MAXSIZE = 100 MB
    ,MAX_ROLLOVER_FILES = UNLIMITED
)
WITH
(
     QUEUE_DELAY = 1000
    ,ON_FAILURE = CONTINUE
);
GO

-- 2.2) Habilitar a auditoria
ALTER SERVER AUDIT AuditoriaRPGOnline WITH (STATE = ON);
GO

-- 2.3) Especificacao de auditoria do banco: o que sera registrado
USE RPGOnline;
GO

CREATE DATABASE AUDIT SPECIFICATION EspecificacaoAuditoriaRPG
FOR SERVER AUDIT AuditoriaRPGOnline
    ADD (SELECT, INSERT, UPDATE, DELETE ON DATABASE::RPGOnline BY public)
WITH (STATE = ON);
GO

-- 2.4) Gerar eventos para a auditoria registrar
SELECT * FROM Usuarios;
GO
UPDATE Classes SET Descricao = 'Combatente corpo a corpo, alta resistencia e dano fisico.'
WHERE Nome = 'Guerreiro';
GO

-- 2.5) Ler o log de auditoria gravado em arquivo
SELECT event_time, action_id, succeeded, server_principal_name,
       database_name, object_name, statement
FROM sys.fn_get_audit_file('C:\AuditoriaRPG\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
GO
