-- Step 1 

USE tempdb;
GO

-- Step 2 

CREATE TRIGGER TR_DATABASE_DDL_TRACKING
ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS
  DECLARE @PostTime datetime2 = EVENTDATA().value('(/EVENT_INSTANCE/PostTime)[1]','datetime2');
  DECLARE @LoginName sysname = EVENTDATA().value('(/EVENT_INSTANCE/LoginName)[1]','sysname');
  DECLARE @TSQLCommand nvarchar(max) = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)');
  
  PRINT 'DDL Event Occurred';
  PRINT @LoginName;
  PRINT 'executed';
  PRINT @TSQLCommand;
  PRINT 'at';
  PRINT @PostTime;
GO


-- Step 3 

CREATE TABLE TestTable (TestTableID int);
GO
DROP TABLE TestTable;
GO


-- Step 4 

DROP TRIGGER TR_DATABASE_DDL_TRACKING ON DATABASE;
GO


-- Step 5 

CREATE TRIGGER TR_DDL_ProcNamingConvention
ON DATABASE
FOR CREATE_PROCEDURE
AS 
BEGIN
  SET NOCOUNT ON;

  DECLARE @EventData xml;
  DECLARE @ObjectName sysname;
	
  SET @EventData = EVENTDATA();
  SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]','sysname');
	
  IF @ObjectName LIKE 'sp%'
  BEGIN
	PRINT '--------------- Database Coding Standards -----------------';
	PRINT CONCAT(' Stored Procedure Name: ', @ObjectName);
    PRINT ' Stored Procedure names are not permitted to start with sp';
	PRINT '-----------------------------------------------------------';
    ROLLBACK TRAN;
  END;
END;
GO



-- Step 6 

CREATE PROC GetVersion
AS
  SELECT @@VERSION;
GO

CREATE PROC sp_GetVersion
AS
  SELECT @@VERSION;
GO

DROP PROC GetVersion;
GO


-- Step 7 

CREATE TRIGGER TR_DDL_CREATE_TABLE_PK
ON DATABASE
FOR CREATE_TABLE,ALTER_TABLE 
AS BEGIN
  SET NOCOUNT ON;

  DECLARE @EventData xml;
  DECLARE @SchemaName sysname;
  DECLARE @ObjectName sysname;
  DECLARE @FullName nvarchar(max);

  SET @EventData = EVENTDATA();
  SET @SchemaName = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]','sysname');
  SET @ObjectName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]','sysname') ;
  SET @FullName = QUOTENAME(@SchemaName)+'.'+QUOTENAME(@ObjectName);

  IF OBJECTPROPERTY(OBJECT_ID(@FullName),'TableHasPrimaryKey') <> 1
  BEGIN
	PRINT '--------------- Database Coding Standards -----------------';
	PRINT CONCAT(' HasPrimaryKey: ', OBJECTPROPERTY(OBJECT_ID(@FullName),'TableHasPrimaryKey'));
    PRINT ' Table needs to be created with at least a Primary Key';
	PRINT '-----------------------------------------------------------';
    ROLLBACK TRAN;
  END;
END;
GO


-- Step 8 

CREATE TABLE dbo.ValueList
( ValueListID int IDENTITY(1,1),
  Value decimal(18,2)
);
GO


-- Step 9 


DROP TRIGGER TR_DDL_ProcNamingConvention
ON DATABASE;
GO

DROP TRIGGER TR_DDL_CREATE_TABLE_PK
ON DATABASE;
GO



