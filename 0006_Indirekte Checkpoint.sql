--Lastverlteilung bei Importen von Daten
--Idee... weniger Schreibspitzen....

ALTER DATABASE AdventureWorks2008R2 
SET TARGET_RECOVERY_TIME = 120 SECONDS;