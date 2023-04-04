-- 1. Получите список всех табличных пространств.
select * from SYS.DBA_TABLESPACES;
ALTER SESSION SET CONTAINER=XEPDB1;
ALTER PLUGGABLE DATABASE NNDP_PDB OPEN;
ALTER SESSION SET "_oracle_script" = TRUE;
-- 2. Создайте табличное пространство с именем XXX_QDATA (10 m).
-- При создании установите его в состояние offline.
-- Затем переведите табличное пространство в состояние online.
-- Выделите пользователю XXX квоту 2 m в пространстве XXX_QDATA.
-- От имени XXX в пространстве XXX_QDATA создайте таблицу XXX_T1 из двух столбцов,
-- один из которых будет являться первичным ключом. В таблицу добавьте 3 строки.
create tablespace NNDP_QDATA DATAFILE
    'NNDP1_QDATA.dbf'
    SIZE 10m
    offline;
alter tablespace NNDP_QDATA online ;
SELECT * FROM DBA_DATA_FILES;
SELECT name, open_mode FROM v$pdbs;
CREATE USER NNDP
    IDENTIFIED BY pass
    DEFAULT TABLESPACE NNDP_QDATA
    ACCOUNT UNLOCK;
GRANT CREATE SESSION,
    CREATE TABLE
    TO NNDP;

ALTER USER NNDP QUOTA 5M ON NNDP_QDATA;
-- 3. Получите список сегментов табличного пространства XXX_QDATA.
-- 4. Определите сегмент таблицы XXX_T1.
-- 5. Определите остальные сегменты.
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_NAME = 'NNDP_T1';

SELECT * FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'NNDP_QDATA';

SELECT SEGMENT_NAME, EXTENTS, BLOCKS, BYTES FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'NNDP_QDATA';

SELECT * FROM DBA_SEGMENTS;



-- 7. Получите список сегментов табличного пространства XXX_QDATA.
-- Определите сегмент таблицы XXX_T1.

SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_NAME = 'NNDP_T1';

SELECT * FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'NNDP_QDATA';

SELECT SEGMENT_NAME, EXTENTS, BLOCKS, BYTES FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'NNDP_QDATA';




-- 10. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах.
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_NAME = 'NNDP_T1';
SELECT * FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'NNDP_QDATA';
SELECT SEGMENT_NAME, EXTENTS, BLOCKS, BYTES FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'NNDP_QDATA';
-- 11. Получите перечень всех экстентов в базе данных.
SELECT owner, segment_name, segment_type, extent_id, file_id, block_id, blocks
FROM dba_extents;

-- 14. (*) Измените таблицу так, чтобы для каждой строки RowSCN выставлялся индивидуально.
-- 15. Продемонстрируйте работу преподавателю.
-- 16. Удалите табличное пространство XXX_QDATA и его файл.
