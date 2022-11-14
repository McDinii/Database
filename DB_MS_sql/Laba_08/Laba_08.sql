use UNIVER;
-- Task 1
declare @ch char = 'o',
		@vch varchar(5) = 'DENIS',
		@dt datetime,
		@time time,
		@i int,
		@si smallint,
		@ti tinyint,
		@de numeric(12, 5);
		set @dt = GETDATE();
		select @time = CAST('07:07:07' as	time), @i = 123, @ti = 1, @de =  0.312331;

select @ch ch, @dt dt, @si si, @ti ti, @de de;
print 'vch = ' + cast(@vch as varchar(10));
print 'i = ' + cast(@i as varchar(10));
print 'ti = ' + cast(@time as varchar(10));

--Task 2 
declare @x1 int = (select sum(AUDITORIUM_CAPACITY) from dbo.AUDITORIUM), 
@x2 float, @x3 int, @x4 int, @X5 int
if @x1 > 200
begin 
select @x2 = (select cast(avg(AUDITORIUM_CAPACITY) as float) from AUDITORIUM),
@x3 = (select count(*) from AUDITORIUM)
set @x4 = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY > @x2)
set @x5 = (@x4 * 100) / @x3
select @x1 'Суммарная вместимость', @x2 'Средняя вместимость', @x3 'Кол-во аудиторий', @x4 'Аудитории вмест < средней', @X5 'Процент таких аудиторий'
end
else 
print N'Общая вместимость   : ' + cast(@x1 as varchar(10));

--Task 3 
begin
print N'@@ROWCOUNT     :'  + cast(@@rowcount as varchar(10))
print N'@@VERSION      : ' + cast(@@version as varchar(52))
print N'@@SPID         : ' + cast(@@spid as varchar(10))
print N'@@ERROR        : ' + cast(@@error as varchar(10))
print N'@@SERVERNAME   : ' + cast(@@servername as varchar(15))
print N'@@TRANCOUNT    : ' + cast(@@trancount as varchar(10))
print N'@@FETCH_STATUS : ' + cast(@@fetch_status as varchar(10))
print N'@@NESTLEVEL    : ' + CAST(@@nestlevel as varchar(10))
end;


declare 
@x float = 100, @t float = 3,  @z float
if ( @t > @x)
set @z = sin(@t) * sin(@t)
else if (@t = @x)
set @z = 1- exp(@x-2)
else
set @z = 4 * (@t + @x);
print 'z = ' + cast(@z as varchar(10));


declare @name nvarchar(30) = N'Баринов Виктор Петрович',
@name2 nvarchar(20),
@len int,
@pr int
set @len = len(@name)
set @pr = patindex('% %', @name)
--print @pr
set @name2 = left(@name, @pr + 1) + '.'
--print @name2
set @name = right(@name, (@len - @pr - 1))
--print @name
set @pr = patindex('% %', @name)
set @len = len(@name)
set @name = right(@name, @len - @pr)
--print @name
set @name2 = @name2 + left(@name, 1) + '.'
print @name2
;

declare 
@a1 int = year(getdate()),
@a2 int = month(getdate()) + 1;
select STUDENT.NAME, BDAY , @a1 - year(bday) as N'Возраст'
from 
STUDENT
where month(BDAY) = @a2;



declare 
@dd int = 31;
SELECT distinct
CASE DATEPART(WEEKDAY,PDATE)
    WHEN 1 THEN N'Воскресенье' 
    WHEN 2 THEN N'Понедельник' 
    WHEN 3 THEN N'Вторник' 
    WHEN 4 THEN N'Среда' 
    WHEN 5 THEN N'Четверг' 
    WHEN 6 THEN N'Пятница' 
    WHEN 7 THEN N'Суббота' 
END as N'День недели', PROGRESS.SUBJECT, PROGRESS.PDATE
from PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where IDGROUP = @dd;

declare @iii int = (select count(*) from AUDITORIUM);
if (@iii > 10)
begin
print N'Количество аудиторий > 10';
print N'Количество = ' + cast(@iii as varchar(10))
end
ELSE
begin
print N'Количество аудиторий < 10'
print N'Количество = ' + cast(@iii as varchar(10))
end;


select case 
when PROGRESS.NOTE between 8 and 10 then N'хорошая'
when progress.NOTE between 4 and 7 then N'средняя'
else N'ниже среднего'
end as Оценка, count(*) [Количество] 
from  PROGRESS inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
join GROUPS G on student.IDGROUP = G.IDGROUP 
where G.FACULTY = N'ФИТ'
group by case
when PROGRESS.NOTE between 8 and 10 then N'хорошая'
when progress.NOTE between 4 and 7 then N'средняя'
else N'ниже среднего'
end;

create table #TIMETABLE (
INTNUMBER int,
FLOATNUMBER float,
STRING nvarchar(15)
);


set nocount on;
declare @ii int = 0;
while @ii < 10
begin 
	insert #TIMETABLE(INTNUMBER, FLOATNUMBER, STRING) 
	values(FLOOR(14*rand()), 0.38*rand(),replicate('k','2'))
	if (@ii % 10 = 0)
	print @ii;
	set @ii = @ii + 1;
	end;

select * from #TIMETABLE;

declare @smpl int = 93
print @smpl + 1
print @smpl + 2
return
print @smpl + 100;

begin try
update AUDITORIUM set AUDITORIUM_TYPE = N'АБВ'
where AUDITORIUM_TYPE = N'ЛК'
end try 
begin catch
print error_number()
print error_message()
print error_line()
print error_procedure()
print error_severity()
print error_state()
end catch

declare @name nvarchar(25) = N'Фадеев Анатолий Евгеньевич',
@name2 nvarchar(20),
@pr int		
set @pr = patindex('% %', @name)
--print @pr
set @name2 = left(@name, @pr + 1) + '.'
--print @name2
set @name = right(@name, @pr + 2)
--print @name
set @name2 = @name2 + left(@name, 1) + '.'
print @name2
;