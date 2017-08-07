--7/13/2017
--c5:Database Snapshots
use Master

create database Community_Assist_Snapshot
on (name = 'Community_Assist', 
filename= 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Community_Assist_snapshot.ds')
as snapshot of Community_Assist

use Community_Assist_Snapshot
select * from Person

use Community_Assist
update Person
set PersonFirstName = 'jason'
where Personkey = 

use Master
Restore database Community_Assist
from Database_snapshot = 'Community_Assist_snapshot'