
/*

DDL Triggers
Database: DreamHomeDDL
Date: 12-2-2019

DDL Event Groups

source: https://docs.microsoft.com/en-us/sql/relational-databases/triggers/ddl-event-groups?view=sql-server-ver15

*/


-- EXAMPLE 1: DDL trigger blocks user from modifying or dropping any Table in the 
-- DreamHomeDDL database

-- Create DreamHomeDDL database

Create Database DreamHomeDDLTrigger

USE DreamHomeDDLTrigger

-- Create Table Staff


CREATE TABLE Staff
(
Sno int Primary key,
Fname varchar(30),
Lname Varchar (30)
);

-- Create DDL trigger to prevent table deletion or modification
-- Rollback must be added to rollback the event
GO

CREATE OR ALTER TRIGGER DDLTriggerTableDropAlter
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
 PRINT 'Disable trigger DDLTriggerTableDropAlter to drop or alter tables'
 ROLLBACK
END

-- Try to drop Staff table
DROP TABLE staff;


-- Check table Staff design
-- DreamHomeDDLTrigger --> Views --> System Views --> INFORMATION_SCHEMA.COLUMNS

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Staff';

-- Try to add new column "address" using Alter command

ALTER TABLE staff ADD address varchar(20);

-- Disable DDLTriggerTableDropAlter

DISABLE TRIGGER DDLTriggerTableDropAlter ON DATABASE

-- try once again to add new column "address" using Alter command

ALTER TABLE Staff ADD address varchar(20);


-- Create DDL trigger using parent type (DDL_TABLE_EVENTS)
-- DDL_TABLE_EVENTS (10018) include the following events:
-- ALTER_TABLE (22), CREATE_TABLE (21), DROP_TABLE (23)

-- Create Dept table

CREATE TABLE Dept
(
Dno int PRIMARY KEY,
Dname varchar(30)
);

-- Drop Table Dept

DROP TABLE Dept;

Go

CREATE TRIGGER DDLTriggerToBlockTableAll
ON DATABASE
FOR DDL_TABLE_EVENTS
AS
BEGIN
 PRINT 'Disable trigger DDLTriggerToBlockTableALL to drop or alter or create tables'
 ROLLBACK
END

-- try to create the Dept table once again

CREATE TABLE Dept
(
Dno int PRIMARY KEY,
Dname varchar(30)
);



Go
CREATE VIEW staffview
AS
select Fname, Lname
From Staff;


---- try to Drop staff table
--Drop table staff;

---- Try to add new column address using Alter command
--Select * from staff;

--ALTER TABLE staff ADD address1 varchar(20);

---- Disable the DDL trigger command


--DISABLE TRIGGER DDLTriggerToBlockTableDDL ON DATABASE

---- Try to add the new cloumn address once again

--ALTER TABLE staff ADD address varchar(20);


-- Enable the DDL trigger command

ENABLE TRIGGER DDLTriggerToBlockTableDDL ON DATABASE

-- Drop the DDL trigger comand

DROP TRIGGER DDLTriggerToBlockTableALL ON DATABASE


-- EXAMPLE 2: In this example the DDL trigger blocks user from creating, modifying or dropping 
-- any Stored Procedures in the DreamHome database
-- DDL_PROCEDURE_EVENTS includes the following events
-- ALTER_PROCEDURE, CREATE_PROCEDURE, DROP_PROCEDURE

USE DreamHomeDDLTrigger
GO
CREATE TRIGGER DDLTriggerToBlockProcedureDDL
ON DATABASE
FOR DDL_PROCEDURE_EVENTS
AS
BEGIN
 PRINT 'Disable trigger DDLTriggerToBlockProcedureDDL to create, alter or drop procedures'
 ROLLBACK
END

--Create a Stored Procedure to list staff information

Go

CREATE PROCEDURE Staff_info
AS
BEGIN
    SELECT * FROM staff;
END

GO

-- Check the current triggers on the system
-- DDL_PROCEDURE_EVENTS (10024)

SELECT * FROM SYS.TRIGGER_EVENT_TYPES 
WHERE parent_type = 10029 or type = 10029;


-- EXAMPLE 3: server level trigger blocks user from creating, altering or 
-- dropping database

USE MASTER
GO
CREATE TRIGGER DDLTriggerToBlockDatabaseDDL
ON ALL SERVER
FOR DDL_DATABASE_EVENTS
AS
BEGIN
 PRINT 'Disable trigger DDLTriggerToBlockDatabaseDDL to create, alter or drop database'
 ROLLBACK
END

-- Try to create a new database

CREATE DATABASE Test12345;

-- Drop the trigger

DROP TRIGGER DDLTriggerToBlockDatabaseDDL ON ALL SERVER;


-- EXAMPLE 4: This example explains how we can use DDL triggers to log the Database 
-- DDL statement, statement execution time, the user who has fired the statement 

Go

CREATE TRIGGER ddl_trig_database   
ON ALL SERVER   
FOR CREATE_DATABASE   
AS   
    PRINT 'Database Created.'  
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')

-- create a database

create database alex;

GO  
DROP TRIGGER ddl_trig_database  
ON ALL SERVER;  
GO  


--------------------------------------------------------

USE DreamHomeDDLTrigger;  

GO  
CREATE TABLE ddl_log 
(PostTime DATETIME, 
DB_User NVARCHAR(100), 
Event NVARCHAR(100), 
TSQL NVARCHAR(2000));  

GO  
CREATE TRIGGER log_trigger   
ON DATABASE   
FOR DDL_DATABASE_LEVEL_EVENTS   
AS  
DECLARE @data XML  
SET @data = EVENTDATA()  

INSERT ddl_log (PostTime, DB_User, Event, TSQL)   
VALUES 
   (GETDATE(),   
   CONVERT(NVARCHAR(100), CURRENT_USER),   
   @data.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),   
   @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(2000)') ) ;  

GO  
--Test the trigger.  
CREATE TABLE TestTable (a INT);  
DROP TABLE TestTable ;  

-- check ddl_log
GO  
SELECT * FROM ddl_log ;  
GO  

--Drop the trigger
DROP TRIGGER log_trigger  ON DATABASE;  
GO  

--Drop table ddl_log.  
DROP TABLE ddl_log;  

GO  

-------------------------------------------






---- Create audit table LogDDLEvents


--CREATE TABLE LogDDLEvents
--(   
-- EventTime DATETIME,
-- LoginName VARCHAR(50),
-- TSQLCommand NVARCHAR(MAX) 
--)

---- Create the DDL trigger to track stored procedures DDL statements

--USE DreamhomeDDL
--GO
--CREATE TRIGGER DDLTriggerForSPDDL
--ON DATABASE
--FOR DDL_PROCEDURE_EVENTS
--AS
--BEGIN
-- DECLARE @EventData XML = EVENTDATA()
-- INSERT INTO dbo.LogDDLEvents (EventTime, LoginName, TSQLCommand) 
-- SELECT @EventData.value('(/EVENT_INSTANCE/PostTime)[1]', 'DATETIME'),
--        @EventData.value('(/EVENT_INSTANCE/LoginName)[1]' , 'VARCHAR(50)'),
--        @EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]' , 'NVARCHAR(MAX)')
--END

---- First make sure that you disable DDLTriggerToBlockProcedureDDL trigger

--Go
--Disable TRIGGER DDLTriggerToBlockTableDDL ON DATABASE

---- try to create the stored procedure
--Go
--CREATE PROCEDURE get_staff_info
--AS
--BEGIN
--    SELECT * FROM staff;
--END

---- Get the information from the LogDDLEvents

--SELECT * FROM dbo.LogDDLEvents;


