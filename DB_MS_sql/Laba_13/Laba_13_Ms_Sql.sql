use UNIVER;
-- Task 1
go 
create function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(IDSTUDENT) from STUDENT S join GROUPS G on S.IDGROUP = G.IDGROUP 
							join FACULTY F on G.FACULTY = F.FACULTY 
								where F.FACULTY = @faculty);
return @rc; 
end
declare @f int = dbo.COUNT_STUDENTS('ТОВ');
print 'Кол-во студентов = ' + cast(@f as varchar(4));

alter function COUNT_STUDENTS (@faculty varchar(20) = null, @prof varchar(20) = null)
	returns int
	as begin declare  @rc int = 0;
	if @prof is null
		set @rc =  (select count(IDSTUDENT) from STUDENT S 
						join GROUPS G on S.IDGROUP = G.IDGROUP
						join FACULTY F on G.FACULTY = F.FACULTY 
							where F.FACULTY = @faculty);
	else 
	set @rc =(select count(IDSTUDENT) from STUDENT S 
						join GROUPS G on S.IDGROUP = G.IDGROUP
						where G.PROFESSION = @prof);
	return @rc;
	end;
declare @fp int = dbo.COUNT_STUDENTS(default,'1-36 01 08')
print 'Кол-во студентов = ' + cast(@fp as varchar(4));
select F.FACULTY, dbo.COUNT_STUDENTS(F.FACULTY, default) from FACULTY F

-- Task 2
drop function FSUBJECTS
create function FSUBJECTS (@p VARCHAR(20))
	returns VARCHAR(300)
	as begin 
	declare  @s char(20);
	declare @a varchar(300) = 'Перечень дисциплин: ';
	declare CSUBJECTS cursor local
	for select S.SUBJECT from SUBJECT S  where S.PULPIT = @p;
	open CSUBJECTS;
	fetch CSUBJECTS into @s;
	while @@FETCH_STATUS = 0
	begin set @a = @a  + RTRIM(@s)+ ',';
	fetch CSUBJECTS into @s;
	end;
	return @a;
	end;
select P.PULPIT, dbo.FSUBJECTS(PULPIT) from PULPIT P

-- Task 3
create function FFACPUL (@ff varchar(20), @pp varchar(20))
												returns table
as return 
select F.FACULTY , P.PULPIT from FACULTY F 
										left join PULPIT P on P.FACULTY = F.FACULTY
										where F.FACULTY = isnull(@ff,F.FACULTY)
										and P.PULPIT = isnull(@pp, P.PULPIT);
select * from dbo.FFACPUL(NULL,NULL);
select * from dbo.FFACPUL('ТОВ',NULL);
select * from dbo.FFACPUL(NULL,'ОХ');
select * from dbo.FFACPUL('ТОВ','ХПД');

-- Task 4 
drop function  FCTEACHER;
create function FCTEACHER(@p varchar(20)) returns int
as begin 
	declare @rc int  = (select count(*) from TEACHER T
			where PULPIT = ISNULL(@p,PULPIT));
			return @rc;
	end;

select PULPIT,dbo.FCTEACHER(PULPIT) [Кол-во преподавателей] from PULPIT
select dbo.FCTEACHER(NULL) [Всего преподавателей] 

-- Task 5 
	create function C_PULPITS(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(PULPIT) from PULPIT where PULPIT.FACULTY = @f);
return @rc; 
end;
create function C_GROUPS(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(GROUPS.FACULTY) from GROUPS where GROUPS.FACULTY = @f);
return @rc; 
end;
create function C_PROF(@f varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select count(PROFESSION) from PROFESSION where FACULTY = @f );
return @rc; 
end;
drop function FACULTY_REPORT;
	create function FACULTY_REPORT(@c int)
	returns @fr table
	                        ( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
	                                                                 [Количество студентов] int, [Количество специальностей] int )
	as begin 
                 declare cc CURSOR static for 
	       select FACULTY from FACULTY 
                                                    where dbo.COUNT_STUDENTS(FACULTY, default) > @c; 
	       declare @f varchar(30);
	       open cc;  
                 fetch cc into @f;
	       while @@fetch_status = 0
	       begin
	            insert @fr values( @f, dbo.C_PULPITS(@f),
	            dbo.C_GROUPS(@f),   dbo.COUNT_STUDENTS(@f, default),
	              dbo.C_PROF(@f)); 
	            fetch cc into @f;  
	       end;   
                 return; 
	end;
	select * from FACULTY_REPORT(15)