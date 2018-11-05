--DB Settings

create database smartservice

--Wie groß ist diese DB?
--zwischen 5 (2008) bis 16 MB (SQL 2016)

--News: seit SQL 2016 SP1 sind viele Ent. Features
--auch in den kleineren Versionen

--Was passiert, wenn die DB wächst?
--Wachstumsrate: bis SQL 2014 1 MB für Datendatei


use smartservice;
GO

--Tabelle anlegen

--wie groß darf eine Zelle sein?
--max 2 GB

create table t1 (id int identity, sp1 char(4100), sp2 char(4100));

create table t1 (id int identity, sp char(4100));
GO

--jetzt kommen 20000 DS rein
set statistics io, time off

declare @i as int = 0

while @i < 20000
	BEGIN
		insert into t1 values('XY')
		set @i+=1
	END

--8 Sekunden; 


dbcc showcontig('t1')

--statt 20000* 4 Kb nun 20000 * 8kb
----Seite nur zu 50,79% gefüllt

--statt 80MB Daten im RAM nun 160MB im RAM

--abgesehen vom dummen Datentyp ..nvarchar(50), nchar(50)

--Warum hier 8 Sek..????
--155*4ms


create table t5 (id int identity, sp1 char(4100))

declare @i as int = 0

--begin tran
while @i < 20000
	BEGIN
		insert into t5 values('XY')
		set @i+=1
	END
--COMMIT



--Aufwand für Transaktionen sehr hoch..







use northwind
--aus dem Jahr 1997
select * from orders
where year(orderdate) = 1997

where orderdate > '1.1.1997' and orderdate <'1.1.1998'


where between '1.1.1997' and '31.12.1997 23:59:59.999'




select * from b1 --kein Table Scan?!

--wg doofen PK.. der immer gleich als CL IX angelegt
--muss aber nicht sein:  non cl ix eindeutig



SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, Orders.ShipCountry, 
                         [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Products.ProductName, Products.UnitsInStock, Employees.LastName, Employees.FirstName, 
                         Employees.BirthDate, Employees.Title
into umsatz
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID

insert into umsatz
select * from umsatz



select * from sys.messages

select * from sys.dm_os_wait_stats


select * into mess from sys.messages

insert into mess
select * from mess

select count(*) from mess
--1,1 MIO

select top 1 * from mess

dbcc showcontig('mess') --veraltet..

--TABLE SCAN.. kein CL IX...
select * from mess where message_id = 271 --36394

set statistics io, time on

alter table mess add messid int identity

dbcc showcontig('mess') --veraltet..--jetzt 37060

select * from mess where message_id = 271 --60988

select * from sys.dm_db_index_physical_Stats(db_id(),object_id('mess'), NULL, NULL, 'detailed')

--CL IX rein und wieder weg
--37510


select top 1 * from mess

--CL IX Spalte: vermutlich severity

select messid from mess where messid = 100--noch Table Scan.. 37000 Seiten


--NCL_messid
--jetzt 0 ms... 3 Seiten


select messid, language_id from mess where messid =100

--Lookup vermeiden
--NCL_messID_LangID
--reiner Seek ohne Lookup
select messid, language_id, is_event_logged  from mess where messid =100 --3 Seiten

--wieviele Indizes?
A B C

A
B
C
AB
AC
BA
BC
ABC
ACB
BAC
BCA
CAB
CBA
---1023


select * from sys.dm_db_index_usage_Stats


select language_id, messid from mess where 

--NIX_DEMO enthält alle (1,1 Mio) Datensätze
select language_id from mess where message_id= 26078 and severity = 20

--NIX_DEMO nur mit DS severity = 20

select language_id from mess 
with (index (NIX_FILTER))
where message_id= 26078 and severity = 20


select language_id from mess 
where message_id= 26078 or severity = 20



select language_id from mess where message_id= 26078 and severity = 20

















