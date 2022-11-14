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
create table ТОВАРЫ(
Название_товаров  varchar(20) not null primary key,
Цена_товар float(10) not null,
Количество_товара int not null) ON FG_1;

CREATE table Подробности_заказов(
Подробный_заказ_id int not null primary key, 
Название_товара varchar(20) not null,
Количество_товар int, 
Цена_продажи real,);

CREATE table Адреса(
Адрес_id int not null primary key,
Тип_адреса int not null,
Город_заказчика varchar(20),
Улица_заказчика varchar(20),
Номер_дома varchar(20));
CREATE table Подробности_заказчика(
Заказчик_info_id int not null primary key, 
Название_товара varchar(20) not null,
Количество_товар int, 
Цена_продажи real,
Имя varchar(20) not null,
Отчество varchar(20),
Телефон int , 
E_mail varchar(20),
Скидка bit,
Адрес_id int not null foreign key references 
								Адреса(Адрес_id));
CREATE table Заказчики(
Заказчик_id int not null primary key,
Фамилия varchar(20) not null,
Дополнительная_инфа_о_заказчике int foreign key references Подробности_заказчика(Заказчик_info_id)
);

CREATE table Заказы(
Номера_заказа int not null primary key,
Дата_заказа date,
Заказчик int  foreign key references Заказчики(Заказчик_id) not null,
Подробности int foreign key references Подробности_заказов(Подробный_заказ_id));









ALTER TABLE Подробности_заказов DROP Column Название_товара;


ALTER TABLE Подробности_заказов ADD Артикул_товара varchar(20);
ALTER TABLE Подробности_заказов DROP Column Артикул_товара;
ALTER TABLE Подробности_заказов ADD Артикул_товаров varchar(20) foreign key references ТОВАРЫ(Название_товаров);

use Nechay_MyBase;
INSERT into ТОВАРЫ 
	values
			('Airpods',399.99,100),
			('Apple tag',49.99,110),
			('iMac',2999,140),
			('iPad',599.99,120),
			('iPhone',799.6,200);
ALTER TABLE Адреса DROP COLUMN Тип_адреса;
INSERT into Адреса
	values
			(1,'Гомель','Косарева',41),
			(2,'Prague','Avenue',8),
			(3,'Брест','Шалапутская',77),
			(4,'Барановичи','Диминская',4);
ALTER TABLE Подробности_заказчика DROP COLUMN Название_товара,Количество_товар,Цена_продажи;
ALTER TABLE Подробности_заказчика ALTER COLUMN Телефон bigint; 
INSERT into Подробности_заказчика
	values
			(1,'Денис','Павлович','375293534533','deni@gmail.com',1,1),
			(2,'Андрей','Егорович','375297734533','anii@gmail.com',0,2),
			(3,'Эдуард',Null,'375293538511','ennii@gmail.com',0,3),
			(4,'Димитр','Крутович','375293534590','dimmi@gmail.com',1,4);

INSERT into Заказчики
	values
			(1,'Ненинский',1),
			(2,'Ахрамов',2),
			(3,'Бобрихин',3),
			(4,'Лешукский',4);

INSERT into Подробности_заказов 
	values
			(1,20,3199,'iMac'),
			(2,49,499.99,'AirPods'),
			(3,30,799.99,'iPad'),
			(4,99,850,'iPhone');
INSERT into Заказы 
	values
			(1,'09-12-2022',2,1),
			(3,'09-12-2021',1,2),
			(2,'01-01-2022',4,3),
			(4,'03-03-2019',3,4);










SELECT * from Заказы,Подробности_заказов
WHERE Подробности = Подробный_заказ_id ;



SELECT * from ТОВАРЫ;
EXEC sp_rename 'ТОВАРЫ.Цена_товара', 'Цена_товаров', 'COLUMN';
EXEC sp_rename 'ТОВАРЫ.Количество_товара', 'Количество_товаров', 'COLUMN';
SELECT Название_товаров as 'Название',Цена_товаров as 'Цена' from ТОВАРЫ;
SELECT count(Название_товаров)[Всего товаров Дешевых товаров] From Товары
WHERE Цена_товаров < 1000.0; 
SELECT Название_товаров[Дешевые товары], Цена_товаров[Цена], Количество_товаров[Количество] From Товары
WHERE Цена_товаров < 1000.0 ORDER BY Цена;  
SELECT DISTINCT Top(2) Название_товаров[Top 2 Дешевых товара] From Товары
WHERE Цена_товаров < 1000.0; 



SELECT Название_товаров as 'Название',Цена_товаров as 'Цена' from ТОВАРЫ;
UPDATE ТОВАРЫ set Цена_товаров = Цена_товаров * 10 WHERE Название_товаров='iPhone';
SELECT Название_товаров as 'Название',Цена_товаров as 'Цена' from ТОВАРЫ;
DELETE from ТОВАРЫ WHERE Название_товаров = 'Apple Tag';
Select * from ТОВАРЫ;



SELECT Название_товаров as 'Название', Цена_товаров as 'Цена', Количество_товаров[Кол-во] from ТОВАРЫ 
where (Название_товаров Like 'i%' and Цена_товаров Between 100 and 1000) 
or Количество_товаров In(10,140);


