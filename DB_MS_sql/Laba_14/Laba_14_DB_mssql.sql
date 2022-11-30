use UNIVER;
-- Task 1 
create table TR_AUDIT
(
	ID int identity,
	ST varchar(20)
	check (ST in ('INS','DEL','UPD')),
	TRN varchar(50),
	C varchar(300)
	)
drop trigger TR_TEACHER_INS
create trigger TR_TEACHER_INS 
							on TEACHER after INSERT
as declare @a1 varchar(3),@a2 varchar(20), @a3 varchar(1),@a4 varchar(10), @in varchar(300);
print 'Операция вставки';
set @a1 = (select [TEACHER] from inserted);
set @a2 = rtrim((select [TEACHER_NAME] from inserted));
set @a3 = rtrim((select [GENDER] from inserted));
set @a4 = rtrim((select [PULPIT] from inserted));
set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
insert into TR_AUDIT(ST,TRN,C) values ('INS','TR_TEACHER_INS',@in);
return;
DElete  from TEACHER where TEACHER like'ППП'
  select * from TR_AUDIT

-- Task 2 
create trigger TR_TEACHER_DEL on TEACHER after DELETE
as declare @a1 varchar(3),@a2 varchar(20), @a3 varchar(1),@a4 varchar(10), @in varchar(300);
print 'Операция удаления';
set @a1 = (select [TEACHER] from deleted);
set @a2 = rtrim((select [TEACHER_NAME] from deleted));
set @a3 = rtrim((select [GENDER] from deleted));
set @a4 = rtrim((select [PULPIT] from deleted));
set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
insert into TR_AUDIT(ST,TRN,C) values ('DEL','TR_TEACHER_DEL',@in);
return;
delete  from TEACHER where TEACHER like'ППП'
select * from TR_AUDIT

-- Task 3
create trigger TR_TEACHER_UPD on TEACHER after UPDATE
as declare @a1 varchar(3),@a2 varchar(20), @a3 varchar(1),@a4 varchar(10), @in varchar(300);
print 'Операция обновления';
set @a1 = (select [TEACHER] from inserted);
set @a2 = rtrim((select [TEACHER_NAME] from inserted));
set @a3 = rtrim((select [GENDER] from inserted));
set @a4 = rtrim((select [PULPIT] from inserted));
set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
set @a1 = (select [TEACHER] from deleted);
set @a2 = rtrim((select [TEACHER_NAME] from deleted));
set @a3 = rtrim((select [GENDER] from deleted));
set @a4 = rtrim((select [PULPIT] from deleted));
set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
insert into TR_AUDIT(ST,TRN,C) values ('UPD','TR_TEACHER_UPD',@in);
return;
update TEACHER set TEACHER_NAME = 'Петров Петька Павлович' where TEACHER like 'ППП'
delete  from TEACHER where TEACHER like'ППП'
select * from TR_AUDIT

-- Task 4 

create trigger TR_Teacher on Teacher after INSERT, DELETE, UPDATE  
as declare @a1 varchar(3),@a2 varchar(20), @a3 varchar(1),@a4 varchar(10), @in varchar(300);
declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 
if  @ins > 0 and  @del = 0  
begin 
	print 'Операция вставки';
	set @a1 = (select [TEACHER] from inserted);
	set @a2 = rtrim((select [TEACHER_NAME] from inserted));
	set @a3 = rtrim((select [GENDER] from inserted));
	set @a4 = rtrim((select [PULPIT] from inserted));
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
	insert into TR_AUDIT(ST,TRN,C) values ('INS','TR_TEACHER_INS',@in);
end; 
else		  	 
if @ins = 0 and  @del > 0  
begin 
	print 'Операция удаления';
	set @a1 = (select [TEACHER] from deleted);
	set @a2 = rtrim((select [TEACHER_NAME] from deleted));
	set @a3 = rtrim((select [GENDER] from deleted));
	set @a4 = rtrim((select [PULPIT] from deleted));
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
	insert into TR_AUDIT(ST,TRN,C) values ('DEL','TR_TEACHER_DEL',@in);end; 
