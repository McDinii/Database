--1. Получите список всех табличных пространств (перманентных, временных и UNDO).
SELECT tablespace_name, contents FROM dba_tablespaces;
SELECT * FROM dba_tablespaces;
--2. Получите список всех файлов табличных пространств (перманентных, временных и UNDO).
SELECT TABLESPACE_NAME, FILE_NAME
FROM dba_data_files
UNION ALL
SELECT TABLESPACE_NAME, FILE_NAME
FROM dba_temp_files
union all
SELECT * FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='UNDOTBS1';
--3. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.
SELECT GROUP# FROM V$LOG GROUP BY GROUP#;
SELECT GROUP# FROM V$LOG WHERE STATUS='CURRENT';
SELECT * FROM V$LOG;
--4. Получите перечень файлов всех журналов повтора.
SELECT member
FROM v$logfile
WHERE group# IN (
    SELECT group#
    FROM v$log
);
SELECT member FROM v$logfile;
-- 5. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. Проследите последовательность SCN.
ALTER SYSTEM SWITCH LOGFILE;
SELECT A.member,A.GROUP#,B.STATUS FROM v$logfile A join v$log B on A.GROUP# = B.GROUP#;
SELECT log_mode FROM v$database;
-- 6. EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала.
    -- Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением).
    -- Проследите последовательность SCN.
ALTER DATABASE ADD logfile group 4 ('D:\APPS\ORADB\ORADATA\XE\REDO04.LOG',
                                    'D:\APPS\ORADB\ORADATA\XE\REDO041.LOG',
                                    'D:\APPS\ORADB\ORADATA\XE\REDO042.LOG')
    size 50m blocksize 512;
ALTER SYSTEM SWITCH LOGFILE;
SELECT group#, sequence#, bytes, status, first_change#, next_change#
FROM v$log;
ALTER DATABASE CLEAR LOGFILE GROUP 4;
SELECT * FROM V$LOGfile;
-- 7. EX. Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.
alter DATABASE DROP logfile GROUP 4;
SELECT group#, sequence#, bytes, status, first_change#, next_change#
FROM v$log;
-- 8. Определите, выполняется или нет архивирование журналов повтора
    -- (архивирование должно быть отключено, иначе дождитесь, пока другой студент выполнит задание и отключит).
SELECT NAME,log_mode FROM v$database;
-- 9. Определите номер последнего архива.
SELECT MAX(sequence#) AS last_archived_seq#
FROM v$log_history;
SELECT NAME,log_mode FROM v$database;
-- 10. EX. Включите архивирование.
ALTER SYSTEM SET log_archive_start=TRUE SCOPE=SPFILE;

SHUTDOWN IMMEDIATE;
STARTUP;
SELECT dest_name, status FROM v$archive_dest;
ALTER SYSTEM ARCHIVE LOG START;
SELECT group#, sequence#, bytes, status, first_change#, next_change#,ARCHIVED
FROM v$log;
alter database archivelog;
-- 11. EX. Принудительно создайте архивный файл. Определите его номер.
-- Определите его местоположение и убедитесь в его наличии.
-- Проследите последовательность SCN в архивах и журналах повтора.
alter system switch logfile;
select * from v$archived_log;

select Name, first_change#, next_change# from v$archived_log;

show parameter db_recovery; -- sqlplus
SELECT name,type, value
FROM v$parameter
WHERE name in ('db_recovery_file_dest','db_recovery_file_dest_size');
archive log list; -- sqlplus
-- 12. EX. Отключите архивирование. Убедитесь, что архивирование отключено.
SELECT NAME,log_mode FROM v$database;
-- 13. Получите список управляющих файлов.
SELECT name FROM v$controlfile;
-- 14. Получите и исследуйте содержимое управляющего файла.
-- Поясните известные вам параметры в файле.
SHOW parameter control_files;
    select NAME from V_$CONTROLFILE;
    select type,RECORD_SIZE,RECORDS_TOTAL from V_$CONTROLFILE_RECORD_SECTION;
-- 15. Проверьте! После вашей работы не должно остаться ни одного файла, созданного вами в процессе выполнения лабораторной работы. Студент, нарушивший это правило, получит дополнительное (трудоемкое) задание.
