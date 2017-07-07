--a2: Indexes, query Optimization
use MetroAlt

select [EmployeeLastName] ,[EmployeeFirstName] ,[BusRouteKey],
	[BusDriverShiftKey] ,[BusScheduleAssignmentDate], b.[BusKey],
	[BusTypeDescription], [Riders] From Employee e
	inner join BusScheduleAssignment bsa
	on e.EmployeeKey=bsa.EmployeeKey
	inner join Ridership r
	on r.BusScheduleAssigmentKey=bsa.BusScheduleAssignmentKey
	inner join Bus b
	on b.BusKey=bsa.BusKey
	inner join BusType bt
	on b.BusTypekey=bt.BusTypeKey
	where busrouteKey = 45
	and year(busScheduleAssignmentDate)=2014
	and month (busScheduleAssignmentDate)=6
	order by [BusScheduleAssignmentDate],
				BusDriverShiftKey,
				EmployeeLastName

create index ix_BSA on [dbo].[Ridership]([BusScheduleAssigmentKey])

create index ix_BSA2 on [dbo].[BusScheduleAssignment]([BusRouteKey])