CREATE EVENT SESSION [WAITSONQUERY] ON SERVER 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.query_hash,sqlserver.sql_text)
    WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[database_name],N'%smart%')))
ADD TARGET package0.event_file(SET filename=N'WAITSONQUERY'),
ADD TARGET package0.histogram(SET source=N'sqlserver.sql_text')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO
