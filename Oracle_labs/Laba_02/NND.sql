ALTER SESSION SET "_oracle_script" = TRUE;
-- task 1        
--�������� ��������� ������������ ��� ���������� ������ �� ���������� �����������:
--- ���: ts_xxx;
--- ��� �����: ts_xxx; 
--- ��������� ������: 7�;
--- �������������� ����������: 5�;
--- ������������ ������: 30�. 

CREATE TABLESPACE TS_NND
    DATAFILE 'TS_NND.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 30M;
    
SELECT trunc(sum(bytes/1024/1024/1024),0) 
FROM dba_free_space 
WHERE tablespace_name='TS_NND';

-- task 2 
--�������� ��������� ������������ ��� ��������� ������ �� ���������� �����������:
--	���: TS_XXX_TEMP;
--	��� �����: TS_XXX_TEMP; 
--��������� ������: 5�;
--	�������������� ����������: 3�;
--	������������ ������: 20�. 

CREATE TEMPORARY TABLESPACE TS_NND_TEMP
    TEMPFILE 'TS_NND_TEMP.dbf'
    SIZE 5M
    AUTOEXTEND ON NEXT 3M
    MAXSIZE 20M;
 -- task 3   
 -- �������� ������ ���� ��������� ����������� � ������� select-������� � �������.
SELECT TABLESPACE_NAME, STATUS, contents logging FROM SYS.DBA_TABLESPACES;
-- task 4 
--�������� ������ ���� ������ ��������� ����������� � ������� select-������� � �������
SELECT FILE_NAME, TABLESPACE_NAME, STATUS FROM DBA_DATA_FILES
UNION
SELECT FILE_NAME, TABLESPACE_NAME, STATUS FROM DBA_TEMP_FILES;
-- task 5 
--�������� ���� � ������ RL_XXXCORE. ��������� �� ��������� ��������� ����������:
--	���������� �� ���������� � ��������;
--���������� ���������, �������� � ������� �������, �������������, ��������� � �������
select * from DBA_TABLES;
CREATE ROLE RL_NNDPCORE;

GRANT CREATE SESSION,
      CREATE ANY TABLE,
      CREATE VIEW,
      CREATE PROCEDURE
      TO RL_NNDPCORE;
-- task 6 
--������� � ������� select-������� ���� � �������. 
SELECT * FROM DBA_ROLES WHERE ROLE = 'RL_NNDPCORE';
-- task 7
--������� � ������� select-������� ��� ��������� ����������, ����������� ����
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RL_NNDPCORE';

-- task 8 
--�������� ������� ������������ � ������ PF_XXXCORE, ������� �����, �����������
--������� �� ������
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
--�������� ������ ���� �������� ��
SELECT DISTINCT PROFILE FROM DBA_PROFILES;
-- task 10
--�������� �������� ���� ���������� ������� PF_XXXCORE
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PF_NNDCORE';
-- task 11
--�������� �������� ���� ���������� ������� DEFAULT
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';
-- task  12 
--�������� ������������ � ������ XXXCORE �� ���������� �����������:
--- ��������� ������������ �� ���������: TS_XXX;
--- ��������� ������������ ��� ��������� ������: TS_XXX_TEMP;
--- ������� ������������ PF_XXXCORE;
--- ������� ������ ��������������;

CREATE USER NNDPCORE 
    IDENTIFIED BY pass
    DEFAULT TABLESPACE TS_NND
    TEMPORARY TABLESPACE TS_NND_TEMP
    PROFILE PF_NNDCORE
    ACCOUNT UNLOCK
    ;
GRANT RL_NNDPCORE TO NNDPCORE;

-- task 13
--����������� � �������� Oracle � ������� sqlplus � ������� ����� ������
--��� ������������ XXXCORE. 
--�������� ������������ XXXCORE ����� 2m � ������������ TS_XXX.
ALTER USER NNDPCORE QUOTA 2M ON TS_NND;
--���������� ��������� ������������ TS_XXX � ��������� offline
ALTER TABLESPACE TS_NND OFFLINE;
--���������� ��������� ������������ TS_XXX � ��������� online
ALTER TABLESPACE TS_NND ONLINE;

--DROP USER NNDCORE CASCADE;
--DROP PROFILE PF_NNDCORE;
--DROP ROLE RL_NNDCORE;
    
--DROP TABLESPACE TS_NND INCLUDING CONTENTS AND DATAFILES;
--DROP TABLESPACE TS_NND_TEMP INCLUDING CONTENTS AND DATAFILES;  