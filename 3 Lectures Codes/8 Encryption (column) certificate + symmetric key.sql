/* 
Date: 19-7-2019
Title: column encryption in table 
- Typically, you encrypt the column with Symmetric or Asymmetric keys. 
- You can also encrypt with passphrase, but not recommended. 
- Symmetric key performs better than Asymmetric. 

*/

-- a)Encrypting column with symmetric key (This is the common approach)
--	  DMK -> Certificate -> Symmetric key -> Column data 


CREATE DATABASE Encryption_Test 
GO

USE Encryption_Test
GO 
-- 1) Create Data Master Key (DMK)

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Admin123'; 

-- 2) use the following queries to get system catalog views
--    Note: the SMK and password can decrypt the DMk

select * from sys.symmetric_keys 
--select * from sys.asymmetric_keys 
--select * from sys.certificates 
--select * from sys.openkeys 
select * from sys.key_encryptions 
--select * from sys.column_encryption_key_values 


-- 3) Create certificate protected by DMK 

CREATE CERTIFICATE testcert WITH SUBJECT = 'Test Certificate';   
GO   

-- 4) use the following queries to get system catalog views
-- Note: the certificate will expire after one year

select * from sys.symmetric_keys 
--select * from sys.asymmetric_keys 
select * from sys.certificates 
--select * from sys.openkeys 
select * from sys.key_encryptions 
--select * from sys.column_encryption_key_values 


-- 5) Create symmetric protected by Certificate 
--  Note: 1) the symmetric key is protected by the certificate 'testcert'
--        2) Algorithm is AES_256 is the default

CREATE SYMMETRIC KEY test_symmkey WITH   
    ALGORITHM = AES_256 
    ENCRYPTION BY CERTIFICATE testcert 
GO 

-- 6) use the following queries to get system catalog views
--    Note: two symettric keys will appear 'DMK' and 'testcert'

select * from sys.symmetric_keys 
--select * from sys.asymmetric_keys 
select * from sys.certificates 
--select * from sys.openkeys 
select * from sys.key_encryptions 
--select * from sys.column_encryption_key_values 


-- 7) Open the symmetric key (before encrypting the column) 

OPEN SYMMETRIC KEY test_symmkey  
    DECRYPTION BY CERTIFICATE testcert;   
GO   

-- 8) Check if the symmetric key is opened 
SELECT * FROM sys.openkeys 
GO 
--any results in a table means opened

-- 9) Create the table 'Encrypted_Table'
-- Note: the encrypted text must be in varbinary data type

CREATE TABLE Encrypted_Table 
( 
id INT IDENTITY(1,1) PRIMARY KEY, 
cust_name VARCHAR(50), 
Plain_Text VARCHAR(100), 
Encrypted_Text VARBINARY(1000) 
) 
GO 

-- 10) Insert rows into the table 
-- Note: ENCRYPTBYKEY will add "Key_GUID- key id" + value in the encrypted column 
INSERT INTO Encrypted_Table (cust_name,Plain_Text, Encrypted_Text)  
VALUES ('User1','value1', ENCRYPTBYKEY(Key_GUID('test_symmkey'), 'value1')) 
INSERT INTO Encrypted_Table (cust_name,Plain_Text, Encrypted_Text)  
VALUES ('User2','value2', ENCRYPTBYKEY(Key_GUID('test_symmkey'), 'value2')) 
INSERT INTO Encrypted_Table (cust_name,Plain_Text, Encrypted_Text)  
VALUES ('User3','value3', ENCRYPTBYKEY(Key_GUID('test_symmkey'), 'value3')) 
GO 

-- 11) Select the rows from the table

SELECT * from Encrypted_Table;

-- 12) Close the symmetric key 

CLOSE SYMMETRIC KEY test_symmkey 
GO 
--you can't insert data when the keys are open. results will be null under encrypted text
-- 13) Check if the symmetric key is opened 

SELECT * FROM sys.openkeys 

-- =================================================
-- b) decrypt the data 
-- 1) Open the symmetric key "test_symmkey" to read the table 

OPEN SYMMETRIC KEY test_symmkey  
    DECRYPTION BY CERTIFICATE testcert;   
GO   

-- 2) Check if the symmetric key is opened 
SELECT * FROM sys.openkeys 
GO 

-- 3) select the data from encrypted table 
SELECT *,cast(DECRYPTBYKEY(Encrypted_Text) as varchar(8000)) as decrypted_text FROM Encrypted_Table 
GO 

