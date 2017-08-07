--a7: Dynamic Management Views

--The following query returns the total number 
--of free pages and total free space in megabytes (MB)
--available in all files in tempdb.
USE tempdb;  
go  
SELECT SUM(user_object_reserved_page_count) AS [user object pages used],  
(SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]  
FROM sys.dm_db_file_space_usage;

--returns the total number of pages used 
--by user objects and the total space used 
--by user objects in the database.
SELECT SUM(unallocated_extent_page_count) AS [free pages],   
(SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]  
FROM sys.dm_db_file_space_usage;  

--object partition
USE AdventureWorks2014;  
GO  
SELECT * FROM sys.dm_db_partition_stats;  

--select specified object id's partition
SELECT * FROM sys.dm_db_partition_stats   
WHERE object_id = OBJECT_ID('HumanResources.Employee');  

SELECT * FROM sys.databases
SELECT * FROM sys.triggers 
SELECT * FROM sys.allocation_units 
SELECT * FROM sys.foreign_keys
SELECT * FROM sys.index_columns 