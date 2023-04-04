SELECT VALUE FROM V$PARAMETER WHERE NAME = 'spfile';
SELECT NAME,VALUE FROM V$PARAMETER;
SELECT NAME,VALUE FROM V$PARAMETER where name= 'open_cursors';

CREATE PFILE = 'NNDP350_PFILE.ora' FROM SPFILE;

CREATE SPFILE = 'NNDP_SPFILE.ora' FROM PFILE = 'NNDP_PFILE.ora';
ALTER DATABASE OPEN;
SHOW PARAMETER OPEN_CURSORS;
SELECT * FROM V$INSTANCE;
ALTER SYSTEM SET OPEN_CURSORS = 350;


SHOW PARAMETER OPEN_CURSORS;
-- 9
SHOW PARAMETER CONTROL_FILES;
CREATE CONTROLFILE REUSE DATABASE
    SET DATABASE "ORCL" NORESETLOGS NOARCHIVELOG -- Устанавливает имя базы данных и опции регистрации и архивирования журналов.
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 1024
    MAXINSTANCES 8 -- Определяет максимальное количество файлов журналов, членов журнала, файлов данных и экземпляров.
    MAXLOGHISTORY 292
    LOGFILE
    GROUP 1 ('C:\LOG\INSTALL_LOG01.LOG') SIZE 50M BLOCKSIZE 512, -- Создает группу журналов 1 с одним членом, который находится в каталоге "C:\LOG\" и называется "INSTALL_LOG01.LOG". Каждый файл журнала будет иметь размер 50 мегабайт, а размер блока будет равен 512 байтам.
    GROUP 2 ('C:\LOG\INSTALL_LOG02.LOG') SIZE 50M BLOCKSIZE 512
alter database backup controlfile to trace;
SELECT * FROM V$PASSWORDFILE_INFO;

-- 11
SELECT * FROM V$PWFILE_USERS;
--12
show parameter remote_login_password;
-- 13. Получите перечень директориев для файлов сообщений и диагностики.
SELECT * FROM V$DIAG_INFO;
-- 15
SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Default Trace File';
