use UNIVER
-- Task 1
exec SP_HELPINDEX 'AUDITORIUM_TYPE'
exec SP_HELPINDEX 'AUDITORIUM'

CREATE table #EXPLRE
(	TIND int,
	TFIELD varchar(100)
);

SET nocount on;
DECLARE @i int = 0;
while @i < 1000
	begin 
	insert #EXPLRE(TIND,TFIELD)
		values(floor(20000*RAND()),REPLICATE('Строка',10));
	if (@i%100=0)
		print @i; 
	set @i+=1;
	end;

select * from #EXPLRE where TIND between 1500 and 2500 order by TIND
checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc)

-- Task 2
CREATE table #EX
(	TKEY int,
	CC int identity(1,1),
	TF varchar(100)
);

SET nocount on;
DECLARE @i int = 0;
while @i < 20000
	begin 
	insert #EX(TKEY,TF)
		values(floor(30000*RAND()),REPLICATE('Строка',10));
	set @i+=1;
	end;
Select count(*)[кол-во  строк]  from #EX;
select * from #EX

Create index #EX_NONCLU on #EX(TKEY,CC)
-- к след запросам индексы выше не применяются
select * from #EX where TKEY>1500 and CC<4500;
select * from  #EX order by TKEY,CC
-- к след прим
select * from #EX where TKEY = 1 and CC>3

-- Task 3
CREATE table #EX2
(	TKEY int,
	CC int identity(1,1),
	TF varchar(100)
);

SET nocount on;
DECLARE @i int = 0;
while @i < 10000
	begin 
	insert #EX2(TKEY,TF)
		values(floor(30000*RAND()),REPLICATE('Строка',10));
	set @i+=1;
	end;

select * from #EX2
create index #EX_TKEY_Y on #EX2(TKEY)include(TF)

-- Task 4
select TKEY from #EX where TKEY between 5000 and 19999; -- было 0.034
select TKEY from #EX where TKEY >15000 and TKEY < 20000 -- было 0.013
select TKEY from #EX where TKEY = 17000 -- 0.004

create index #EX_WHERE on #EX(TKEY) where (TKEY >= 15000 and TKEY < 20000);

select TKEY from #EX where TKEY between 5000 and 19999; -- было 0.034
select TKEY from #EX where TKEY >15000 and TKEY < 20000 -- было 0.0077
select TKEY from #EX where TKEY = 17000 -- 0.0032

-- Task 5
use tempdb
create index #EX_TF on #EX(TF);
INSERT top(100000) #EX(TKEY, TF) select TKEY, TF from #EX;
select name[Индекс], avg_fragmentation_in_percent[Фрагментация(%)]
	from sys.dm_db_index_physical_stats(DB_ID('TEMPDB'),
	OBJECT_ID('#EX'),NULL,NULL,NULL) ss 
	join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
												where name is not null;
alter index #EX_TKEY on #EX reorganize -- REORGANIZE
alter index #EX_TF on #EX reorganize -- REORGANIZE
alter index #EX_WHERE on #EX rebuild with (online = off) -- REBUILD
alter index #EX_NONCLU on #EX rebuild with (online = off) -- REBUILD

-- Task 6 

DROP index #EX_TKEY on #EX
create index #EX_TKEY on #EX(TKEY) with (fillfactor = 100)
insert top(50) percent into #EX(TKEY,TF) 
						select TKEY,TF from #EX 
select name[Индекс], avg_fragmentation_in_percent[Фрагментация(%)]
	from sys.dm_db_index_physical_stats(DB_ID('TEMPDB'),
	OBJECT_ID('#EX'),NULL,NULL,NULL) ss 
	join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
												where name is not null;