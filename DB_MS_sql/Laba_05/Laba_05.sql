use UNIVER;
--Лаба5 
--Задание 1,2,3
Select PUL.PULPIT_NAME[Кафедра], FAC.FACULTY[Факультет],PRF.PROFESSION_NAME from FACULTY as FAC, PULPIT as PUL, PROFESSION as PRF 
where PUL.FACULTY = FAC.FACULTY
		and PRF.PROFESSION_NAME IN (Select PRF.PROFESSION_NAME 
		from PROFESSION
		where (PRF.PROFESSION_NAME 
		Like '%технология%' 
		or  PRF.PROFESSION_NAME  Like '%технологии%'));

Select PUL.PULPIT_NAME[Кафедра], FAC.FACULTY[Факультет],PRF.PROFESSION_NAME 
from PROFESSION as PRF, FACULTY as FAC 
JOIN  PULPIT as PUL ON PUL.FACULTY = FAC.FACULTY
		WHERE PRF.PROFESSION_NAME IN (Select PRF.PROFESSION_NAME 
		from PROFESSION
		where (PRF.PROFESSION_NAME 
		Like '%технология%' 
		or  PRF.PROFESSION_NAME  Like '%технологии%'));

Select PUL.PULPIT_NAME[Кафедра], FAC.FACULTY[Факультет],PRF.PROFESSION_NAME 
from  FACULTY as FAC 
JOIN  PULPIT as PUL ON  FAC.FACULTY = PUL.FACULTY
JOIN PROFESSION as PRF  ON 
		PRF.PROFESSION_NAME 
		Like '%технология%' 
		or  PRF.PROFESSION_NAME  Like '%технологии%';

-- Задание 4
use UNIVER;
select AUDITORIUM_TYPE[Тип аудитории],AUDITORIUM[Ауд.], AUDITORIUM_CAPACITY[Вместимость] 
from AUDITORIUM as AUD
where AUD.AUDITORIUM_CAPACITY  = 
(select top(1) AUD2.AUDITORIUM_CAPACITY from AUDITORIUM as AUD2
where AUD2.AUDITORIUM_TYPE = AUD.AUDITORIUM_TYPE
ORDER BY AUD2.AUDITORIUM_CAPACITY DESC);  

-- Задание 5 

Select F.FACULTY[Фак],[Кафедры] = Null from FACULTY as F
where not exists (select P.PULPIT_NAME from PULPIT as P where P.FACULTY = F.FACULTY)  

-- Задание 6 
Select top(1)
(select avg(PROGRESS.NOTE) from PROGRESS 
	where PROGRESS.SUBJECT like 'ОАиП')[ОАиП cредняя],
(select avg(PROGRESS.NOTE) from PROGRESS 
	where PROGRESS.SUBJECT like 'БД')[БД средняя],
(select avg(PROGRESS.NOTE) from PROGRESS 
	where PROGRESS.SUBJECT like 'СУБД')[СУБД средняя]
from PROGRESS 

-- Задание 7 
Select A.AUDITORIUM[АУД],A.AUDITORIUM_TYPE[Тип], A.AUDITORIUM_CAPACITY[Вместимость]
from AUDITORIUM A 
where AUDITORIUM_CAPACITY >= ALL(select A2.AUDITORIUM_CAPACITY from AUDITORIUM as A2
where A2.AUDITORIUM_TYPE like 'ЛБ%') and A.AUDITORIUM_TYPE not like 'ЛБ%';

--Задание 8 
Select A.AUDITORIUM[АУД],A.AUDITORIUM_TYPE[Тип], A.AUDITORIUM_CAPACITY[Вместимость]
from AUDITORIUM A 
where AUDITORIUM_CAPACITY > ANY(select A2.AUDITORIUM_CAPACITY from AUDITORIUM as A2
where A2.AUDITORIUM_TYPE like 'ЛБ%') and A.AUDITORIUM_TYPE not like 'ЛБ%';

--Задание 10*
select DISTINCT S.NAME[Имя1],S.BDAY[ДР] 
from STUDENT S  join  STUDENT S2 on  RIGHT(S2.BDAY,5) = RIGHT(S.BDAY,5) and S2.NAME <> S.NAME 
ORDER by S.BDAY
