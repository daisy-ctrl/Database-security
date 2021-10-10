
/* Create Server Audit
Date: 12-7-2019

Audits can have the following categories of actions:
1) Server-level. These actions include server operations, such as management changes and logon and logoff operations.
2) Database-level. These actions encompass data manipulation languages (DML) and data definition language (DDL) operations.
3) Audit-level. These actions include actions in the auditing process. (AUDIT_ CHANGE_GROUP)

Create Server Audit specifications
Create Database Audit specifications


*/


USE master

GO

-- 1) create the audit "Logins" on the server level
-- Audit: is the file that will contain the audit specifications (Server or database)

CREATE SERVER AUDIT Logins
TO FILE 
( FILEPATH = 'E:\Audit\'			-- File location 
 ,MAXSIZE = 10 MB					-- The size of the file
 ,MAX_ROLLOVER_FILES = 2147483647   -- if the size is full the old files will be deleted 
 ,RESERVE_DISK_SPACE = OFF			-- off means don't reserve the file space. let it grow
)
WITH
( QUEUE_DELAY = 1000				-- the time to push data from buffer to disk
 ,ON_FAILURE = CONTINUE				-- if audit file failed the process will "continue"
)


-- a) enable the audit "Login"
-- Note: 1) The audit will not appear in windows browser till it is enabled
--			in some cases if the file is created on C driver. errors will appear as a result of security reasons

ALTER SERVER AUDIT Logins WITH (STATE = ON)

-- b) Create Server Audit Specificadtion "Logins"
--  this Audit specifcation will store the logins information (Success of Failure)
--  Using GUI: Security -> Server Audit Specifications -> right click -> new

CREATE SERVER AUDIT SPECIFICATION Logins_logs
FOR SERVER AUDIT Logins
ADD (SUCCESSFUL_LOGIN_GROUP),
ADD (FAILED_LOGIN_GROUP)
WITH (STATE = ON)

-- c) Try to login to the SQL Server using SQL Server Authentication

-- d) View the audit file content
--    1) Security -> Audit -> choose audit file -> right click -> View Audit logs

SELECT * FROM sys.fn_get_audit_file
(
'E:\Audit\*.sqlaudit',default,default 
)

-- Select Specific columns from the audit file

SELECT event_time,server_principal_name, succeeded, statement
FROM sys.fn_get_audit_file
(
'E:\Audit\*.sqlaudit',default,default 
)
Order by event_time desc;

GO

-- 2) Create Database Audit Specification
-- a) Create Audit "DreamHomeDMLcommands"
USE Master;

Go

CREATE SERVER AUDIT DreamHomeDMLcommands
TO FILE 
( FILEPATH = 'E:\Audit\'					-- File location 
 ,MAXSIZE = 10 MB					-- The size of the file
 ,MAX_ROLLOVER_FILES = 50           -- if the size is full the old files will be deleted 
 ,RESERVE_DISK_SPACE = OFF			-- off means don't reserve the file space. let it grow
)
WITH
( QUEUE_DELAY = 1000				-- the time to push data from buffer to disk
 ,ON_FAILURE = CONTINUE				-- if audit file failed the process will "continue"
)

-- b) enable Audit "DreamHomeDMLcommands"
ALTER SERVER AUDIT  DreamHomeDMLcommands WITH (STATE = ON)

-- c) Go to Dreamhome database to create Database Audit Specification "TrackDreamHomeDMLcommands"
--	  Note: 1) Database Audit Specification is on database level. Therefore, I must access the database first
--		    2) There is no Audit on database level. only on the server level

USE Dreamhome

GO

CREATE DATABASE AUDIT SPECIFICATION TrackDreamHomeDMLcommands
FOR SERVER AUDIT DreamHomeDMLcommands
ADD (SCHEMA_OBJECT_ACCESS_GROUP)
WITH (STATE = ON)
GO

-- d) Execute some DML commands
-- SELECT, INSERT, UPDATE, DELETE, EXEC "Stored procedures"

USE Dreamhome

GO
SELECT * FROM staff;

GO
INSERT INTO branch
values ('B113', 'cheras', 'KL', '44330');

Go
UPDATE Branch 
SET city = 'London'
WHERE branchNo = 'B113';

Go
DELETE FROM branch WHERE branchno = 'B113';

Go
EXEC SPstaff_name @fname1 = 'ann';


-- e) View the audit file content

SELECT * FROM sys.fn_get_audit_file
(
'E:\Audit\DreamHomeDMLcommands*.sqlaudit',default,default 
)
GO

	-- Select Specific columns from the audit file

SELECT event_time, action_id, class_type, database_name, object_name, statement, file_name 
FROM sys.fn_get_audit_file
(
'E:\Audit\DreamHomeDMLcommands*.sqlaudit',default,default 
)
GO



-- 3) Create the audit "Audit_change" on the server level

USE Master;


CREATE SERVER AUDIT Audit_change
TO FILE 
( FILEPATH = 'E:\Audit\'			-- File location 
 ,MAXSIZE = 10 MB					-- The size of the file
 ,MAX_ROLLOVER_FILES = 2147483647   -- if the size is full the old files will be deleted 
 ,RESERVE_DISK_SPACE = OFF			-- off means don't reserve the file space. let it grow
)
WITH
( QUEUE_DELAY = 1000				-- the time to push data from buffer to disk
 ,ON_FAILURE = CONTINUE				-- if audit file failed the process will "continue"
)



ALTER SERVER AUDIT  Audit_change WITH (STATE = ON)


-- Create Server Audit Specificadtion "Audit_chang_log"

CREATE SERVER AUDIT SPECIFICATION Audit_chang_log
FOR SERVER AUDIT Audit_change
ADD (AUDIT_CHANGE_GROUP)
WITH (STATE = ON)



-- Select Specific columns from the audit file

SELECT event_time, action_id, class_type, database_name, object_name, statement, file_name 
FROM sys.fn_get_audit_file
(
'E:\Audit\Audit_change*.sqlaudit',default,default 
)






