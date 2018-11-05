/*
GR IX
NGR IX

eindeutiger IX
zusammengesetzer IX
IX mit einegschl. Spalten
Gefilterter IX



Columnstore IX
*/


select * into bestellungen from orders




select * from bestellungen

/*
zuerst den CL IX vermutlich auf: orderdate

*/

--kein * 
select freight from bestellungen where customerid = 'ALFKI'

--NGR_CustID_inkl_FR

select freight, employeeid from bestellungen where customerid = 'ALFKI'

--besser wg Lookup

--NIX_CID_inkl_FR_EMPID

select freight, employeeid, orderdate from bestellungen where customerid = 'ALFKI'

--jede CL IX Spalte ist in jedem NCL IX

select newid()

select freight, employeeid, orderdate from bestellungen 
where 
	(customerid = 'ALFKI' or shipcity = 'berlin') and employeeid = 3


--es gibt noch keinen IX--zuerst Klammern
--NIX_CID  NIX_SC_EID


--indizierte Sicht

---Datum: 3.10.2018 | 10 | 2018 | GQU | vor@  | @nach


--was ist schneller?

--1. ad-hoc
--2. Sicht
--3. f()
--4. Proz

--1 2 3 4 
--


select * from orders where orderid = 10248 --SQL versucht zu param.

select * from customers c inner join orders o on c.customerid = o.customerid 
where c.customerid = 'ALFKI'


--Proz sind in der Regel schneller, weil Plan "kompiliert"
create proc gpdemo1 @par varchar(50)


--Sicht

--gleich schnell


create view vdemo
as
select * from customers where city = 'berlin'

select * from vdemo

--niemals!!

create table t3 (id int, stadt int, land int)

insert into t3
select 1,10,100
union
select 2,20,200
union 
select 3,30,300

select * from t3

create view vdemo2 
as
select * from t3

select * from vdemo2

alter table t3 add region int

update t3 set region = id *1000

select * from vdemo2

alter table t3 drop column land

select * from vdemo2

alter view dbo.vdemo2 with schemabinding
as
select id, stadt from dbo.t3


--ind Sicht
set statistics io, time on
select shipcountry, count(*) from orders
group by shipcountry

create view dbo.vdemo3 with schemabinding
as
select shipcountry, count_big(*) as anz from dbo.orders
group by shipcountry


select * from vdemo3



select top 3 * from mess








select top 3 * from umsatz --kein IX


--idealer IX
select country, sum(unitprice*quantity) 
from umsatz
where orderdate > '1.1.1998'
group by country

--NIX_

select * into umsatz2 from umsatz


select country, sum(unitprice*quantity) 
from umsatz2
where orderdate > '1.1.1998'
group by country





















--wg doofen PK.. der immer gleich als CL IX angelegt
--muss aber nicht sein:  non cl ix eindeutig



SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, Orders.ShipCountry, 
                         [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Products.ProductName, Products.UnitsInStock, Employees.LastName, Employees.FirstName, 
                         Employees.BirthDate, Employees.Title
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID



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
---1023, aber wirklich notwendig sind nur wenige...
--> Siehe überlappende Indizes


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

