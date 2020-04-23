
-- Step 1 

USE AdventureWorks;
GO

-- Step 2 

SELECT * FROM dbo.DatabaseLog;
GO



-- Step 4 

SELECT EventDetail.value('PostTime[1]','datetime2') AS PostTime,
       EventDetail.value('SPID[1]', 'int') AS SPID,
       EventDetail.value('ObjectType[1]','sysname') AS ObjectType,
       EventDetail.value('ObjectName[1]','sysname') AS ObjectName
FROM dbo.DatabaseLog AS dl
CROSS APPLY dl.XmlEvent.nodes('/EVENT_INSTANCE') AS EventInfo(EventDetail)
ORDER BY PostTime;


-- Step 5 


SELECT dl.DatabaseLogID,
       EventDetail.value('PostTime[1]','datetime2') AS PostTime,
       EventDetail.value('SPID[1]', 'int') AS SPID,
       EventDetail.value('ObjectType[1]','sysname') AS ObjectType,
       EventDetail.value('ObjectName[1]','sysname') AS ObjectName,
       dl.TSQL 
FROM dbo.DatabaseLog AS dl
CROSS APPLY dl.XmlEvent.nodes('/EVENT_INSTANCE') AS EventInfo(EventDetail)
ORDER BY PostTime;

-- Step 6 

DECLARE @xmldoc AS int, @xml AS xml;
SELECT @xml=XmlEvent FROM dbo.DatabaseLog;
SELECT @xml;


EXEC sp_xml_preparedocument @xmldoc OUTPUT, @xml; 
 
SELECT * FROM OPENXML(@xmldoc, '/EVENT_INSTANCE', 2)
WITH (
  [PostTime] datetime2
, [SPID] int 
, [ObjectType] sysname
, [ObjectName] sysname
); 
 

EXEC sp_xml_removedocument @xmldoc;

