USE master
CREATE LOGIN SEULOGIN WITH password='SUA SENHA';

CREATE USER SEULOGIN FROM LOGIN SEULOGIN

USE db_estacionamento

CREATE USER SEULOGIN FROM LOGIN SEULOGIN;

--Dono do Banco
EXEC sp_addrolemember 'db_owner', 'SEU LOGIN';

-- Permiss�o para ler os dados do banco
EXEC sp_addrolemember 'db_datareader', 'SEU LOGIN';

-- Permiss�o para escrever no banco
EXEC sp_addrolemember 'db_datawriter', 'SEU LOGIN';

-- Admin seguran�a
EXEC sp_addrolemember 'db_securityadmin', 'SEU LOGIN';

-- Permiss�o Public (Nenhuma)
EXEC sp_addrolemember 'db_public', 'SEU LOGIN';