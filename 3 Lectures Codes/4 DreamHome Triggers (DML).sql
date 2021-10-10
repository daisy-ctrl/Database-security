/* Date 1 / 5 / 2018 
   Title: Triggers
   Database: DreamHome
*/

-- use DreamHome Database

Use Dreamhome

SELECT * from Staff

-- ADD constraint on Salary Table (Domain Constraint)

ALTER TABLE Staff 
     ADD CONSTRAINT chk_sal CHECK ( Salary <= 90000)


ALTER TABLE Staff
     DROP CONSTRAINT chk_sal 
     
-- create Domian constraint using trigger
Go

ALTER TRIGGER ChkSal
ON STAFF
AFTER UPDATE
AS
	SELECT * FROM inserted
	SELECT * FROM deleted

	IF exists ( select salary from inserted where Salary >= 30000 )
	begin 
		print 'Salary Must be Less than 30000'
		SELECT * FROM Staff
		rollback
		--without rollback, data will be modified
		SELECT * FROM Staff
	End

-- use drop command to delete the trigger

drop TRIGGER ChkSal

-- show Staff table details

SELECT * FROM STAFF

-- Update Staff 'SL41' Salary to be 35000

UPDATE Staff
SET salary = 100000
WHERE Staffno = 'SL41'

-- ALter trigger to remove the rollback statement

CREATE TRIGGER ChkSal
ON STAFF
AFTER UPDATE
AS
	IF exists ( select salary from inserted where  Salary >= 30000 )
	begin 
		print 'Salary Must be Less than 30000'
	End

-- Create a trigger to insure that the salary of a manager will not
-- exceed 30000

CREATE trigger sal_pos_check
ON staff
AFTER UPDATE
As

If EXISTS (SELECT * from inserted WHERE position = 'manager' AND Salary > 30000) 
	BEGIN
		PRINT 'Manager Salary must not exceed 30000'
		ROLLBACK
	END
	
-- Update Staff Susan Salary to be 28000 rather than 24000
-- Hint: the trigger will not fire because I didn't meet the criteria

SELECT * FROM Staff

UPDATE staff
SET position = 'supervisor', salary = 50000
Where staffno = 'SG5'


-- Update Staff Susan Salary to be 35000 rather than 28000
-- Hint: the trigger will fired and no action will happend as a result of the 
-- rollback statement

UPDATE staff
SET salary = 35000
Where staffno = 'SG5'


-- get triggers information using sys.triggers

select * from sys.triggers

-- USING INSTEAD OF to Prevent Staff member from being deleted
-- RAISERROR 

CREATE TRIGGER STAFF_DEL123
ON STAFF
INSTEAD OF delete
AS
BEGIN
	select * from deleted
	SELECT * FROM inserted
	RAISERROR('Staff Can''t be deleted', 16,10)
END

select * from deleted


-- Use Delete statement to delete staff 'SG5'

DELETE FROM Staff
Where staffno = 'SL21'

-- Add column status to staff table to check If Staff is active or Inactive

ALTER TABLE Staff
	ADD status varchar(10)
	
-- Update the STAFF_DEL trigger to include the Staff status

create TRIGGER STAFF_DEL
ON STAFF
INSTEAD OF delete
AS
BEGIN
	RAISERROR ('Staff cant''t be deleted.  Staff
	changed to inactive status.', 14, 11)
	 
	SELECT * FROM deleted -- this statement to show the deleted records in the deleted table
	SELECT * FROM inserted

	UPDATE Staff
	SET status = 'Inactive'
	FROM staff as s INNER JOIN deleted as d   
	ON s.Staffno = d.Staffno
	--joins deleted table and staff table, and update based on  info on delete table
END

-- Delete the Staff who holds the staffno SG5

Delete FROM Staff
Where Staffno = 'SL21'


-- try to show the deleted table info outside the trigger

Select * from deleted

--TRIGGER FOR AUDITING PROCESS
-- Create Audit Table ClientAudit

Create table ClientAudit
(
ClientNo varchar(50) not null,
fname varchar(50) ,
lname varchar(50) ,
telno varchar(50) ,
preftype varchar (50),
maxrent int,
InsDelDate date,
flag char(1)
)


-- create ClientAud trigger to save the insert and delete rows 
-- from Client table to ClientAudit table


CREATE TRIGGER ClientAud
on Client
AFTER INSERT, DELETE
AS

INSERT INTO ClientAudit 
select ClientNo, fname, lname, telno, preftype, maxrent , getdate(), 'I'
from inserted

select * from inserted

INSERT INTO ClientAudit 
select ClientNo, fname, lname, telno, preftype, maxrent , getdate(), 'D'
from deleted

select * from deleted

-- Insert New row to Client table

select * from Client
select * from ClientAudit

insert into Client
values ('CR95','Alex', 'Max','01498-22222', 'House', 500)

-- Delete the previously inserted record

Delete from Client
WHERE Clientno = 'CR95'

 
