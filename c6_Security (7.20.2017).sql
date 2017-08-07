/****************************
Login Authentication and Authroization
Login -- server user mapped to the login and is for a database

1. Windows Authentication -- Active directory
2. SQL authentiaction -- password, username

Roles -- collections of Permissions
Schema -- ownership of collection of objects


Community_Assist
> Admin
> Reviewers Employees
	- SELECT UPDATE DELETE INSERT DROP CREATE ALTER EXEC
> Clients
> General --- public
> Donors

What kind of views would people have?
Stored procedures, How interacts?


******************************/
use Community_Assist
Go
Create schema ClientSchema
go

--Create a view
create view ClientSchema.vw_GrantType
as
Select * from GrantType

select * from ClientSchema.vw_GrantType
go

--Create view.schema
Create view ClientSchema.vw_GrantStatus
go

--Create procedure
Create proc ClientSchema.usp_GrantStatus
@PersonKey int
As
Select GrantTypeName [GrantType]
, GrantRequestDate [Date]
, GrantRequestExplanation [Explanation]
, GrantRequestAmount [Amount]
, GrantRequestStatus [Status]
, GrantAllocationAmount [Allocation]
from GrantType gt inner join GrantRequest req
on gt.GrantTypeKey = req.GrantTypeKey inner join GrantReview rev
on req.GrantRequestKey = rev.GrantRequestKey
where PersonKey = @PersonKey

exec ClientSchema.usp_GrantStatus 1

--create a role
Create role ClientRole
Grant Select, exec on Schema::ClientSchema to ClientRole

Create role GeneralUserRole
Grant Select on GrantType to GeneralUserRole
Grant select on vw_Donations to GeneralUserRole
Grant insert on Person to GeneralUserRole

--Create Login
Create login Jody with password = 'P@ssw0rd1'
, default_database = Community_Assist

-- Create user 'Jody' under login 'Jody'
create user Jody for login Jody with default_Schema = ClientSchema
exec sp_addrolemember 'ClientRole', 'Jody'