--a3: Table Partitions
use master

--Create a new database with 5 file groups and one file in each group.
create database tablePartition
use tablePartition

Alter Database tablePartition
add FileGroup FG1
Alter Database tablePartition
add FileGroup FG2
Alter Database tablePartition
add FileGroup FG3
Alter Database tablePartition
add FileGroup FG4
Alter Database tablePartition
add FileGroup FG5

Alter database tablePartition
Add file (Name = FG1_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\tablePartition_ex1.ndf', size = 2mb)
			to FileGroup FG1

Alter database tablePartition
Add file (Name = FG2_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\tablePartition_ex2.ndf', size = 2mb)
			to FileGroup FG2
			
Alter database tablePartition
Add file (Name = FG3_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\tablePartition_ex3.ndf', size = 2mb)
			to FileGroup FG3

Alter database tablePartition
Add file (Name = FG4_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\tablePartition_ex4.ndf', size = 2mb)
			to FileGroup FG4

Alter database tablePartition
Add file (Name = FG5_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\tablePartition_ex5.ndf', size = 2mb)
			to FileGroup FG5

--create a table partition for the table.
--Divide the partition on the BusRouteShiftAssignmentDate.
--Partition it by Year (2012, 2013, 2014, 2015)
use tablePartition
create partition function fx_BusRouteShiftAssignmentDate(date)
as Range right
for values ('01/02/2012', '01/02/2013', '01/02/2014', '01/02/2015')

create partition scheme scheme_BusRouteShiftAssignmentDate
as partition fx_BusRouteShiftAssignmentDate
to (FG1, FG2, FG3, FG4, FG5)

--Create a table that has the same structure as BusRoutescheduleAssignment. 
create table partitionBSAD
(
	BusScheduleAssignmentKey int not null, 
	BusDriverShiftKey int,
	EmployeeKey int, 
	BusRouteKey int, 
	BusScheduleAssignmentDate date not null, 
	BusKey int
) on scheme_BusRouteShiftAssignmentDate(BusScheduleAssignmentDate)

--Import the data from BusRoutShiftAssignment into the new Table.
create clustered index ix_BSAD on partitionBSAD(BusScheduleAssignmentDate)

alter table partitionBSAD
add constraint pk_partitionBSAD
primary key (BusScheduleAssignmentKey, BusScheduleAssignmentDate)

insert into partitionBSAD
(BusScheduleAssignmentKey, BusDriverShiftKey, 
EmployeeKey, BusRouteKey, BusScheduleAssignmentDate, BusKey)
select BusScheduleAssignmentKey, BusDriverShiftKey, 
EmployeeKey, BusRouteKey, BusScheduleAssignmentDate, BusKey
from MetroAlt.dbo.BusScheduleAssignment

--Create a query that only queries the 2013 partition.
select * from partitionBSAD
where $partition.fx_BusRouteShiftAssignmentDate(BusScheduleAssignmentDate) = 3