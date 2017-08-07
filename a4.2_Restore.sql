--assignment4
--Do a full backup of the MetroAlt database.
backup database MetroAlt to disk =
				'C:\Backups\MetroAlt.bak'
				--with expiredate = '7/13/2017'

--Add a new record to Employee. 
--You can make up the details of the record. 
--Create a partial backup. 
Insert into Employee(EmployeeLastName, EmployeeFirstName, 
			EmployeeAddress, EmployeeEmail, EmployeeCity, EmployeeZipCode, EmployeeHireDate)
values ('YANG', 'HEETEE', '1701 Broadway', 'heetae@gmail.com', 'Seattle', '98122', GETDATE())

Insert into Employee(EmployeeLastName, EmployeeFirstName, 
			EmployeeAddress, EmployeeEmail, EmployeeCity, EmployeeZipCode, EmployeeHireDate)
values ('Y', 'H', '1701 Broadway', 'HTY@gmail.com', 'Seattle', '98122', GETDATE())
select * from Employee

Backup database MetroAlt to disk =
					'C:\Backups\MetroAlt.bak'
					with differential

--Add another record to Employee.
--Now Backup the log
--Restore the Database. (You will need to do it in sequence, Full, partial log.) Are the two records you added still there?
Insert into Employee(EmployeeLastName, EmployeeFirstName, 
			EmployeeAddress, EmployeeEmail, EmployeeCity, EmployeeZipCode, EmployeeHireDate)
values ('KIM', 'TAEHEE', '4225 11th ave', 'THK@gmail.com', 'Seattle', '98105', GETDATE())

Insert into Employee(EmployeeLastName, EmployeeFirstName, 
			EmployeeAddress, EmployeeEmail, EmployeeCity, EmployeeZipCode, EmployeeHireDate)
values ('JEONG', 'JIHOON', '4225 11th ave', 'RAIN@gmail.com', 'Seattle', '98105', GETDATE())

use master
backup log MetroAlt to disk =
				'C:\Backups\MetroAlt.log'
				with norecovery

restore database MetroAlt
from disk = 'C:\Backups\MetroAlt.bak'
with norecovery, file = 1

restore database MetroAlt
from disk = 'C:\Backups\MetroAlt.bak'
with norecovery, file = 2

restore log MetroAlt
from disk = 'C:\Backups\MetroAlt.log'
with recovery