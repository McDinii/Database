ALTER SESSION SET "_oracle_script" = TRUE;
-- task 1        
--создайте табличное пространство для постоянных данных со следующими параметрами:
--- имя: ts_xxx;
--- имя файла: ts_xxx; 
--- начальный размер: 7М;
--- автоматическое приращение: 5М;
--- максимальный размер: 30М. 

CREATE TABLESPACE TS_NND
    DATAFILE 'TS_NND.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 30M;
    
SELECT trunc(sum(bytes/1024/1024/1024),0) 
FROM dba_free_space 
WHERE tablespace_name='TS_NND';

-- task 2 
--Создайте табличное пространство для временных данных со следующими параметрами:
--	имя: TS_XXX_TEMP;
--	имя файла: TS_XXX_TEMP; 
--начальный размер: 5М;
--	автоматическое приращение: 3М;
--	максимальный размер: 20М. 

CREATE TEMPORARY TABLESPACE TS_NND_TEMP
    TEMPFILE 'TS_NND_TEMP.dbf'
    SIZE 5M
    AUTOEXTEND ON NEXT 3M
    MAXSIZE 20M;
 -- task 3   
 -- Получите список всех табличных пространств с помощью select-запроса к словарю.
SELECT TABLESPACE_NAME, STATUS, contents logging FROM SYS.DBA_TABLESPACES;
-- task 4 
--Получите список всех файлов табличных пространств с помощью select-запроса к словарю
SELECT FILE_NAME, TABLESPACE_NAME, STATUS FROM DBA_DATA_FILES
UNION
SELECT FILE_NAME, TABLESPACE_NAME, STATUS FROM DBA_TEMP_FILES;
-- task 5 
--Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии:
--	разрешение на соединение с сервером;
--разрешение создавать, изменять и удалять таблицы, представления, процедуры и функции
select * from DBA_TABLES;
CREATE ROLE RL_NNDPCORE;

GRANT CREATE SESSION,
      CREATE ANY TABLE,
      CREATE VIEW,
      CREATE PROCEDURE
      TO RL_NNDPCORE;
-- task 6 
--Найдите с помощью select-запроса роль в словаре. 
SELECT * FROM DBA_ROLES WHERE ROLE = 'RL_NNDPCORE';
-- task 7
--Найдите с помощью select-запроса все системные привилегии, назначенные роли
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RL_NNDPCORE';

-- task 8 
--Создайте профиль безопасности с именем PF_XXXCORE, имеющий опции, аналогичные
--примеру из лекции
CREATE PROFILE PF_NNDCORE LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;
-- task 9     
--Получите список всех профилей БД
SELECT DISTINCT PROFILE FROM DBA_PROFILES;
-- task 10
--Получите значения всех параметров профиля PF_XXXCORE
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PF_NNDCORE';
-- task 11
--Получите значения всех параметров профиля DEFAULT
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';
-- task  12 
--Создайте пользователя с именем XXXCORE со следующими параметрами:
--- табличное пространство по умолчанию: TS_XXX;
--- табличное пространство для временных данных: TS_XXX_TEMP;
--- профиль безопасности PF_XXXCORE;
--- учетная запись разблокирована;

CREATE USER NNDPCORE 
    IDENTIFIED BY pass
    DEFAULT TABLESPACE TS_NND
    TEMPORARY TABLESPACE TS_NND_TEMP
    PROFILE PF_NNDCORE
    ACCOUNT UNLOCK
    ;
GRANT RL_NNDPCORE TO NNDPCORE;

-- task 13
--Соединитесь с сервером Oracle с помощью sqlplus и введите новый пароль
--для пользователя XXXCORE. 
--Выделите пользователю XXXCORE квоту 2m в пространстве TS_XXX.
ALTER USER NNDPCORE QUOTA 2M ON TS_NND;
--Переведите табличное пространство TS_XXX в состояние offline
ALTER TABLESPACE TS_NND OFFLINE;
--Переведите табличное пространство TS_XXX в состояние online
ALTER TABLESPACE TS_NND ONLINE;

--DROP USER NNDCORE CASCADE;
--DROP PROFILE PF_NNDCORE;
--DROP ROLE RL_NNDCORE;
    
--DROP TABLESPACE TS_NND INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE TS_NND_TEMP INCLUDING CONTENTS AND DATAFILES;  