--Server

--Arbeitsspeicher
--Min RAM. das was SQL Server m ind braucht
--max Ram ..Luft für andere

--SQL priorierisieren
-- Taskmanager: max Arbeitssatz


--Eine DB besteht aus mind  2 Dateien
--mdf (Daten)   ldf (Log)



--HDD
--trenne Daten von Log


--CPU:

--ab wann nimmt der SQL Server mehr CPUs her: ab 5 SQL Dollar
--und wenn wieviele:  alle CPUs

--MAXDOP

DEMO

use nwindbig;



select country, sum(freight) from customers c inner join orders o 
on c.customerid = o.customerid
where orderid = 1
group by country

select country, sum(freight) from customers c inner join orders o 
on c.customerid = o.customerid
--where orderid = 1
group by country


set statistics io, time on --HDD ZUgriffe (Seiten), DAuer in ms , CPU in ms
select country, sum(freight) from customers c inner join orders o 
on c.customerid = o.customerid
--where orderid = 1
group by country
--CPU-Zeit = 6173 ms, verstrichene Zeit = 1338 ms.

select country, sum(freight) from customers c inner join orders o 
on c.customerid = o.customerid
--where orderid = 1
group by country
option (maxdop 6)

--1:  CPU-Zeit = 3313 ms, verstrichene Zeit = 4316 ms.
--2: CPU-Zeit = 4328 ms, verstrichene Zeit = 3061 ms.
--4: CPU-Zeit = 4986 ms, verstrichene Zeit = 1791 ms.
--6: (1 Zeile betroffen)
--6:, CPU-Zeit = 5985 ms, verstrichene Zeit = 1379 ms.
 