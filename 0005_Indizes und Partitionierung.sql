SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, 
                         Orders.ShipCountry, [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Products.ProductName, Products.UnitsInStock, Employees.LastName, 
                         Employees.FirstName, Employees.Title, Employees.BirthDate
INTO UMSATZ
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID


insert into umsatz
select * from umsatz

checkpoint


--Aufgabe Nr

exec gpKundensuche 'A%' --alle Kunden mit A raus

exec gpKundensuche 'AL%' --alle Kunden mit AL raus


exec gpKundensuche 'A%' --alle Kunden 

select customerid from umsatz where customerid ??


select * from umsatz where city = 'Berlin'

create proc gpkundensuche @kdid varchar(5) --'A%'   --> 'A%   '
as
select * from umsatz where customerid like  @kdid


--Test
set statistics io, time on

--NCLIX_customerid
select * from umsatz where customerid like 'ALFKI' 
--6166 ..  63 ms, verstrichene Zeit = 276 ms.

exec gpkundensuche 'ALFKI' --nahezu identisch?

--Problem der Prozedur

select * from umsatz where customerid like '%' --47617 Seiten


select * from umsatz where customerid like 'ALFKI' 
--6166 ..  63 ms, verstrichene Zeit = 276 ms.

exec gpkundensuche '%' --1,1 Mio


dbcc freeproccache

exec gpkundensuche '%' --47000
exec gpkundensuche 'ALFKI' --47000


create proc xy @bit 
as
If @bit = 0
select * from orders where...
else
select * from customers where ..


--Aufgabe.

--aus der Tabelle Umsatz alle Angestellten (Lastname)
--die im Rentenalter sind: 65

select lastname, birthdate from umsatz


declare @wert as int
select @wert = avg(freight) FROM UMSATZ
select * from umsatz freight < @wert






declare @datum as datetime


set @datum ...
select lastname, birthdate from umsatz
where 
	birthdate <  @Datum



select lastname, birthdate from umsatz
where 
	year(birthdate) <= year(getdate()-65)



select lastname, birthdate from umsatz
where 
	datediff(yy, getdate(), birthdate) >= 65


select lastname, birthdate from umsatz
where 
	birthdate <= dateadd(yy,getdate(), -65)


--logischen Fluss
/*
FROM--JOIN--WHERE--GROUP BY--HAVING--
--SELECT --ORDER BY TOP|DISTINCT-->AUSGABE
*/

select lastname as vorname , count(*) as anzahl from umsatz
where 
	country = 'UK' --and vorname like 'A%'
group by lastname having count(*) > 5
order by vorname


select lastname as vorname , count(*) as anzahl from umsatz
 --and vorname like 'A%'
group by lastname having lastname = 'Davolio'
order by vorname








--select * from sys.dm_os_performance_counters where counter_name like '%compi%'
select * from 
	customers c inner join orders o 
	on 
	c.customerid = o.customerid



	select * from umsatz where shipcountry = 'UK' and employeeid = 3






select * from 
	customers c inner loop join orders o 
	on 
	c.customerid = o.customerid


select * from 
	customers c inner hash join orders o 
	on 
	c.customerid = o.customerid
--Welche Tabelle ist schneller?

--A 10000       B: 100000
-- 10DS             10DS

--ca 8 Sek... 

--Salamitaktik


--2 Formen der Partitionierung
--UMSATZ


create table u2018 (id int identity, jahr int, spx int)

create table u2017 (id int identity, jahr int, spx int)


create table u2016 (id int identity, jahr int, spx int)

create table u2015 (id int identity, jahr int, spx int)



select * from umsatz


--VIEW

create view vUmsatz
as
select * from u2018
UNION ALL
select * from u2017
UNION ALL
select * from u2016
UNION ALL
select * from u2015


select * from vumsatz where jahr = 2017

ALTER TABLE dbo.u2017 ADD CONSTRAINT
	CK_u2017 CHECK (jahr=2017)


	--können Sichten INS UP DEL

insert into vumsatz (id,jahr, spx) values (1,2016,2)

select * from vumsatz where jahr = 2016


--Partitionierung


create table t25 (id int) ON STAMM




create partition function fzahl(int)
as
RANGE LEFT FOR VALUES (100,200)

-----100--------200------
-- 1        2          3

select $partition.fzahl(117) --> 2


create partition scheme schZahl
as
partition fzahl to (bis100,bis200,rest)
--------              1.     2.    3.


create table ptab (id int identity, nummer int, spx char(4100)) ON schZahl(nummer)


declare @i as int = 0

while @i < 20000
	begin
		insert into ptab values  (@i, 'XY')
		set @i+=1
	end


--Keine Indizes
set statistics io, time on
select * from ptab where id = 100
select * from ptab where nummer = 1000


--neue Grenze bei 5000

alter partition scheme schZahl next used bis5000

select $partition.fzahl(nummer), min(nummer), max(nummer), count(*) from 
ptab
group by $partition.fzahl(nummer)

alter partition function fzahl() split Range(5000)

------x100----------200------------5000-------------

alter partition function fzahl() merge range(100)


USE [Northwind]
GO

CREATE PARTITION FUNCTION [fzahl](int) AS RANGE LEFT FOR VALUES (200, 5000)
GO

CREATE PARTITION SCHEME [schZahl] AS PARTITION [fzahl] TO ([bis200], [bis5000], [rest])
GO


select * from ptab where id = 10

create table archiv(id int not null, nummer int, spx char(4100)) on bis200

alter table ptab switch partition 1 to archiv

select * from archiv


--wenn ich 100MB/Sek kopieren kann
.--wie lange würde es hier dauern 1000MB zu archivieren ms













---orderdate: Jahresweise

create partition function fzahl(int)
as
RANGE LEFT FOR VALUES ('31.12.1997 23:59:59.999','',...)

--Kunden  A bis G  H bis R  S bis Z
create partition function fzahl(int)
as
RANGE LEFT FOR VALUES ('H','S')



create partition scheme schZahl
as
partition fzahl to ([PRIMARY],[PRIMARY],[PRIMARY])
