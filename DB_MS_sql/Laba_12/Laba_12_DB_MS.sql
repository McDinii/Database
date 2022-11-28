-- Task 1
create procedure PSUBJECT
AS
begin
declare @k int = (select count(*) from  SUBJECT);
select * from SUBJECT;
return @k;
end;

declare @d int = 0;
exec @d = PSUBJECT;
PRINT N'Кол-во предметов = ' + CAST(@d AS varchar(5));

-- Task 2 --
ALTER procedure [dbo].[PSUBJECT] @p nvarchar(20), @c int output 
AS
begin
declare @k int = (select count(*) from  SUBJECT);
print N'параметры: @p = ' + @p + ', @c = ' + cast(@c as varchar(3));
select * from SUBJECT where PULPIT = @p;
set @c = @@ROWCOUNT;
return @k;
end;
GO
declare @k int = 0, @r int = 0;--@p nvarchar(20) = '';
exec @k = PSUBJECT @p= N'ИСиТ', @c = @r output;
print N'Кол-во всех предметов = ' + cast(@k as varchar(3));
print N'Кол-во предметов на кафедре ' + '= ' + cast(@r as varchar(30));

-- Task 3 

create table #SUBJECT (
SUBJECT nchar(10),
SUBJECT_NAME nvarchar(100),
PULPIT nchar(20));

ALTER procedure [dbo].[PSUBJECT] @p nvarchar(20)
AS
begin
declare @k int = (select count(*) from  SUBJECT);
select * from SUBJECT where PULPIT = @p;
end;
GO
insert #SUBJECT exec PSUBJECT @p= N'ИСиТ'
insert #SUBJECT exec PSUBJECT @p= N'ТНХСиППМ'
select * from #SUBJECT

-- Task 4 
CREATE procedure PAUDITORIUM_INSERT
				@a nchar(20), @n nchar(10), @c int = 0, @t nvarchar(50)
				as declare @forr int = 1;
		begin try
		insert into AUDITORIUM(AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
		values (@a, @n, @c, @t)
		return @forr;
		end try
		begin catch
		print N'Номер ошибки: ' + cast(error_number() as varchar(6));
		print N'Сообщение: ' + error_message()
		print N'Уровень: ' + cast(error_severity() as varchar(6));
		print N'Метка: ' + cast(error_state() as varchar(8));
		print N'Номер строки: ' + cast(error_line() as varchar(8));
		if ERROR_PROCEDURE() is not null
		print N'Имя процедуры:' + error_procedure();
		return -1;
		end catch;

EXEC PAUDITORIUM_INSERT @a= '113-4', @n = N'ЛБ-К', @c = 20, @t = '113-4';
EXEC PAUDITORIUM_INSERT @a= '207-2a', @n = N'Секретная', @c = 3, @t = '207-2а';
EXEC PAUDITORIUM_INSERT @a= '229-4', @n = N'ЛБ-К', @c = 30, @t = '229-4';

-- Task 5 

alter procedure SUBJECT_REPORT @p nchar(20)
as
declare @rc int = 0;
begin try
declare @tv nchar(20), @t nchar(300) = '';
declare SUBREP cursor for 
select SUBJECT from SUBJECT where PULPIT = @p;
IF not exists (select SUBJECT from SUBJECT where PULPIT = @p)
raiserror(N'ошибка', 11, 1);
else open SUBREP;
FETCH SUBREP into @tv;
print N'Предметы кафедры: ';
while @@FETCH_STATUS = 0
begin
set @t = RTRIM(@tv) +', ' +  @t;
set @rc = @rc + 1;
fetch SUBREP into @tv;
end;
print @t;
close SUBREP;
deallocate SUBREP;
return @rc;
end try
begin catch
print N'ошибка в параметре '  + @p
IF ERROR_PROCEDURE() is not null
print N'имя процедуры:' + error_procedure();
return @rc;
end catch;

declare @rc int;
exec @rc = SUBJECT_REPORT @p = N'ИСиТ'
print N'Количество предметов = ' + cast(@rc as varchar(3));

create procedure PAUDITORIUM_INSERTX @a nchar(20), @n nchar(10), @c int = 0, @t nvarchar(50), @tn nvarchar(50)
as
declare 
@rc int = 1;
begin try
set transaction isolation level SERIALIZABLE
begin tran
insert into AUDITORIUM_TYPE( AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
VALUES (@n, @tn)
exec @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
commit tran;
return @rc;
end try
	begin catch
		print N'Номер ошибки: ' + cast(error_number() as varchar(6));
		print N'Сообщение: ' + error_message()
		print N'Уровень: ' + cast(error_severity() as varchar(6));
		print N'Метка: ' + cast(error_state() as varchar(8));
		print N'Номер строки: ' + cast(error_line() as varchar(8));
		if ERROR_PROCEDURE() is not null
		print N'Имя процедуры:' + error_procedure();
		if @@TRANCOUNT > 0 rollback;
		return -1;
		end catch;

declare @rc int;
--exec @rc = PAUDITORIUM_INSERTX @a = '439-4', @n = N'ПЗ', @c = 30, @t = '439-4', @tn = N'Практическая';
exec @rc = PAUDITORIUM_INSERTX @a = '104-4', @n = N'ДЕКАНАТ', @c = 30, @t = '104-4', @tn = N'Чистилище';
print N'Код ошибки: ' + CAST(@rc as varchar(3));
