--Transaktionen und Sperrlevel

--Schreiben hindert Lesen
set transaction isolation level READ COMMITTED;
--Lesen auf Daten, die nicht geändert wurden aber nicht bestätigt sind (Dirty Reads)
set transaction isolation level READ UNCOMMITTED;

--Lesedaten können durchh Schreiben nicht verändert werden, aber was ist mit neuen DS?
set transaction isolation level REPEATABLE READ ;

--was ist mit neuen Datensätzen? (INSERT) kann auch nicht mehr stattfinden
set transaction isolation level SERIALIZABLE;



--Zeilenversionierung arbeitet ohne Sperren, allerdings benötigt man dann eine Fehlerbehanldung..


