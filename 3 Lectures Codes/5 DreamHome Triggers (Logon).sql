/*

Uses of Logon Triggers
Below are the some of the usecase scenarios where LOGON triggers will be usefull:

- Restricting user from logging-in outside permitted hours 
- Restricting the number of sessions for a specific login
- Tracking login activity

*/

-- Create a login 

CREATE LOGIN samy WITH PASSWORD = 's@my1234'

-- EXAMPLE 1: This example Logon trigger blocks the user 
-- samy from connecting to Sql Server after the office hours
Go

ALTER TRIGGER LimitConnectionAfterOfficeHours
ON ALL SERVER 
FOR LOGON
AS
BEGIN
 IF ORIGINAL_LOGIN() = 'samy' AND
  (DATEPART(HOUR, GETDATE()) < 9 OR
   DATEPART (HOUR, GETDATE()) > 14)
 BEGIN
  PRINT 'You are not authorized to login after office hours'
  ROLLBACK
 END
END

-- to read the error messasge
-- Go to Management --> SQL Server logs --> current

-- Drop the trigger

DROP TRIGGER LimitConnectionAfterOfficeHours ON ALL SERVER


-- EXAMPLE 2: This example Logon Trigger blocks a user from establishing 
-- more than five user sessions at any given point of time


-- Create a login 

CREATE LOGIN susan WITH PASSWORD = 'sus@n1234'

-- enable susan to view the server files

GRANT VIEW SERVER STATE TO susan

-- create the trigger
Go

Create TRIGGER LimitMultipleConcurrentConnection
ON ALL SERVER 
FOR LOGON
AS
BEGIN
 IF ORIGINAL_LOGIN() = 'susan' AND
  (SELECT COUNT(*) FROM   sys.dm_exec_sessions
   WHERE  Is_User_Process = 1 
    AND Original_Login_Name = 'susan') > 7
 BEGIN
  PRINT 'You are not authorized to login, as you already have seven active user sessions'
  ROLLBACK
 END
END

-- SELECT COUNT(*) FROM   sys.dm_exec_sessions
--   WHERE  Is_User_Process = 1 

-- View all the users login to the system
SELECT login_name ,COUNT(session_id) AS session_count   
FROM sys.dm_exec_sessions   
GROUP BY login_name;  

SELECT *  
FROM sys.dm_exec_sessions 
WHERE login_name = 'susan';



-- to activate the trigger open new query under susan
-- till the server prevent you from login 

-- you can view the number of session that susan have done

SELECT * FROM  sys.dm_exec_sessions
where login_name = 'susan'


-- Drop trigger

DROP TRIGGER LimitMultipleConcurrentConnection ON ALL SERVER

-- to read the error messasge
-- Go to Management --> SQL Server logs --> current


/* 
EXAMPLE 3: Logon Trigger record all the login in an audit table

*/

-- Create Audit Database 
CREATE DATABASE AuditDb
GO

USE AuditDb
GO

-- Create Audit Table ServerLogonHistory

CREATE TABLE ServerLogonHistory
(SystemUser VARCHAR(512),
 DBUser VARCHAR(512),
 SPID INT,
 LogonTime DATETIME)

GO

Select * from ServerLogonHistory
-- Create Logon Trigger
Go

CREATE TRIGGER Tr_ServerLogon
ON ALL SERVER 
FOR LOGON
AS
BEGIN
INSERT INTO AuditDb.dbo.ServerLogonHistory
SELECT SYSTEM_USER,USER,@@SPID,GETDATE()
end


-- Grant susan Control SERVER permission
-- Note: This permission is required to insert data in ServerLogonHistory table

Use Master

GRANT CONTROL SERVER TO Susan

-- Login as Susan

-- select the information from the audit table

SELECT * from AuditDb.dbo.ServerLogonHistory


-- Other useful commands

SELECT * FROM sys.server_triggers;

DROP TRIGGER Tr_ServerLogon ON ALL SERVER;

select db_name(dbid) from master..sysprocesses where spid=@@SPID

