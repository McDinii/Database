use UNIVER;
-- Задание 1

select min(A.AUDITORIUM_CAPACITY) MIN_cap, max(A.AUDITORIUM_CAPACITY) MAX_cap,
avg(A.AUDITORIUM_CAPACITY) AVG_cap, sum(A.AUDITORIUM_CAPACITY) SUM_cap, count(*) CNT_cap
from AUDITORIUM [A] 

-- Задание 2
select AT.AUDITORIUM_TYPE [Тype], min(A.AUDITORIUM_CAPACITY) MIN_cap, max(A.AUDITORIUM_CAPACITY) MAX_cap,
avg(A.AUDITORIUM_CAPACITY) AVG_cap, sum(A.AUDITORIUM_CAPACITY) SUM_cap, count(A.AUDITORIUM) CNT 
from AUDITORIUM_TYPE AT left join AUDITORIUM A 
on A.AUDITORIUM_TYPE = AT.AUDITORIUM_TYPE Group by AT.AUDITORIUM_TYPE ORDER BY MAX_cap DESC
select AUDITORIUM.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM_CAPACITY from AUDITORIUM 
order by AUDITORIUM.AUDITORIUM_TYPE

-- Задание 3
insert into PROGRESS values ('ОАиП',1024,'2012-02-12',10)
insert into PROGRESS values ('КГ',1025,'2012-03-12',2)
select count(*)  from PROGRESS
Select *  From (select case when P.NOTE in(10) then '10'
			when P.NOTE between 8 and 9 then '8-9'
			when P.NOTE between 6 and 7 then '6-7'
			when P.NOTE between 4 and 5 then '4-5'
			else '<4'
			end [Marks], Count(*) [Cnt] 
		from PROGRESS P Group by case when P.NOTE in(10) then '10'
			when P.NOTE between 8 and 9 then '8-9'
			when P.NOTE between 6 and 7 then '6-7'
			when P.NOTE between 4 and 5 then '4-5'
			else '<4'
			end ) as T
		order by Case Marks when '10' then 0
			when '8-9' then 1
			when '6-7' then 2
			when '4-5' then 3
			else 4
			end
-- Задание 4
select F.FACULTY, G.PROFESSION, Course,round(avg(cast(NOTE as float(4))),2) Avg_mark, G.IDGROUP 
from FACULTY F
join GROUPS G on F.FACULTY = G.FACULTY
join (select case when G1.YEAR_FIRST = '2013' then '4'
			when G1.YEAR_FIRST = '2012' then '3'
			when G1.YEAR_FIRST = '2011' then '2'
			when G1.YEAR_FIRST = '2010' then '1'
			end [Course],G1.IDGROUP [CRS_ID] from GROUPS G1) as Course on G.IDGROUP = Course.CRS_ID
join STUDENT S on S.IDGROUP = G.IDGROUP
join PROGRESS on S.IDSTUDENT = PROGRESS.IDSTUDENT 
group by F.FACULTY,G.IDGROUP,G.PROFESSION,Course

select F.FACULTY, G.PROFESSION, Course,round(avg(cast(NOTE as float(4))),2) Avg_mark, G.IDGROUP 
from FACULTY F
join GROUPS G on F.FACULTY = G.FACULTY
join (select case when G1.YEAR_FIRST = '2013' then '4'
			when G1.YEAR_FIRST = '2012' then '3'
			when G1.YEAR_FIRST = '2011' then '2'
			when G1.YEAR_FIRST = '2010' then '1'
			end [Course],G1.IDGROUP [CRS_ID] from GROUPS G1) as Course on G.IDGROUP = Course.CRS_ID
join STUDENT S on S.IDGROUP = G.IDGROUP
join PROGRESS P on S.IDSTUDENT = P.IDSTUDENT and P.SUBJECT in ('ОАиП','БД')
group by F.FACULTY,G.IDGROUP,G.PROFESSION,Course
-- Задание 5
select F.FACULTY, G.PROFESSION, P.SUBJECT,round(avg(cast(NOTE as float(4))),2) Avg_mark
from FACULTY F
join GROUPS G on F.FACULTY = G.FACULTY
join STUDENT S on S.IDGROUP = G.IDGROUP
join PROGRESS P on S.IDSTUDENT = P.IDSTUDENT
where F.FACULTY = 'ИДиП'
group by F.FACULTY, G.PROFESSION , P.SUBJECT

select F.FACULTY, G.PROFESSION, P.SUBJECT,round(avg(cast(NOTE as float(4))),2) Avg_mark,
GROUPING(F.FACULTY) Summary_fac,GROUPING(G.PROFESSION) Summary_gr,GROUPING(P.SUBJECT) Summary_sub
from FACULTY F
join GROUPS G on F.FACULTY = G.FACULTY
join STUDENT S on S.IDGROUP = G.IDGROUP
join PROGRESS P on S.IDSTUDENT = P.IDSTUDENT
where F.FACULTY = 'ИДиП' 
group by ROLLUP( F.FACULTY, G.PROFESSION , P.SUBJECT)
-- Задание 6
select F.FACULTY, G.PROFESSION, P.SUBJECT,round(avg(cast(NOTE as float(4))),2) Avg_mark,
GROUPING(F.FACULTY) Summary_fac,GROUPING(G.PROFESSION) Summary_gr,GROUPING(P.SUBJECT) Summary_sub
from FACULTY F
join GROUPS G on F.FACULTY = G.FACULTY
join STUDENT S on S.IDGROUP = G.IDGROUP
join PROGRESS P on S.IDSTUDENT = P.IDSTUDENT
where F.FACULTY = 'ИДиП' 
group by CUBE( F.FACULTY, G.PROFESSION , P.SUBJECT)

-- Задание 7
Select F.FACULTY,G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ИДиП'
group by G.PROFESSION,P.SUBJECT,F.FACULTY
union
Select F.FACULTY,G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ТОВ'
group by G.PROFESSION,P.SUBJECT,F.FACULTY

Select F.FACULTY,G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ИДиП'
group by G.PROFESSION,P.SUBJECT,F.FACULTY
union all
Select F.FACULTY,G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ТОВ'
group by G.PROFESSION,P.SUBJECT,F.FACULTY


Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ИДиП'
group by G.PROFESSION,P.SUBJECT
union
Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ТОВ'
group by G.PROFESSION,P.SUBJECT

Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ИДиП'
group by G.PROFESSION,P.SUBJECT
union all
Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ТОВ'
group by G.PROFESSION,P.SUBJECT

-- Задание 8
Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ИДиП'
group by G.PROFESSION,P.SUBJECT
INTERSECT -- INERSECT
Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ТОВ'
group by G.PROFESSION,P.SUBJECT

-- Задание 9
Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ИДиП'
group by G.PROFESSION,P.SUBJECT
EXCEPT -- EXCEPT
Select G.PROFESSION,P.SUBJECT, round(avg(cast(NOTE as float(4))),2) Avg_
from FACULTY F join GROUPS G on G.FACULTY = F.FACULTY join STUDENT S on S.IDGROUP = g.IDGROUP
join PROGRESS P  on P.IDSTUDENT = S.IDSTUDENT where F.FACULTY = 'ТОВ'
group by G.PROFESSION,P.SUBJECT

-- Задание 10
select p.NOTE, P.SUbject from PROGRESS p
select P1.SUBJECT, P1.NOTE,
(select count(*) from PROGRESS P2 where P2.SUBJECT = P1.SUBJECT and P2.NOTE  = P1.NOTE) CNT
from PROGRESS P1
group by P1.SUBJECT, P1.NOTE
having P1.NOTE = 8 or P1.NOTE = 9