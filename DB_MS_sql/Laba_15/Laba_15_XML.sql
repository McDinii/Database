-- Task 1
use UNIVER;
select * from [UNIVER].[dbo].[TEACHER]
		where [UNIVER].[dbo].[TEACHER].[PULPIT] = 'ИСиТ'
		for xml PATH('Учитель'),
		root('Список_учитель'), elements;
-- Task 2
select AUD.AUDITORIUM_NAME [Ауд],AUD_T.AUDITORIUM_TYPE[Тип],AUDITORIUM_CAPACITY[Вместимость]
from AUDITORIUM AUD join AUDITORIUM_TYPE AUD_T 
on AUD.AUDITORIUM_TYPE = AUD_T.AUDITORIUM_TYPE
where AUD.AUDITORIUM_TYPE like '%ЛК%'
order by AUD.AUDITORIUM_CAPACITY for xml AUTO,
root('Список_лк_аудиторий'),elements;

-- Task 3
select * from PULPIT
--insert into PULPIT values('M','Математики','ИТ'),('F','Физики','ИТ'),('En','Английского языка','ИТ'); 
select * from subject;
declare @h int= 0,
@x varchar(2000)='
	   <?xml version="1.0" encoding = "windows-1251" ?>
       <subjects> 
       <subj SUBJECT="DEN" SUBJECT_NAME="Delovoienglish" PULPIT="En"/> 
	   <subj SUBJECT="TV" SUBJECT_NAME="Theoryver" PULPIT="M"/> 
	   <subj SUBJECT="AF" SUBJECT_NAME="Atom_fisika" PULPIT="F"/> 
       </subjects>';
exec sp_xml_preparedocument @h output, @x;  -- подготовка документа 
insert SUBJECT select [SUBJECT], [SUBJECT_NAME], [PULPIT] 
                   from openxml(@h, '/subjects/subj', 0)     
       with([SUBJECT] nvarchar(20), [SUBJECT_NAME] varchar(30), [PULPIT] nvarchar(20))    

    select * from openxml(@h, '/subjects/subj', 0)
       with([SUBJECT] nvarchar(20), [SUBJECT_NAME] varchar(30), [PULPIT] nvarchar(20))    
    exec sp_xml_removedocument @h; 
	
-- Task 4
select * from STUDENT
insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(2, N'Лешук Дмитрий Степаныч', cast('2003-12-12' as date), 
N'<Контактная_информация>
<Паспортные_данные>
<Серия>HB</Серия>
<Номер_паспорта>2252523</Номер_паспорта>
<Дата_выдачи>2009.10.11
</Дата_выдачи>
</Паспортные_данные>
<Адрес>
<Страна>Беларусь</Страна>
<Город>Барановичи</Город>
<Улица>Наконечникова</Улица>
</Адрес>
</Контактная_информация>')

update STUDENT set INFO = N'<Контактная_информация>
<Паспортные_данные>
<Серия>МР</Серия>
<Номер_паспорта>7123591</Номер_паспорта>
<Дата_выдачи>2018.03.09
</Дата_выдачи>
</Паспортные_данные>
<Адрес>
<Страна>Россия</Страна>
<Город>Москва</Город>
<Улица>Дубининская</Улица>
</Адрес>
</Контактная_информация>'
where IDSTUDENT = 2098


select STUDENT.NAME,
	INFO.value(N'(/Контактная_информация/Паспортные_данные/Серия)[1]',N'nvarchar(20)')[Серия],
	INFO.value(N'(/Контактная_информация/Паспортные_данные/Номер_паспорта)[1]',N'nvarchar(20)')[Номер],
	INFO.query(N'/Контактная_информация/Адрес') [Адрес]
from STUDENT
where INFO is not null

-- Task 5 
drop xml schema collection STUDENT;

CREATE XML SCHEMA COLLECTION STUDENT1 AS
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault = "unqualified"
elementFormDefault="qualified"
xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="Контактная_информация">
<xs:complexType>
<xs:sequence>
<xs:element name="Паспортные_данные" maxOccurs="1" minOccurs="1">
<xs:complexType>
<xs:sequence>
<xs:element name="Серия" type="xs:string"/>
<xs:element name="Номер_паспорта" type="xs:integer"/>
<xs:element name="Дата_выдачи" type="xs:string"/>
</xs:sequence>
</xs:complexType>
</xs:element>
<xs:element name="Адрес">
<xs:complexType>
<xs:sequence>
<xs:element name="Страна" type="xs:string"/>
<xs:element name="Город" type="xs:string"/>
<xs:element name="Улица" type="xs:string"/>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:schema>';

alter table STUDENT ALTER COLUMN INFO xml(STUDENT1)
insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(51, N'Пекарев Ефросий Евгеньевич', cast('30-08-2002' as date), 
N'<Контактная_информация>
<Паспортные_данные>
<Серия>МР</Серия>
<Номер_паспорта>8974521</Номер_паспорта>
<Дата_выдачи>2018.04.04
</Дата_выдачи>
</Паспортные_данные>
<Адрес>
<Страна>Россия</Страна>
<Город>Урюпинск</Город>
<Улица>Ленина</Улица>
</Адрес>
</Контактная_информация>')

select * from STUDENT where NAME = N'Пекарев Ефросий Евгеньевич'

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(51, N'Беков Магомед Иванович', cast('06-07-1999' as date), 
N'<Контактная_информация>
<Паспортные_данные>
<Серия>МР</Серия>
<Номер_паспорта>6712817</Номер_паспорта>
<Дата_выдачи>2015.09.09
</Дата_выдачи>
</Паспортные_данные>
<Паспортные_данные>
<Серия>МР</Серия>
</Паспортные_данные>
<Адрес>
<Страна>Россия</Страна>
<Город>Уфа</Город>
</Адрес>
</Контактная_информация>')