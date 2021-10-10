
-- 1)use stored Procedure sp_addlogin to create logins under general database Security 
--   (logins folder)(PC --> Security --> Logins )

EXECUTE sp_addlogin @loginame =  'Alex', @passwd = '1'

-- 2) after logins created a user should be created under 
--    DreamHome --> Security --> Users

EXECUTE sp_adduser @loginame = 'Alex', @name_in_db = 'Alex123'



-- Create Login ali, mary, bob, sam

EXECUTE sp_addlogin @loginame =  'ali', @passwd = '@passwd123'
EXECUTE sp_addlogin @loginame =  'mary', @passwd = '@passwd123'
EXECUTE sp_addlogin @loginame =  'bob', @passwd = '@passwd123'
EXECUTE sp_addlogin @loginame =  'sam', @passwd = '@passwd123'


-- Create user ali, mary, bob, sam

EXECUTE sp_adduser 'ali', 'ali'
EXECUTE sp_adduser 'mary', 'mary'
EXECUTE sp_adduser 'bob', 'bob'
EXECUTE sp_adduser 'sam', 'sam'

-- Grant Select to be able to view the table 
-- (admin --> ali)
-- Note: If i want to give same privileges to other users in this case 
-- after (TO) add users seperated by comma


GRANT Select 
ON staff
TO Ali


-- Grant update privileges on salary and position columns only 
-- (admin --> ali)

GRANT UPDATE (salary, position) 
ON staff
TO Ali



-- using with grant option admin give mary SELECT, INSERT, UPDATE privileges 
-- additionally he allow her to give her privileges to other users
-- (admin --> mary)

GRANT SELECT, INSERT, UPDATE
ON staff
TO mary
WITH GRANT OPTION


-- Mary give SELECT, INSERT privilege to bob
-- First login using mary account
-- (Mary --> bob)

GRANT SELECT, INSERT
ON staff
TO bob
WITH GRANT OPTION

-- what if bob give this privileges back to mary
--(bob --> Mary)
-- SQL server will accept it but admin later will be confused when executing the revoke
-- statrment since the privilege that is give by bob will be revoked since it was earlier
-- given by mary to bob

GRANT SELECT, INSERT
ON staff
TO mary
WITH GRANT OPTION

-- bob give SELECT, INSERT privilege to sam
-- First login using bob account
-- (bob --> sam)

GRANT SELECT, INSERT
ON staff
TO sam


-- admin give select, insert, update privileges to sam
-- First login as admin
-- (admin --> sam)

GRANT select, insert, update
ON staff
TO sam

-- admin revoke select and insert from mary
-- Cascade keyword must be used to revoke mary privileges
-- and any other privileges given by mary to other users

REVOKE select, insert
ON staff
FROM Mary cascade

-- after executing this statement 
-- mary will have (update) privilege.
-- bob will not have any privilege
-- sam will have (select, insert, update) privileges from admin


-- Grant all Privileges to specific user

Grant all privileges
on staff
to mary

-- Revoke all privielges from mary

Revoke all privileges
on staff
from mary , sam cascade


-- create a stored procedure SPstaff
go
create proc SPstaff
AS 
(SELECT * 
 FROM staff)

-- try to execute the stored procedure SPstaff by Mary
-- first connect to mary

Select * from staff;

-- notice that Mary is not able to execute the stored procedure since
-- she is not having any privilege on SPstaff procedure
-- mary


-- Grant execute on the stored procedure
-- Grant execute privilege on SPstaff_name to mary

Grant execute
on SPstaff
to Mary

-- execute the stored procedure after connect to Mary

SPstaff_name 'john'


-- The following steps are to Create groups ( Users who have the same privileges) 

-- 1) revoke all privileges from all users

revoke all privileges
on staff
from mary, ali , bob, sam cascade


-- 2)create (roles or groups) using sp_addrole stored procedure
--   DreamHome --> Security --> Roles --> Database roles

execute sp_addrole @rolename = 'HR'

-- 3) -- Grant SELECT, INSERT, UPDATE privileges to (HR group or role)
	  -- DreamHome --> Security --> Roles --> Database roles --> under securables 
      -- notice the check boxes under grant

GRANT SELECT, INSERT, UPDATE
ON staff
TO HR


-- 4) after creating roles sp_addrolemember stored procedure used to 
--    assign users to groups

execute sp_addrolemember @rolename = 'HR' , @membername = 'mary'

execute sp_addrolemember @rolename = 'HR' , @membername = 'bob'

