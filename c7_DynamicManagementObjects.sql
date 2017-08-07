select * from sys.databases

use Community_Assist
select * from sys.tables
select * from sys.procedures
select * from sys.schemas

select v.name, p.name
from sys.views v
inner join sys.schemas s
on v.schema_id = s.schema_id
inner join sys.procedures p
on p.schema_id = s.schema_id
where s.schema_id = 5

use PartitionExample
select * from sys.partitions