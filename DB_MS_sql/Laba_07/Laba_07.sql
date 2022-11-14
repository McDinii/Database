use UNIVER;
-- Task 1
CREATE VIEW [Teacher_view]
		as select T.TEACHER [Cod], T.TEACHER_NAME [Name], T.GENDER [Gender], T.PULPIT [Pulpit] 
		from TEACHER T 
Select * from Teacher_view  order by [Name] DESC
-- Alter view
-- Drop view

-- Task 2
Create view [Cnt_pulpit]
		as select F.FACULTY_NAME [Fac],(select count(*)from PULPIT P where P.FACULTY = F.FACULTY) [Cnt_pulpits]
		from FACULTY F
alter view [Cnt_pulpit]
		as select F.FACULTY_NAME [Fac], count(P.PULPIT_NAME) [Cnt_pulpits]
		from FACULTY F join PULPIT P on P.FACULTY = F.FACULTY 
		group by F.FACULTY_NAME

select * from PULPIT order by FACULTY
select * from [Cnt_pulpit] order by Cnt_pulpits DESC

--Task 3
Drop view Auds
Create view Auds(Au_cod,Name) 
		as select A.AUDITORIUM ,A.AUDITORIUM_NAME 
		from AUDITORIUM A
		where A.AUDITORIUM_TYPE like 'À %'
select * from AUDITORIUM
Select * from [Auds]
insert [Auds] values('114-1', '114-1');
insert [Auds] values('138-2', '138-2');
delete AUDITORIUM where AUDITORIUM.AUDITORIUM like '138-2%' or AUDITORIUM like '137-1%' or AUDITORIUM like '136-1%';
update Auds set Au_cod = '666-06', Name = '666-06' where Au_cod = N'114-1';
select * from Auds;

--Task 4
Create view Lectures_Auds(Au_cod,Name) 
		as select A.AUDITORIUM ,A.AUDITORIUM_NAME 
		from AUDITORIUM A
		where A.AUDITORIUM_TYPE like 'À '
Alter view Lectures_Auds(Type,Au_cod,Name) 
		as select A.AUDITORIUM_TYPE ,A.AUDITORIUM ,A.AUDITORIUM_NAME 
		from AUDITORIUM A
		where A.AUDITORIUM_TYPE like 'À ' With check option
Select * from [Lectures_Auds]
insert Lectures_Auds values('À ','102-3a', '102-3a');
insert Lectures_Auds values('À¡','135-1', '135-1');
delete Lectures_Auds where [Au_cod] = '102-1%';
update Lectures_Auds set Type = 'À ' where Au_cod = '102-3a';
select * from Lectures_Auds;

-- Task 5
Create view Subjs(Cod,SubjsName,pulpitcod)
	as select Top 10 S.SUBJECT,S.SUBJECT_NAME,S.PULPIT from SUBJECT S
	order by SUBJECT_NAME
Alter view Subjs(Cod,SubjsName,pulpitcod)
	as select Top 12 S.SUBJECT,S.SUBJECT_NAME,S.PULPIT from SUBJECT S
	order by SUBJECT_NAME
select * from Subjs

--Task 6
Alter view [Cnt_pulpit] With Schemabinding
		as select F.FACULTY_NAME [Fac], count(P.PULPIT_NAME) [Cnt_pulpits]
		from FACULTY F
		join PULPIT P on P.FACULTY = F.FACULTY 
		group by F.FACULTY_NAME
select * from [Cnt_pulpit];


sp_help [Cnt_pulpit];
