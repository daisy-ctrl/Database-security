CREATE DATABASE DreamHomeDDL

Go

Use DreamHomeDDL

Go

CREATE TABLE Branch
(branchNo varchar(4) primary key,
street varchar(50) ,
city varchar(50),
postcode varchar(50));

Go

CREATE TABLE Staff
( staffno varchar(4) primary key,
fname varchar(50),
lname varchar(50),
position varchar(50),
gender varchar(1),
dob date,
salary int,
branchno varchar(4) Foreign key references Branch(branchno));

Go

-- Note: "Branch" table will not be dropped since it has a child table "staff"  

DROP TABLE Branch

DROP TABLE staff

-- Create the branch and staff table again
-- Using ALTER command to modify the table structure
-- add new column "address" with datatype varchar to "staff" table 

ALTER TABLE Staff
	add address varchar(50);

-- Remove the column "address" from "Staff" table 

ALTER TABLE Staff
	DROP COLUMN address; 

-- Modifiy the staff table

Alter Table Staff 
 	Alter column position varchar (50) Not Null


-- add check constraint on "salary" column.
-- the domain of values in salary column is between 2000 and 10000.

ALTER TABLE Staff
   ADD constraint ck_salary check (salary >= 2000 and Salary <= 10000);


-- add a new column "commision" with check constraint 

ALTER TABLE Staff
	ADD commision int 
    CONSTRAINT com_check check (commision > 0)

-- remove the constraint from existing column "commision"

ALTER TABLE Staff
   DROP CONSTRAINT com_check 

     
/* add new constrain for existing column "having some invalid data"
Note: 1) if the CONSTRAINT is already exist it must be Dropped 
	  2) use "with nocheck" 
      
*/

-- 1) Drop the existing constraint ck_salary

ALTER TABLE Staff 
   DROP constraint ck_salary 

-- 2) use "with no check"

ALTER TABLE Staff  with nocheck
   ADD constraint ck_salary  check (salary > 0)

  
-- add default value for existing column 

ALTER TABLE Staff
	ADD CONSTRAINT pos_def default 'assistant' for position

