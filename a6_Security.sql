--a6: Security
/*************************
Users?
> Employees
	> Bus Drivers	> Mechanic	> Dispatcher
	> Maintenance Engineer	> Accountant
	> IT	> Manager	> Public Relations
	> Lawyer	> Detailer
> General -- Public


*************************/
use MetroAlt
go
Create schema EmployeeSchema
go

---------------------------------DRIVERS------------------------------------------
---creates role for Drivers
create view EmployeeSchema.vw_BusDrivers
as 
select distinct [BusDriverShiftName]
, [BusDriverShiftStartTime]
, [BusDriverShiftStopTime] 
, [BusRouteZone] from BusDriverShift bds
inner join BusScheduleAssignment bsa
on bds.BusDriverShiftKey = bsa.BusDriverShiftKey
inner join BusRoute br
on bsa.BusRouteKey = br.BusRouteKey

select * from EmployeeSchema.vw_BusDrivers

create role DriverRole
grant select, exec on schema::EmployeeSchema to DriverRole

Create Login D_heetae with password = 'P@ssw0rd1'
, default_database = MetroAlt

create user Heetae for login D_heetae with default_Schema = EmployeeSchema
exec sp_addrolemember 'DriverRole', 'D_Heetae'

---------------------------------MANAGER-----------------------------------------
---create for procedure for Managers
go
create proc EmployeeSchema.usp_EmployeeManager
@EmployeeLastName nvarchar(255)
as
select [EmployeeLastName], [EmployeeFirstName]
, [EmployeeAddress], [EmployeeCity], [EmployeeZipCode]
, [EmployeePhone], [EmployeeEmail], [EmployeeHireDate]
, [PositionName], [EmployeeHourlyPayRate]
, [EmployeePositionDateAssigned] from Employee e
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position p on ep.PositionKey = p.PositionKey
where EmployeeLastName = @EmployeeLastName

--create role for managers
Create Role ManagerRole
Grant select, exec, insert on Schema::EmployeeSchema to ManagerRole
Grant select on Employee to ManagerRole
Grant select on EmployeePosition to ManagerRole
Grant select on Position to ManagerRole

create login M_heetae with password = 'P@ssw0rd1'
, default_database = MetroAlt

create user MHeetae for login M_heetae with default_Schema = EmployeeSchema
exec sp_addrolemember 'ManagerRole', 'MHeetae'

exec EmployeeSchema.usp_EmployeeManager 

--------------------------------GENERAL USERS--------------------------------
create role GeneralUserRole
Grant Select on BusRoute to GeneralUserRole
Grant Select on Fare to GeneralUserRole
Grant Select on BusBarn to GeneralUserRole
 
create login G_heetae with password = 'P@ssw0rd1'
, default_database = MetroAlt

create user GHeetae for login G_heetae
exec sp_addrolemember 'GeneralUserRole', 'GHeetae'