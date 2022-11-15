-- Task 1
SELECT SUBJECT from SUBJECT
							where SUBJECT.PULPIT like '%ИСиТ%'
deallocate snames
declare @tv char(20), @t char(300)='';
declare SNAMES CURSOR for SELECT SUBJECT from SUBJECT
							where SUBJECT.PULPIT like '%ИСиТ%';
	open SNAMES;
	FETCH SNAMES into @tv;
	print 'Краткие названия';
	while @@FETCH_STATUS = 0
		begin 
		set @t = rtrim(@tv)+',' + @t;
		FETCH SNAMES into @tv;
		end;
	    print @t;
	close SNAMES;

-- Task 2 
Declare Marks cursor local
			for  select PROGRESS.SUBJECT, PROGRESS.NOTE
										from PROGRESS
declare @sb char(20),@mrk real;
	open Marks;
	fetch Marks into @sb,@mrk;
	print '1' + rtrim(@sb) + ':' + cast(@mrk as varchar(6));
	go
declare @sb char(20),@mrk real;
	fetch Marks into @sb,@mrk;
	print '2' + rtrim(@sb) + ':' + cast(@mrk as varchar(6));
	go

Declare Marks cursor global
			for  select PROGRESS.SUBJECT, PROGRESS.NOTE
										from PROGRESS
declare @sb char(20),@mrk real;
	open Marks;
	fetch Marks into @sb,@mrk;
	print '1' + rtrim(@sb) + ':' + cast(@mrk as varchar(6));
	go
declare @sb char(20),@mrk real;
	fetch Marks into @sb,@mrk;
	print '2' + rtrim(@sb) + ':' + cast(@mrk as varchar(6));
	go

-- Task 3
declare @ids int, @gr int, @name nchar(50), @bday date;
declare STDENTS_A1999 CURSOR LOCAL DYNAMIC --DYNAMIC
for select IDSTUDENT, IDGROUP, NAME, BDAY
FROM STUDENT
WHERE BDAY > CAST('1999-01-01' AS date);
open STDENTS_A1999
fetch STDENTS_A1999 INTO @ids, @gr, @name, @bday;
PRINT  N'Количество строк : ' + cast(@@CURSOR_ROWS as varchar(5)); 
update STUDENT set BDAY = cast('1999-09-09' as date) where IDSTUDENT = 1018;
--DELETE STUDENT where STUDENT.NAME = N'Дворянинки Максим Анатольевич';
--INSERT STUDENT(IDGROUP, NAME, BDAY) VALUES (29, N'Дворянинки Максим Анатольевич', cast('1999-09-09' as date));
while @@FETCH_STATUS = 0
begin
print cast(@ids as varchar(5)) + ' ' + cast(@gr as varchar(5)) + ' ' + @name + ' ' + cast(@bday as varchar(15)) + '.';
fetch STDENTS_A1999 INTO @ids, @gr, @name, @bday;
end;
close STDENTS_A1999;

-- Task 4
DECLARE @tc int = 0, @fk nchar(10), @fk_full nchar(55);
declare PRIMER1 cursor local dynamic scroll
for 
select ROW_NUMBER() over (order by FACULTY) N,
FACULTY.FACULTY, FACULTY.FACULTY_NAME
FROM FACULTY;
OPEN PRIMER1;
FETCH first from PRIMER1 into @tc, @fk, @fk_full;
print N'Первая строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH last from PRIMER1 into @tc, @fk, @fk_full;
print N'последняя строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH ABSOLUTE 3 from PRIMER1 into @tc, @fk, @fk_full;
print N'Третья строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH next from PRIMER1 into @tc, @fk, @fk_full;
print N'Следующая строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH prior from PRIMER1 into @tc, @fk, @fk_full;
print N'Предыдущая строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH absolute -2 from PRIMER1 into @tc, @fk, @fk_full;
print N'Вторая строка с конца : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH relative -1 from PRIMER1 into @tc, @fk, @fk_full;
print N'Relative -1 : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);

-- Task 5
declare @one int, @two nchar(10), @thr date, @fur int, @stid int = 1012;
declare PRIMER2 CURSOR LOCAL DYNAMIC
select PROGRESS.IDSTUDENT, PROGRESS.SUBJECT, PROGRESS.PDATE, PROGRESS.NOTE
from PROGRESS inner join STUDENT on  PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP 
WHERE PROGRESS.NOTE < 4
FOR UPDATE;
declare PRIMER3 CURSOR LOCAL DYNAMIC FOR 
SELECT * FROM PROGRESS
WHERE IDSTUDENT = @stid;
OPEN PRIMER2;
fetch PRIMER2 into @one, @two, @thr, @fur;
delete PROGRESS where current of PRIMER2;
close PRIMER2;
open PRIMER3
fetch PRIMER3 into @one, @two, @thr, @fur;
update PROGRESS set NOTE = NOTE + 1 where current of PRIMER3;
close PRIMER3;