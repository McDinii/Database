-- Task 1

set nocount on
if exists(select * from SYS.objects
			where OBJECT_ID=object_id('DBO.Y'))
drop table Y;

declare @c int, @flag char = 'c';
SET IMPLICIT_TRANSACTIONS ON 
create table Y(Numbers bigint);
		insert Y values(375293354677),(37529334546),(37542626323);
		set @c = (select COUNT(*)from Y);
		print '���-�� ����� � ������� Y:'+cast(@c as varchar(2));
		if @flag = 'c' commit;
		else rollback;
SET IMPLICIT_TRANSACTIONS OFF

if exists(select * from SYS.objects
			where OBJECT_ID=object_id('DBO.Y'))
	print 'Table here';
	else print 'Table doesnt exists';
select * from Y

-- Task 2

begin try 
	begin tran 
	declare @id int = 2083;
	 delete STUDENT where STUDENT.IDSTUDENT = @id;
	 print 'Student'+cast(@id as varchar(10));
	 --insert STUDENT (IDSTUDENT,IDGROUP, NAME, BDAY) values (2081,13,'��������� ����� �����','2222-12-31');
	 --insert STUDENT (IDSTUDENT,IDGROUP, NAME, BDAY) values (2082,12,'����������� ���� �������','2022-12-31');
	commit tran;
	end
	try begin catch
		print 'Error: ' + case
			when error_number() = 2627 and patindex('%PK_STUDENT%',error_message())>0
			then 'dublicate student'
			else 'error:' + cast(error_number() as varchar(5))+error_message()
		end;
		if @@TRANCOUNT > 0 rollback tran;
	end catch

select * from STUDENT

-- Task 3
declare @point varchar(32);
begin try 
	begin tran 
	 insert STUDENT (IDSTUDENT,IDGROUP, NAME, BDAY) values (2086,13,'������� ������ �����','2010-12-31');
	 set @point='p1'; save tran @point;
	-- insert STUDENT (IDGROUP, NAME, BDAY) values (12,'�����������  ������ ������','2022-12-31');
	delete STUDENT where NAME like '%�������%'
	 set @point='p2'; save tran @point;
	commit tran;
	end
	try begin catch
		print 'Error: ' + case
			when error_number() = 2627 and patindex('%PK_STUDENT%',error_message())>0
			then 'dublicate student'
			else 'error:' + cast(error_number() as varchar(5))+error_message()
		end;
		if @@TRANCOUNT > 0 rollback tran;
		begin 
			print 'point: ' + @point;
			rollback tran  @point;
			commit tran;
		end;
	end catch

select * from STUDENT

-- Task 4 
-- A -- 
set transaction isolation level READ UNCOMMITTED
begin transaction 
	----------------t1-------------
	select @@SPID, 'insert PROGRESS' 'result',* from PROGRESS where IDSTUDENT = 1007 ;
	select @@SPID, 'update PROGRESS' 'result',IDSTUDENT,NOTE from PROGRESS where IDSTUDENT = 1005 and NOTE = 5;
	commit;
	-----------t2-----------------
--B--
begin transaction 
	select @@SPID
	insert PROGRESS values('����', 1007,'2022-11-19',8);
	update PROGRESS set NOTE = 5 where IDSTUDENT = 1005
	--------t1---------
	--------t2---------
	rollback;
select *  from progress

-- Task 5 
------A--------
set transaction isolation level READ COMMITTED
begin transaction
select COUNT(*) from PROGRESS where SUBJECT = N'����';
----------------t1---------
----------------t2---------
select N'update PROGRESS'N'���������', count(*)
from PROGRESS where SUBJECT = N'����';
commit;

----B----
begin transaction
---------t1-------
update PROGRESS set SUBJECT = N'����'
where SUBJECT = N'��'
commit;
------t2----------

-- Task 6 
    ------A------
set transaction isolation level repeatable read
begin transaction
select IDSTUDENT from PROGRESS where SUBJECT =  N'����';
---------t1-------
---------t2-------
select case 
when IDSTUDENT = 1000 THEN N'insert ������' else ''
end N'���������', IDSTUDENT
FROM PROGRESS WHERE SUBJECT =  N'����';
commit;

     ------B--------
begin transaction
-----------t1-----------
insert PROGRESS values(N'����', 1000, CAST('2016-01-29' AS DATE), 6)
COMMIT;
-------------t2--------

-- Task 7 
    ---A---
set transaction isolation level SERIALIZABLE
begin transaction
delete PROGRESS where IDSTUDENT = 1000;
INSERT PROGRESS values(N'����', 1000, CAST('2016-06-12' AS DATE), 7);
update PROGRESS set IDSTUDENT = 1000 WHERE SUBJECT = N'����';
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'����';
------------t1-------
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'����';
commit;

-----B----
begin transaction
delete PROGRESS where IDSTUDENT = 1000;
INSERT PROGRESS values(N'����', 1000, CAST('2016-06-12' AS DATE), 7);
update PROGRESS set IDSTUDENT = 1000 WHERE SUBJECT = N'����';
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'����';
-------------t1-----------
commit;
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'����';
----------------t2-----------

-- Task 8 

begin tran -- ������� 
delete STUDENT where name = '��������� ������� �������'
insert STUDENT (IDGROUP, NAME, BDAY) values(12,'��������� ������� ��������', '2004-03-28');
begin tran -- ���������� 
update PROGRESS set IDSTUDENT  =999 WHERE IDSTUDENT = 2107;
commit  -- ���������� 
if @@TRANCOUNT > 0 -- �������
rollback;
select
	(select count(*) from progress where IDSTUDENT = 999) 'E. of 999',
	(select count(*) from STUDENT WHERE NAME = '��������� ������� �������')  'Student';
select * from PROGRESS
select * from student 