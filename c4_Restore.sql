--7/11/2017

--Basic backup
Backup database Community_Assist to disk = 
			'C:\Backups\Community_Assist.bak'
			 with expiredate = '7/12/2017'

--Differential backup (only backup the changes)
use Community_Assist
create table afterBackup 
(
	afterBackupKey int identity(1,1) primary key,
	afterBackupTime datetime
)

insert into afterBackup(afterBackupTime)
values (GETDATE())

Backup database Community_Assist to disk =
			'C:\Backups\Community_Assist.bak'
			 with differential

--Backup the log
Backup log Community_Assist to Disk =
			'C:\Backups\Community_Assist.log'

use master

backup log Community_Assist to disk = 
			'C:\Backups\Community_Assist.log'
			with norecovery

--Restores
restore database Community_Assist 
from disk ='C:\Backups\Community_Assist.bak' 
with norecovery, file = 1 -- only do when multiple files are involved 1: full, 2:differential, 3: etcs.

restore database Community_Assist 
from disk ='C:\Backups\Community_Assist.bak' 
with norecovery

restore log Community_Assist 
from disk ='C:\Backups\Community_Assist.log' 
with recovery

--Restore to a point of time
Create database TEST
go
use TEST
go
create Table people
(
	PersonKey int,
	PersonLastName nvarchar(255),
	PersonFirstName nvarchar(255),
	email nvarchar(255)
)
insert into people (PersonKey, PersonLastName, PersonFirstName, email)
select PersonKey, PersonLastName, PersonFirstName, PersonEmail from Community_Assist.dbo.Person

select * from people

Backup database TEST to disk = 'C:\Backups\TEST.bak'
Backup log TEST to disk = 'C:\Backups\TEST.log'

update people
set PersonLastName = 'Smith'

use master
RESTORE LOG TEST
	FROM DISK = 'C:\Backups\TEST.log'
	WITH FILE=1, NORECOVERY, STOPAT = 'jul 11, 2017 2:10 PM';
RESTORE DATABASE TEST WITH RECOVERY;

select * from people