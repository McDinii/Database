use UNIVER;
--����5 
--������� 1,2,3
Select PUL.PULPIT_NAME[�������], FAC.FACULTY[���������],PRF.PROFESSION_NAME from FACULTY as FAC, PULPIT as PUL, PROFESSION as PRF 
where PUL.FACULTY = FAC.FACULTY
		and PRF.PROFESSION_NAME IN (Select PRF.PROFESSION_NAME 
		from PROFESSION
		where (PRF.PROFESSION_NAME 
		Like '%����������%' 
		or  PRF.PROFESSION_NAME  Like '%����������%'));

Select PUL.PULPIT_NAME[�������], FAC.FACULTY[���������],PRF.PROFESSION_NAME 
from PROFESSION as PRF, FACULTY as FAC 
JOIN  PULPIT as PUL ON PUL.FACULTY = FAC.FACULTY
		WHERE PRF.PROFESSION_NAME IN (Select PRF.PROFESSION_NAME 
		from PROFESSION
		where (PRF.PROFESSION_NAME 
		Like '%����������%' 
		or  PRF.PROFESSION_NAME  Like '%����������%'));

Select PUL.PULPIT_NAME[�������], FAC.FACULTY[���������],PRF.PROFESSION_NAME 
from  FACULTY as FAC 
JOIN  PULPIT as PUL ON  FAC.FACULTY = PUL.FACULTY
JOIN PROFESSION as PRF  ON 
		PRF.PROFESSION_NAME 
		Like '%����������%' 
		or  PRF.PROFESSION_NAME  Like '%����������%';

-- ������� 4
use UNIVER;
select AUDITORIUM_TYPE[��� ���������],AUDITORIUM[���.], AUDITORIUM_CAPACITY[�����������] 
from AUDITORIUM as AUD
where AUD.AUDITORIUM_CAPACITY  = 
(select top(1) AUD2.AUDITORIUM_CAPACITY from AUDITORIUM as AUD2
where AUD2.AUDITORIUM_TYPE = AUD.AUDITORIUM_TYPE
ORDER BY AUD2.AUDITORIUM_CAPACITY DESC);  

-- ������� 5 

Select F.FACULTY[���],[�������] = Null from FACULTY as F
where not exists (select P.PULPIT_NAME from PULPIT as P where P.FACULTY = F.FACULTY)  

-- ������� 6 
Select top(1)
(select avg(PROGRESS.NOTE) from PROGRESS 
	where PROGRESS.SUBJECT like '����')[���� c������],
(select avg(PROGRESS.NOTE) from PROGRESS 
	where PROGRESS.SUBJECT like '��')[�� �������],
(select avg(PROGRESS.NOTE) from PROGRESS 
	where PROGRESS.SUBJECT like '����')[���� �������]
from PROGRESS 

-- ������� 7 
Select A.AUDITORIUM[���],A.AUDITORIUM_TYPE[���], A.AUDITORIUM_CAPACITY[�����������]
from AUDITORIUM A 
where AUDITORIUM_CAPACITY >= ALL(select A2.AUDITORIUM_CAPACITY from AUDITORIUM as A2
where A2.AUDITORIUM_TYPE like '��%') and A.AUDITORIUM_TYPE not like '��%';

--������� 8 
Select A.AUDITORIUM[���],A.AUDITORIUM_TYPE[���], A.AUDITORIUM_CAPACITY[�����������]
from AUDITORIUM A 
where AUDITORIUM_CAPACITY > ANY(select A2.AUDITORIUM_CAPACITY from AUDITORIUM as A2
where A2.AUDITORIUM_TYPE like '��%') and A.AUDITORIUM_TYPE not like '��%';

--������� 10*
select DISTINCT S.NAME[���1],S.BDAY[��] 
from STUDENT S  join  STUDENT S2 on  RIGHT(S2.BDAY,5) = RIGHT(S.BDAY,5) and S2.NAME <> S.NAME 
ORDER by S.BDAY
