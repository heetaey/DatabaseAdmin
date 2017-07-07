use Community_Assist

select * from sys.key_constraints

Create index ix_GrantRequestDate on GrantRequest(GrantRequestDate)

Create table testTable 
(
	TestKey int identity(1,1),
	TestName nvarchar(255),
	constraint PK_Test primary key nonclustered (TestKey)
)

select * from GrantReview
create clustered index ix_Testname on testTable(testName)

create index ix_ReviewStatus on GrantReview(GrantRequestStatus)
where GrantRequestStatus != 'pending'


Select PersonFirstName, PersonLastName,
	GrantRequestDate, GrantTypeName, GrantRequestExplanation, GrantRequestAmount,
	GrantReviewDate, GrantRequestStatus, PersonLastName as Employee
	from Person p
	inner join GrantRequest gr
	on p.PersonKey = gr.PersonKey
	inner join GrantType gt
	on gt.GrantTypeKey = gr.GrantTypeKey
	inner join GrantReview grv with(nolock, index(ix_status))
	on grv.GrantRequestKey = gr.GrantRequestKey
	inner join Employee e
	on e.EmployeeKey = grv.EmployeeKey
	where GrantRequestStatus = 'Reduced'
	option (Merge Join)

create index ix_status on GrantReview(GrantRequestStatus)