-- Task 1
use UNIVER;
select * from [UNIVER].[dbo].[TEACHER]
		where [UNIVER].[dbo].[TEACHER].[PULPIT] = '����'
		for xml PATH('�������'),
		root('������_�������'), elements;
-- Task 2
select AUD.AUDITORIUM_NAME [���],AUD_T.AUDITORIUM_TYPE[���],AUDITORIUM_CAPACITY[�����������]
from AUDITORIUM AUD join AUDITORIUM_TYPE AUD_T 
on AUD.AUDITORIUM_TYPE = AUD_T.AUDITORIUM_TYPE
where AUD.AUDITORIUM_TYPE like '%��%'
order by AUD.AUDITORIUM_CAPACITY for xml AUTO,
root('������_��_���������'),elements;

-- Task 3
select * from PULPIT
--insert into PULPIT values('M','����������','��'),('F','������','��'),('En','����������� �����','��'); 
select * from subject;
declare @h int= 0,
@x varchar(2000)='
	   <?xml version="1.0" encoding = "windows-1251" ?>
       <subjects> 
       <subj SUBJECT="DEN" SUBJECT_NAME="Delovoienglish" PULPIT="En"/> 
	   <subj SUBJECT="TV" SUBJECT_NAME="Theoryver" PULPIT="M"/> 
	   <subj SUBJECT="AF" SUBJECT_NAME="Atom_fisika" PULPIT="F"/> 
       </subjects>';
exec sp_xml_preparedocument @h output, @x;  -- ���������� ��������� 
insert SUBJECT select [SUBJECT], [SUBJECT_NAME], [PULPIT] 
                   from openxml(@h, '/subjects/subj', 0)     
       with([SUBJECT] nvarchar(20), [SUBJECT_NAME] varchar(30), [PULPIT] nvarchar(20))    

    select * from openxml(@h, '/subjects/subj', 0)
       with([SUBJECT] nvarchar(20), [SUBJECT_NAME] varchar(30), [PULPIT] nvarchar(20))    
    exec sp_xml_removedocument @h; 
	
-- Task 4
select * from STUDENT
insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(2, N'����� ������� ��������', cast('2003-12-12' as date), 
N'<����������_����������>
<����������_������>
<�����>HB</�����>
<�����_��������>2252523</�����_��������>
<����_������>2009.10.11
</����_������>
</����������_������>
<�����>
<������>��������</������>
<�����>����������</�����>
<�����>�������������</�����>
</�����>
</����������_����������>')

update STUDENT set INFO = N'<����������_����������>
<����������_������>
<�����>��</�����>
<�����_��������>7123591</�����_��������>
<����_������>2018.03.09
</����_������>
</����������_������>
<�����>
<������>������</������>
<�����>������</�����>
<�����>�����������</�����>
</�����>
</����������_����������>'
where IDSTUDENT = 2098


select STUDENT.NAME,
	INFO.value(N'(/����������_����������/����������_������/�����)[1]',N'nvarchar(20)')[�����],
	INFO.value(N'(/����������_����������/����������_������/�����_��������)[1]',N'nvarchar(20)')[�����],
	INFO.query(N'/����������_����������/�����') [�����]
from STUDENT
where INFO is not null

-- Task 5 
drop xml schema collection STUDENT;

CREATE XML SCHEMA COLLECTION STUDENT1 AS
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault = "unqualified"
elementFormDefault="qualified"
xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="����������_����������">
<xs:complexType>
<xs:sequence>
<xs:element name="����������_������" maxOccurs="1" minOccurs="1">
<xs:complexType>
<xs:sequence>
<xs:element name="�����" type="xs:string"/>
<xs:element name="�����_��������" type="xs:integer"/>
<xs:element name="����_������" type="xs:string"/>
</xs:sequence>
</xs:complexType>
</xs:element>
<xs:element name="�����">
<xs:complexType>
<xs:sequence>
<xs:element name="������" type="xs:string"/>
<xs:element name="�����" type="xs:string"/>
<xs:element name="�����" type="xs:string"/>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:schema>';

alter table STUDENT ALTER COLUMN INFO xml(STUDENT1)
insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(51, N'������� ������� ����������', cast('30-08-2002' as date), 
N'<����������_����������>
<����������_������>
<�����>��</�����>
<�����_��������>8974521</�����_��������>
<����_������>2018.04.04
</����_������>
</����������_������>
<�����>
<������>������</������>
<�����>��������</�����>
<�����>������</�����>
</�����>
</����������_����������>')

select * from STUDENT where NAME = N'������� ������� ����������'

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(51, N'����� ������� ��������', cast('06-07-1999' as date), 
N'<����������_����������>
<����������_������>
<�����>��</�����>
<�����_��������>6712817</�����_��������>
<����_������>2015.09.09
</����_������>
</����������_������>
<����������_������>
<�����>��</�����>
</����������_������>
<�����>
<������>������</������>
<�����>���</�����>
</�����>
</����������_����������>')