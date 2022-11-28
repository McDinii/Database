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
PRINT N'���-�� ��������� = ' + CAST(@d AS varchar(5));

-- Task 2 --
ALTER procedure [dbo].[PSUBJECT] @p nvarchar(20), @c int output 
AS
begin
declare @k int = (select count(*) from  SUBJECT);
print N'���������: @p = ' + @p + ', @c = ' + cast(@c as varchar(3));
select * from SUBJECT where PULPIT = @p;
set @c = @@ROWCOUNT;
return @k;
end;
GO
declare @k int = 0, @r int = 0;--@p nvarchar(20) = '';
exec @k = PSUBJECT @p= N'����', @c = @r output;
print N'���-�� ���� ��������� = ' + cast(@k as varchar(3));
print N'���-�� ��������� �� ������� ' + '= ' + cast(@r as varchar(30));

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
insert #SUBJECT exec PSUBJECT @p= N'����'
insert #SUBJECT exec PSUBJECT @p= N'��������'
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
		print N'����� ������: ' + cast(error_number() as varchar(6));
		print N'���������: ' + error_message()
		print N'�������: ' + cast(error_severity() as varchar(6));
		print N'�����: ' + cast(error_state() as varchar(8));
		print N'����� ������: ' + cast(error_line() as varchar(8));
		if ERROR_PROCEDURE() is not null
		print N'��� ���������:' + error_procedure();
		return -1;
		end catch;

EXEC PAUDITORIUM_INSERT @a= '113-4', @n = N'��-�', @c = 20, @t = '113-4';
EXEC PAUDITORIUM_INSERT @a= '207-2a', @n = N'���������', @c = 3, @t = '207-2�';
EXEC PAUDITORIUM_INSERT @a= '229-4', @n = N'��-�', @c = 30, @t = '229-4';

-- Task 5 

alter procedure SUBJECT_REPORT @p nchar(20)
as
declare @rc int = 0;
begin try
declare @tv nchar(20), @t nchar(300) = '';
declare SUBREP cursor for 
select SUBJECT from SUBJECT where PULPIT = @p;
IF not exists (select SUBJECT from SUBJECT where PULPIT = @p)
raiserror(N'������', 11, 1);
else open SUBREP;
FETCH SUBREP into @tv;
print N'�������� �������: ';
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
print N'������ � ��������� '  + @p
IF ERROR_PROCEDURE() is not null
print N'��� ���������:' + error_procedure();
return @rc;
end catch;

declare @rc int;
exec @rc = SUBJECT_REPORT @p = N'����'
print N'���������� ��������� = ' + cast(@rc as varchar(3));

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
		print N'����� ������: ' + cast(error_number() as varchar(6));
		print N'���������: ' + error_message()
		print N'�������: ' + cast(error_severity() as varchar(6));
		print N'�����: ' + cast(error_state() as varchar(8));
		print N'����� ������: ' + cast(error_line() as varchar(8));
		if ERROR_PROCEDURE() is not null
		print N'��� ���������:' + error_procedure();
		if @@TRANCOUNT > 0 rollback;
		return -1;
		end catch;

declare @rc int;
--exec @rc = PAUDITORIUM_INSERTX @a = '439-4', @n = N'��', @c = 30, @t = '439-4', @tn = N'������������';
exec @rc = PAUDITORIUM_INSERTX @a = '104-4', @n = N'�������', @c = 30, @t = '104-4', @tn = N'���������';
print N'��� ������: ' + CAST(@rc as varchar(3));
