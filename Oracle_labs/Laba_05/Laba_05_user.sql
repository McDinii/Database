CREATE TABLE NNDP_T1
(
    ID   NUMBER PRIMARY KEY,
    NAME VARCHAR(20)
);

INSERT ALL
    INTO NNDP_T1 VALUES (10, 'Petya')
    INTO NNDP_T1 VALUES (11, 'Vasya')
    INTO NNDP_T1 VALUES (12, 'Denis')
SELECT * FROM dual;
select * from NNDP_T1;
-- 6. Удалите (DROP) таблицу XXX_T1.
DROP TABLE NNDP_T1;
-- Выполните SELECT-запрос к представлению USER_RECYCLEBIN, поясните результат.
SELECT *
FROM USER_RECYCLEBIN;
-- 8. Восстановите (FLASHBACK) удаленную таблицу.
FLASHBACK TABLE NNDP_T1 TO BEFORE DROP;
-- 9. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк).
begin
    FOR loopIndex IN 0..99999
        LOOP
            INSERT INTO NNDP_T1 VALUES (loopIndex + 20, 'NAME');
        END LOOP;
    COMMIT;
end;

SELECT COUNT(*)
FROM NNDP_T1;
-- 12. Исследуйте значения псевдостолбца RowId в таблице XXX_T1 и других таблицах. Поясните формат и использование RowId.
-- 13. Исследуйте значения псевдостолбца RowSCN в таблице XXX_T1 и других таблицах.
SELECT ID, ROWID, ORA_ROWSCN
FROM NNDP_T1
ORDER BY ID
    FETCH FIRST 10 ROWS ONLY;
-- RowId - это псевдостолбец, который автоматически создается для каждой строки таблицы в базе данных Oracle.
-- RowId уникально идентифицирует каждую строку в таблице и состоит из 18 символов,
-- где первые 6 символов обозначают адрес блока, а следующие 6 символов - номер строки в блоке.
-- Последние 6 символов - это индивидуальный номер, который гарантирует уникальность RowId в пределах таблицы.
-- RowId используется для быстрого доступа к конкретной строке таблицы и для реализации оптимистической блокировки.

-- RowSCN - это псевдостолбец, который хранит SCN (System Change Number) последней операции изменения строки в таблице.
-- SCN - это внутренний механизм управления версиями данных в базе данных Oracle,
-- который используется для обеспечения целостности и консистентности данных.
-- RowSCN может использоваться для определения времени последнего изменения строки и для обнаружения конфликтов при
-- одновременном доступе к данным. Обычно, RowSCN используется для контроля за согласованностью изменений и о
-- бнаружения конфликтов в параллельной обработке данных.

DROP TABLE NNDP_T1;
drop table T1_WR;
drop table T1_WITH_ROWDEPENDENCIES;

CREATE TABLE T1_WITH_ROWDEPENDENCIES ROWDEPENDENCIES AS SELECT * FROM NNDP_T1;
CREATE TABLE T1_WR AS SELECT * FROM NNDP_T1;

select * from T1_WR;
select * from T1_WITH_ROWDEPENDENCIES;

UPDATE T1_WITH_ROWDEPENDENCIES SET NAME = UPPER ( NAME ) where id=12;
UPDATE T1_WR SET NAME = UPPER ( NAME ) where  id =12;
commit;

SELECT ID,NAME, ROWID, ORA_ROWSCN
FROM T1_WITH_ROWDEPENDENCIES
ORDER BY ID
    FETCH FIRST 10 ROWS ONLY;
SELECT ID,NAME, ROWID, ORA_ROWSCN
FROM T1_WR
ORDER BY ID
    FETCH FIRST 10 ROWS ONLY;

