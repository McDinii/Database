USE [master]
GO
CREATE DATABASE [Nechay_MyBase]
 ON  PRIMARY 
( NAME = N'Nechay_MyBase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Nechay_MyBase.mdf' , 
SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
 
 FILEGROUP [FG_1]
(NAME = 'FG_1', FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Nechay_MyBase_FG_1.ndf',
SIZE = 8192KB, MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB),
(NAME = 'FG_1_2', FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Nechay_MyBase_FG_1_2.ndf',
SIZE = 8192KB, MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB)
LOG ON 
( NAME = N'Nechay_MyBase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Nechay_MyBase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB );
GO
ALTER DATABASE Nechay_MyBase
	MODIFY FILEGROUP FG_1 DEFAULT;
GO
use [Nechay_MyBase]
GO
create table ������(
��������_�������  varchar(20) not null primary key,
����_����� float(10) not null,
����������_������ int not null) ON FG_1;

CREATE table �����������_�������(
���������_�����_id int not null primary key, 
��������_������ varchar(20) not null,
����������_����� int, 
����_������� real,);

CREATE table ������(
�����_id int not null primary key,
���_������ int not null,
�����_��������� varchar(20),
�����_��������� varchar(20),
�����_���� varchar(20));
CREATE table �����������_���������(
��������_info_id int not null primary key, 
��������_������ varchar(20) not null,
����������_����� int, 
����_������� real,
��� varchar(20) not null,
�������� varchar(20),
������� int , 
E_mail varchar(20),
������ bit,
�����_id int not null foreign key references 
								������(�����_id));
CREATE table ���������(
��������_id int not null primary key,
������� varchar(20) not null,
��������������_����_�_��������� int foreign key references �����������_���������(��������_info_id)
);

CREATE table ������(
������_������ int not null primary key,
����_������ date,
�������� int  foreign key references ���������(��������_id) not null,
����������� int foreign key references �����������_�������(���������_�����_id));









ALTER TABLE �����������_������� DROP Column ��������_������;


ALTER TABLE �����������_������� ADD �������_������ varchar(20);
ALTER TABLE �����������_������� DROP Column �������_������;
ALTER TABLE �����������_������� ADD �������_������� varchar(20) foreign key references ������(��������_�������);

use Nechay_MyBase;
INSERT into ������ 
	values
			('Airpods',399.99,100),
			('Apple tag',49.99,110),
			('iMac',2999,140),
			('iPad',599.99,120),
			('iPhone',799.6,200);
ALTER TABLE ������ DROP COLUMN ���_������;
INSERT into ������
	values
			(1,'������','��������',41),
			(2,'Prague','Avenue',8),
			(3,'�����','�����������',77),
			(4,'����������','���������',4);
ALTER TABLE �����������_��������� DROP COLUMN ��������_������,����������_�����,����_�������;
ALTER TABLE �����������_��������� ALTER COLUMN ������� bigint; 
INSERT into �����������_���������
	values
			(1,'�����','��������','375293534533','deni@gmail.com',1,1),
			(2,'������','��������','375297734533','anii@gmail.com',0,2),
			(3,'������',Null,'375293538511','ennii@gmail.com',0,3),
			(4,'������','��������','375293534590','dimmi@gmail.com',1,4);

INSERT into ���������
	values
			(1,'���������',1),
			(2,'�������',2),
			(3,'��������',3),
			(4,'���������',4);

INSERT into �����������_������� 
	values
			(1,20,3199,'iMac'),
			(2,49,499.99,'AirPods'),
			(3,30,799.99,'iPad'),
			(4,99,850,'iPhone');
INSERT into ������ 
	values
			(1,'09-12-2022',2,1),
			(3,'09-12-2021',1,2),
			(2,'01-01-2022',4,3),
			(4,'03-03-2019',3,4);










SELECT * from ������,�����������_�������
WHERE ����������� = ���������_�����_id ;



SELECT * from ������;
EXEC sp_rename '������.����_������', '����_�������', 'COLUMN';
EXEC sp_rename '������.����������_������', '����������_�������', 'COLUMN';
SELECT ��������_������� as '��������',����_������� as '����' from ������;
SELECT count(��������_�������)[����� ������� ������� �������] From ������
WHERE ����_������� < 1000.0; 
SELECT ��������_�������[������� ������], ����_�������[����], ����������_�������[����������] From ������
WHERE ����_������� < 1000.0 ORDER BY ����;  
SELECT DISTINCT Top(2) ��������_�������[Top 2 ������� ������] From ������
WHERE ����_������� < 1000.0; 



SELECT ��������_������� as '��������',����_������� as '����' from ������;
UPDATE ������ set ����_������� = ����_������� * 10 WHERE ��������_�������='iPhone';
SELECT ��������_������� as '��������',����_������� as '����' from ������;
DELETE from ������ WHERE ��������_������� = 'Apple Tag';
Select * from ������;



SELECT ��������_������� as '��������', ����_������� as '����', ����������_�������[���-��] from ������ 
where (��������_������� Like 'i%' and ����_������� Between 100 and 1000) 
or ����������_������� In(10,140);


