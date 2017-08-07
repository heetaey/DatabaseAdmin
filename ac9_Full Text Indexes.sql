use Master
create Database FullTextIndex

alter database FullTextIndex
Add filegroup FullTextCatalog

use FullTextIndex

create table TextTable
(
	TextTableKey int identity(1,1) primary key,
	TextExample nvarchar(255) 
)

Insert into TextTable(TextExample)
Values('For test to be successful we must have a lot of text'),
('The test was not successful. sad face'),
('there is more than one test that can try a man'),
('Success is a relative term'),
('It is a rare man that is always successful'),
('The root of satisfaction is sad'),
('men want success'),
('We successfully completed the test'),
('Sadly, the test was difficult')

Insert into TextTable(TextExample)
Values ('Best not to rest on ones successess'),
('The test is complete')

select * from TextTable
select *
  from sys.dm_fts_index_keywords (db_id(),object_id('TextTable'))
  order by document_count desc

create fulltext catalog testDescription
on Filegroup FullTextCatalog

Create fulltext index on TextTable(TextExample)
Key index [PK__TextTabl__B25F440D1C9D385A]
on testDescription with change_tracking auto

select TextTableKey, TextExample from TextTable
where Freetext(TextExample, 'sad')

select TextTableKey, TextExample from TextTable
where freeText(TextExample, 'Successful')

select TextTableKey, TextExample from TextTable
where Contains(TextExample, ' Formsof (inflectional, Complete)')

select TextTableKey, TextExample from TextTable
where Contains(TextExample, ' near (try, man)')

--within 3; proximity
select TextTableKey, TextExample from TextTable
where Contains(TextExample, ' near ((man, successful), 3)')