--7/6/2017
--Partitions

use master
create database PartitionExample

use PartitionExample
go

--create filegroups
Alter Database PartitionExample
add FileGroup FG1
Alter Database PartitionExample
add FileGroup FG2
Alter Database PartitionExample
add FileGroup FG3

--add files to filegroups
Alter database PartitionExample
Add file (Name = FG1_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\PartitionExample_1.ndf', size = 2mb)
			to FileGroup FG1

Alter database PartitionExample
Add file (Name = FG2_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\PartitionExample_2.ndf', size = 2mb)
			to FileGroup FG2

Alter database PartitionExample
Add file (Name = FG3_dat, 
			Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\PartitionExample_3.ndf', size = 2mb)
			to FileGroup FG3

--create partition function
create partition function fx_DonationDate(datetime)
as
Range right
for values ('2/1/2010', '4/1/2010')
go

-- scheme determines which file groups the data will reside on
create partition scheme scheme_DonationDates
as partition fx_DonationDate
to (FG1, FG2, FG3)

create table partitionDonation
	(
		DonationKey int not null,
		PersonKey int,
		DonationDate Datetime not null,
		DonationAmount money,
		DonationConfirmation uniqueIdentifier null
	) on scheme_DonationDates (DonationDate) -- can be something like (Year(DonationDate)) with int

--truncate table partitionDonation
create clustered index ix_DonationDate on partitionDonation(DonationDate)

alter table partitionDonation
add constraint pk_partitionDonation
primary key (DonationKey, DonationDate)

insert into partitionDonation
(DonationKey, PersonKey, DonationDate, DonationAmount, DonationConfirmation)
select DonationKey, PersonKey, DonationDate, DonationAmount, DonationConfirmation
From Community_Assist.dbo.Donation

select * from partitionDonation
where $partition.fx_DonationDate(DonationDate) = 3