--a5:Database Snapshot

--create a snapshot of MetroAlt.
use Master
create database MetroAlt_snapshot
on (name = 'MetroAlt'
, filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\MetroAlt.ds')
as snapshot of MetroAlt

--Now in the actual database add a record to 
--and update one existing record (in employee). 
use MetroAlt
update Employee
set EmployeeLastName = 'Lizzy'
where EmployeeKey = 1;

select * from Employee

use MetroAlt_snapshot

--Run a query on Employee in the Snapshot. 
--Does it reflect the original values still?
use Master
Restore database MetroAlt
from Database_snapshot = 'MetroAlt_snapshot'

