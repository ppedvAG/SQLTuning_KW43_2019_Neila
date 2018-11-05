--Transaktionen und Sperrlevel

--Schreiben hindert Lesen
set transaction isolation level READ COMMITTED;
--Lesen auf Daten, die nicht ge�ndert wurden aber nicht best�tigt sind (Dirty Reads)
set transaction isolation level READ UNCOMMITTED;

--Lesedaten k�nnen durchh Schreiben nicht ver�ndert werden, aber was ist mit neuen DS?
set transaction isolation level REPEATABLE READ ;

--was ist mit neuen Datens�tzen? (INSERT) kann auch nicht mehr stattfinden
set transaction isolation level SERIALIZABLE;



--Zeilenversionierung arbeitet ohne Sperren, allerdings ben�tigt man dann eine Fehlerbehanldung..