-- 4) Close the symmetric key 
CLOSE SYMMETRIC KEY test_symmkey 
GO 

--5) Check if the symmetric key is opened 
SELECT * FROM sys.openkeys 
GO 

--=========================================================
-- c) lets encrypt data using different symmetric key 
 
-- 1) Create another certificate "testcert2" 
CREATE CERTIFICATE testcert2 WITH SUBJECT = 'Key Protection'; 
GO 

-- 2) Create another symmetric key "test_symmkey2" 
CREATE SYMMETRIC KEY test_symmkey2 WITH   
    ALGORITHM = AES_256 
    ENCRYPTION BY CERTIFICATE testcert2 
GO 

-- 3) Open the new symmetric key "test_symmkey2" 
OPEN SYMMETRIC KEY test_symmkey2  
    DECRYPTION BY CERTIFICATE testcert2; 
GO 
-- 4) Check the Open keys 
SELECT * FROM sys.openkeys 
GO 
-- 5) Insert rows into the table 
INSERT INTO Encrypted_Table(cust_name, Plain_Text, Encrypted_Text) VALUES ('User4','value4', ENCRYPTBYKEY(Key_GUID('test_symmkey2'),'value4')) 
INSERT INTO Encrypted_Table(cust_name, Plain_Text, Encrypted_Text) VALUES ('User5','value5', ENCRYPTBYKEY(Key_GUID('test_symmkey2'),'value5')) 
INSERT INTO Encrypted_Table(cust_name, Plain_Text, Encrypted_Text) VALUES ('User6','value6', ENCRYPTBYKEY(Key_GUID('test_symmkey2'),'value6')) 
GO 

-- 6) Close the symmetric key 
CLOSE SYMMETRIC KEY test_symmkey2 
GO 

-- 7) Check the Open keys 
SELECT * FROM sys.openkeys 
GO 

-- 8) Select the rows from table 
-- Note: the begining of the encrypted_text for the first 3 rows is different than next 3 rows
--       this happened because we used two different symmetric keys (0x00C0315, 0x0062585)

select * from Encrypted_Table 
GO 
-- 9) Get the keys that we used 
--this query shows keys being used to encrypt data
select *, KEY_NAME(Encrypted_Text) as key_name from Encrypted_Table;
 
--====================================================================

-- d) Check the encrypted data using the two keys

-- 1) open all symmetric keys and decrypt all the data in table 
--    Note: I have two keys now test_symmkey and test_symmkey2
 
OPEN SYMMETRIC KEY test_symmkey 
    DECRYPTION BY CERTIFICATE testcert; 
GO 
OPEN SYMMETRIC KEY test_symmkey2 
    DECRYPTION BY CERTIFICATE testcert2; 
GO
 
-- 2) Check the Opened keys 
SELECT * FROM sys.openkeys;
GO 

-- 3) Select the rows from the table 
-- Note: The name of the key is not specified
SELECT *,cast(DECRYPTBYKEY(Encrypted_Text) as varchar(8000)) as decrypted_text FROM Encrypted_Table 
GO 

-- 4) Close the symmetric key "test_symmkey"
CLOSE SYMMETRIC KEY test_symmkey;
GO 

-- 5) check the encrypted data after closing "test_symmkey"
-- Note: the data encrypted by "test_symmkey" will not appear
--       Because, the key is not opened

SELECT *,cast(DECRYPTBYKEY(Encrypted_Text) as varchar(8000)) as decrypted_text FROM Encrypted_Table 
GO 


--====================================================================

-- e) Encrypting column with passphrase 
-- You can encrypt and decrypt the data using passphrase. 
-- You can also add an authenticator to the passphrase functions. 
-- The Triple DES algorithm is used to encrypt or decrypt your data with the generated key. 

-- 1) create table 'encrypted'
CREATE TABLE encrypted 
( 
  id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, 
  data VARBINARY(8000) 
);

-- 2) Insert a new record and use 'ENCRYPTBYPASSPHRASE' to encrypt  the value
INSERT INTO encrypted VALUES(ENCRYPTBYPASSPHRASE('Admin 123','Hello World!')); 

-- 3) check the encrypted data
SELECT * FROM encrypted;

-- 4)  decrypt the data
SELECT id,CAST(DECRYPTBYPASSPHRASE('Admin 123',data) AS VARCHAR(8000)) 
FROM encrypted; 

-- f) Dynamic data masking
