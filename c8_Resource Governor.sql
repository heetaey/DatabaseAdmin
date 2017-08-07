--7/27/2017
--ITC 226

--associating login jdoe with the group created.
create function sbsClassifier()
returns sysname with schemaBinding

begin
Declare @group sysname
if (SUser_name()) = 'jdoe'
	begin
		set @group ='sbsSSMSgroup'
	end
	return @group
end

Create Login jdoe with password = 'P@ssw0rd1',
default_database = AdventureWorks2014

use AdventureWorks2014
create user jdoe for login jdoe
Alter role db_datareader add member jdoe

--Whenever joe is logged in, joe can have min 20 - max 50 for memory.
select s.group_id, Cast(g.name as nvarchar(20)) [Resource Group]
,s.session_id
,s.login_name
,cast(s.host_name as nvarchar(20)) [Host Name]
,cast(s.program_Name as nvarchar(20)) [Program Name]
from sys.dm_exec_sessions s
inner join sys.dm_resource_governor_workload_groups g
on g.group_id = s.group_id
where g.name = 'sbsSSMSgroup'
order by g.name