else	  
if @ins > 0 and  @del > 0  
begin 
	print 'Операция обновления';
	set @a1 = (select [TEACHER] from inserted);
	set @a2 = rtrim((select [TEACHER_NAME] from inserted));
	set @a3 = rtrim((select [GENDER] from inserted));
	set @a4 = rtrim((select [PULPIT] from inserted));
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
	set @a1 = (select [TEACHER] from deleted);
	set @a2 = rtrim((select [TEACHER_NAME] from deleted));
	set @a3 = rtrim((select [GENDER] from deleted));
	set @a4 = rtrim((select [PULPIT] from deleted));
	set @in = @a1 + ' ' + @a2 + ' ' + @a3 + ' '+ @a4 ;
	insert into TR_AUDIT(ST,TRN,C) values ('UPD','TR_TEACHER_UPD',@in);
end;  
return;  

insert into TEACHER values('ЛДИ','Лешук Дмитрий Игорьевич','ж','ИСиТ');
update TEACHER set TEACHER.GENDER = 'н' where TEACHER like 'ЛДИ'
delete  from TEACHER where TEACHER like'ЛДИ'
select * from TEACHER where TEACHER like 'ЛДИ'
select * from TR_AUDIT

-- Task 5 
insert into TEACHER values('ЛДИ','Лешук Дмитрий Игорьевич','ж','ИСиТ');
update TEACHER set TEACHER.GENDER = 'н' where TEACHER like 'ЛДИ'
select * from TEACHER where TEACHER like 'ЛДИ'
select * from TR_AUDIT

-- Task 6

create trigger TR_TEACHER_UPDA on TEACHER after UPDATE  
       as print 'AUD_AFTER_UPDATE_A';
 return;  
go 
create trigger TR_TEACHER_UPDB on TEACHER after UPDATE  
       as print 'AUD_AFTER_UPDATE_B';
return;  
go  
create trigger TR_TEACHER_UPDC on TEACHER after UPDATE  
       as print 'AUD_AFTER_UPDATE_C';
 return;  
go

select t.name, e.type_desc 
         from sys.triggers  t join  sys.trigger_events e  
                  on t.object_id = e.object_id  
                            where OBJECT_NAME(t.parent_id) = 'TEACHER' and 
	                                               e.type_desc = 'UPDATE';  
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_UPD', 
	                        @order = 'First', @stmttype = 'UPDATE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_UPDA', 
	                        @order = 'Last', @stmttype = 'UPDATE';

update TEACHER set TEACHER.GENDER = 'м' where TEACHER like 'ЛДИ'

-- Task 7
select * from PROGRESS
create trigger TR_PROGRESS 
		on PROGRESS after INSERT,DELETE,UPDATE
		as declare @c int = (select sum(NOTE) from PROGRESS);
if (@c >9)
begin 
raiserror('Общая сумма оценико не может быть больше 9',10,1);
rollback;
end;
return;
update PROGRESS set NOTE = 10 where PROGRESS.IDSTUDENT = 1001

-- Task 8
go 
create trigger TR_FAC_IO 
			on FACULTY instead of DELETE
			as raiserror('Запрещаю удалять',10,1);
return;
delete from FACULTY where FACULTY_NAME = 'ИТ';

drop trigger TR_TEACHER;

-- Task 9
 
drop trigger DDL_UNIVER;
create trigger DDL_UNIVER on database
		for DDL_DATABASE_LEVEL_EVENTS as
declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
  if @t1 = 'TEACHER' 
  begin
       print 'Тип события: '+@t;
       print 'Имя объекта: '+@t1;
       print 'Тип объекта: '+@t2;
       raiserror( N'операции с таблицей Товары запрещены', 16, 1);  
       rollback;    
   end;

select * from TEACHER;

alter table TEACHER drop column TEACHER_NAME