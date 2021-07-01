--service account for ssrs_user/reports_user1

--//********************************************************
--Order of operations
--1 - From       Choose and join tables to get base data
--2 - Where      Filters the base data
--3 - Group By   Aggregates the base data
--4 - Having     Filter the aggregated data
--5 - Select     Returns the final data
--6 - Order by   Sorts the final data
--7 - Limit      Limits the returned data to a row count
--//********************************************************


insert into Developers_Views.._refBSAData
values ('Jared Early','BSA Analyst II','Brian Roth','Digital Api',1,76)

--//SQL Training 1

--Server = amt-dbwidget01
--Database = Developers_views
--Table = _refBSAData
--Select
--From
--Where
--Distinct
--Order By
--and
--or
--like
-- =
--<>
--in
--not in


--pull all data from _refBSAdata table
select
	*
From
	Developers_Views.._refBSAData



--pull data for all BSAs with a manager of Brian
select
	*
From
	Developers_Views.._refBSAData
Where
	Manager like '%BRian%'

select
	*
From
	Developers_Views.._refBSAData
Where
	Manager = 'BRian Roth'




--pull data for all BSAs with a manager of Brian Roth and title of BSA II
select
	*
From
	Developers_Views.._refBSAData
Where
	Manager = 'BRian Roth'
	and
	BSATitle = 'BSA II'


--pull data for all BSAs with a manager of Brian Roth OR title of BSA II
select
	*
From
	Developers_Views.._refBSAData
Where
	Manager = 'BRian Roth'
	or
	BSATitle = 'BSA II'


--SHow a list of BSAtitles but don't repeat them
select
	distinct
	BSATitle
from
	Developers_Views.._refBSAData


--SHow a list of all BSA data where BSA title is EDI Analyst or BSA I
select
	*
from
	Developers_Views.._refBSAData
Where
	(BSATitle = 'EDI Analyst'
	or BSATitle = 'BSA I')

--SHow a list of all BSA data where BSA title is EDI Analyst or BSA I
select
	*
from
	Developers_Views.._refBSAData
Where
	BSATitle in ('EDI Analyst','BSA I')


--SHow a list of all BSA data where BSA title is NOT EDI Analyst or BSA I
select
	*
from
	Developers_Views.._refBSAData
Where
	BSATitle not in ('EDI Analyst','BSA I')







--//********************************************************************************************************

--//SQL Training 2

--//Server = amt-dbwidget01
--//Database = Developers_views
--//Table = _refBSAData
-- as 'X'
--Table = _ref_ado_workitemdata
-- is null
-- is not null
-- >
-- <
--Count()
--Sum ()
--Group by

--only show top 10 records
select 
	top 10 *
from
	Developers_Views.._refBSAData

--run BSA table but have the BSA column read as employeename

select
	BSA as EmployeeName,
	BSATitle,
	Age
from
	Developers_Views.._refBSAData

--pull all names where age isn't null
select
	*
from
	Developers_Views.._refBSAData
where
	Age is not null

--pull all names where age is null
select
	*
from
	Developers_Views.._refBSAData
where
	Age is null


--count the number of BSAs
select
	count(BSA) as 'Number of BSAs'
from
	Developers_Views.._refBSAData


--count the number of BSAs by title
select
	count(BSA) as 'Number of BSAs',
	BSATitle
from
	Developers_Views.._refBSAData
Group by
	BSATitle



--pull back all task workitems where original estimate has a null value
select
	*
 from
	Developers_Views.._ref_ado_workitemdata
Where
	OriginalEstimate is null
	and WorkItemType = 'task'


--pull back all task workitems where original estimate does NOT have a null value
select
	*
 from
	Developers_Views.._ref_ado_workitemdata
Where
	OriginalEstimate is not null
	and WorkItemType = 'task'


--count the number BSAs by title
select
	count(BSA) as '# of BSA for title',
	BSATitle
from
	Developers_Views.._refBSAData
Group by
	BSATitle
Order by
	[# of BSA for title] desc



--pull back all tasks created by Brian and sum the hours completed by person assigned to
select
	sum(CompletedWork) as 'Completed hours by individual',
	Assignedto
 from
	Developers_Views.._ref_ado_workitemdata
Where
	WorkItemType = 'task'
	and CompletedWork is not null
	and Createdby = 'BRian Roth'
group by
	Assignedto
Order by
	[Completed hours by individual] desc
	








--****************************************************************************************************************
--//SQL Training 3

--//Server = amt-dbwidget01
--//Database = Developers_views
--//Table = _refBSAData
--Declare @<Insert Variable Name> nvarchar(100) = '<Insert Value'>
--CAST (<Insert Column Name> as <Insert Data Type>) as '<Insert new column Name>'
--Select top 10 * from <DB..Table>
--(Case <Insert Column Name> when 'X' then 'Y' else 'Z' end)
--Between
--isnull()


Declare @Title as varchar(50)
set @Title = 'BSA III'


--pull all BSA IIs
select * from Developers_Views.._refBSAData
Where
	BSATitle = @Title

--pull all BSA IIs who report to Brian
select * from Developers_Views.._refBSAData
Where
	BSATitle = @Title
	and Manager = 'Brian Roth'

--pull bACK WORKITEM ID AND ORIGINAL ESTIMATE COLUMNS WHERE ORIGINAL EST IS NOT NULL
select 
	WorkItemId, 
	isnull(OriginalEstimate,0) as 'Original estimate',
	cast(originalestimate as int) as origest2
from Developers_Views.._ref_ado_workitemdata 
where 
	WorkItemType = 'task'
	--AND OriginalEstimate is not null
	and OriginalEstimate between 1 and 3


--Case Statement pull back name and title but we only want to see if they are a manager or not
select 
	BSA,
	BSaTITLE,
	Case 
		when BSATitle in ('BSA I','BSA II','BSA III') then 'IC'
		WHEN BSATitle = 'edi ANALYST' THEN 'EDI PERSON'
		WHEN BSATitle = '' THEN 'ic2'
		Else 'Manager'
	End
from Developers_Views.._refBSAData


--****************************************************************************************************************
--//SQL Training 4

--//Server = amt-dbwidget01
--//Database = Developers_views
--//Table = _refBSAData
--GetDate()
--Table _ref_VSTSData_Teams
--Inner Join


select 
	top 23 * 
from 
	Developers_Views.._ref_ado_workitemdata 
where 
	cast(CreatedDate as date) = cast(GETDATE() as date)
order by 
	createddate desc 

--join workdata table to teams table
select 
	top 23 * 
from 
	Developers_Views.._ref_ado_workitemdata 



--****************************************************************************************************************
--//SQL Training 5
--//*******************New commands******************

--Table _ref_MPOProjectData_WorkRequests
--Left Join


--Create report of WRs that do and do not have VSTS workitems ordered by WR priority

select top 1 *
from developers_views.._ref_Vstsdata with (NOLOCK)

select
	WR.WorkRequestID,
	WR.Title,
	WR.WorkRequestStateValue,
	VS.WorkItemID,
	VS.Title,
	VS.WorkItemType
from developers_views.._ref_MPOProjectData_WorkRequests WR with (NOLOCK)
	left join developers_views.._ref_Vstsdata VS with (NOLOCK)
		on WR.WorkRequestID = VS.WorkRequestNumber

WHERE
	WR.Created > '2/1/2019'



--****************************************************************************************************************
--//SQL Training 6

-- into #TempTable

select
	*
into #TempTable1
from
	developers_views.._refbsadata
Where
	Manager = ''


--****************************************************************************************************************
--//SQL Training 7
-- 7.1 eomonth()
-- 7.2 RowNumber() over(Partition by <insert_Column>) as title
-- 7.2 ;with table
-- 7.3 sum(column) over(Partition by <insert_Column>) as title
--// The above is different than a group by because instead of partitioning the data by all columns in the group by, youre only partition by 1 column
-- avg()
-- stdev()
-- var()
-- convert(<insert_new_data_type>,column)
--union (distinct)--> The UNION command combines the result set of two or more SELECT statements (only distinct values)
--UNION ALL command combines the result set of two or more SELECT statements (allows duplicate values).
--intersect all --> the number of overlapping elements

--will only return where last name is the same in both tables (only distinct values)
select last_name, 'Green' as 'Color' from Developers_Views..staff where gender = 'Female'
union
select last_name, 'Red' as 'Color' from Developers_Views..staff where gender = 'MAle'



--allows duplicate values so this will pull all last names (allows duplicate values)
select last_name, 'Green' as 'Color' from Developers_Views..staff where gender = 'Female'
union all
select last_name, 'Red' as 'Color' from Developers_Views..staff where gender = 'MAle'

--7.1
select
	PolicyID,
	DateExpiration
	dateeffective,
	EOMONTH(DateExpiration) as LastDayofExpMonth
from Premdat..PolicyData with (nolock)
where
	AgtId <> 47
	and DateExpiration > Getdate()


--7.2
--Premium by policyid and the row_number BY state

;with Prem as

(
select
	PolicyID,
	GovState,
	PremAnnual,
	ROW_NUMBER() over(partition by Govstate order by premannual desc) as RowNumForGreatestPrembyState
from 
	Premdat..PolicyData with (nolock)
where
	AgtId <> 47
	and DateExpiration > Getdate()
	and PremAnnual >0
	and GovState <> '0'

)
select*
from 
	Prem
where
	RowNumForGreatestPrembyState <= 2

Order by
	--GovState,
	PremAnnual desc


--7.3

--WC premannual by state and policy per agent group
select
	distinct
	GovState,
	Agtgroup,
	SUM(convert(bigint,Premannual)) over(Partition by Govstate) as PremPerstate,
	count(policyid) over (partition by agtgroup) as policyPerAgtgroup
from
	Premdat..Policydata with (nolock)

Where
	GovState is not null
	and DateExpiration > Getdate()
	and AgtId <> 47

Order by 
	govstate, agtgroup


--CPP Premannual by gov state 
--policyid by agtcontact

select distinct
	GovState,
	agtcontactid,
	sum(Premannual) over(partition by Govstate) as PrembyGovState,
	count(PolicyID) over(partition by agtcontactid) as policiesbyagt
from cpp..CPPPolicySubData with (nolock)
where
	DateExpiration is null

order  by
	PrembyGovState desc


--CPP Premium highest by state
with CPPPrem as
	(
		select
		distinct
			PC.PolicyID,
			GovState,
			PremAnnual,
			ROW_NUMBER () over (partition by govstate order by premannual desc) as 'PremRankPerSt'
		from
			CPP..CPPPolicySubData d with (nolock)
		join
			CPP..CPPPolicyCore PC with (nolock)
		On
			d.PolicyID = pc.PolicyID
			and PC.AgtID <> 47
		Where
			GovState not in ('','AB','0K')
	)

select
	*
from 
	cppprem
where 
	PremRankPerSt in (1,2)
Order by
	GovState,
	[PremRankPerSt] 


--//******************************************************************************************************************************************
--SQL Training Day 8

-- server = amt-dbwidget01
-- developers_views..department
-- Developers_Views..staff
-- Developers_Views..company_regions
--8.1 Lower(ColumnName) to set all letters to lower case
--8.1 Upper(ColumnName) to capitalize all letter
--8.2 Trim(columnName) to remove whitespace from the results like ' Result' would return 'result'
--8.3 Title, (title like '%Manager%') is_manager will return the title and boolean column for if the title is a manager
--8.4 Substring(columnresult,1,3) test_string will return on the 3 characters starting from the 1st character
--8.5 subquery in select statement from the same table
--//select s1.column1, (select avg(s2.column1) where s1.column1 = s2.column1) as avg per column
--8.6 subquery in from clause where we want to limit the results being used in a group by
--8.7 subquery in where clause


select top 1 * from developers_views..department
select top 1 * from developers_views..staff
select top 1 * from developers_views..company_regions

--8.1

select
	Lower(Name) as DeptName
from developers_views..department

select
	Upper(Name) as DeptName
from developers_views..department

--8.4

select
'abcdefghijkl' as test_string

select
SUBSTRING('abcdefghijkl',2,3) test_string

select
	job_title,
	substring(Job_title,11,10) as title
from Developers_Views..staff
where	
	job_title like '%assistant%'

--8.5

SELECT s1.last_name, 
       s1.salary, 
       s1.department, 
       --showing avg salary for department where department from the s1 table = salary from s2 table 
       (
	   SELECT Round(Avg(salary), 0) 
        FROM   developers_views..staff s2 
        WHERE  s2.department = s1.department
		) AS AvgSalaryperDept 
FROM   developers_views..staff s1 

Order By
	s1.department desc, s1.salary desc

--8.6 subquery in from clause where we want to limit the results being used in a group by

select
	s1.department,
	round(avg(s1.salary),0) as avgsalary
From
--Subquery assuming all execs make more than $100,000
	(select
		Department,
		salary
	from Developers_Views..staff
	Where
		salary > 100000) s1

group by 
	s1.department

--8.7

select* 
from Developers_Views..staff
where 
	region_id =  (select region_id from Developers_Views..company_regions where company_regions = 'Northeast')

select
	department,
	last_name, 
	salary
from Developers_Views..staff s1
where
	s1.salary = (select
				Max(salary) 
				from Developers_Views..staff)


--//******************************************************************************************************************************************
--SQL Training Day 9

--9.1 Create View - CREATE VIEW <View_Name> as  Select* from table 1 join table 2 on 1.col = 2.col
--9.2 Grouping Sets - Can group by a single column, or multiple - so I can find the avg cost of a quote by state, by state AND uwofc, and uwofc
--//GROUP BY
--//GROUPING SETS (
--//   (column1, column2),
--//   (column1),
--//   (column2) )
--9.3 Rollup - Group by rollup(column1,column2) - can see extra ROWS for the totals by individual column (Totals and Subtotals)
--9.4 Cube - Use ALL possible combinations in group by
--9.5 Offset, Fetch Next - Offset 0 Rows Fetch Next 2 Rows
    

--9.1
Create View staff_div_reg_country AS
	select
		s.*, cd.company_division, cr.company_regions, cr.country
	from 
		Developers_Views..staff s
	Left Join
		Developers_Views..company_divisions cd
	On 
		s.department = cd.department
	Left Join
		Developers_Views..company_regions cr
	On
		s.region_id = cr.region_id

--9.2
select
	gender,
	department,
	Avg(Salary) as avgSalary
from Developers_Views..staff
group by
	grouping sets ((gender,department),(GendeR),(department))
Order by 
	avgSalary desc

--9.3

select
	country,company_regions, count(*) as #ofStaffPerCountryandRegion
from
	Developers_Views..staff_div_reg_country
group by
--	Regular group by BUT adding a roll up so we can see extra ROWS for the totals by individual column 
-- (Total Staff count, total for country, total for region and country)
	rollup(country,company_regions)
Order by
	country, company_regions

--9.4

select
	company_division,company_regions, count(*) as #ofStaffPerdivisionandRegion
from
	Developers_Views..staff_div_reg_country
group by
--	Regular group by BUT will give every possible combination of rolling up the data
	cube(company_division, company_regions)
Order by
	company_division, company_regions

--9.5

select
	last_name, job_title,salary
from Developers_Views..staff
order by
	salary DESC
--Start with the 1st row
offSET 0 ROW
--Bring back next 2 rows
FETCH NEXT 2 rows ONLY


--//******************************************************************************************************************************************
--SQL Training Day 10

--10.1 - first_value(column) over (partition by)
--10.2 - Rank() Over (partition by column order by column)
--10.3 - Lag(column) Over (partition by column order by column) - Refers to the Row which came BEFORE the result. (next higher salary)
--10.4 - Lead(column) Over (partition by column order by column) - Refers to the Row which came AFTER the result. (Next lower salary)
--10.5 - ntile(int) Over (partition by column order by column)....will set up numbers by percentile

--10.1

select
	last_name,
	Department,
	salary,
	FIRST_VALUE(salary) over (partition by department order by last_name) as salarybydept
from Developers_Views..staff
order by department, last_name

--10.2
select
	last_name,
	Department,
	salary,
	rank() over (partition by department order by salary desc) as SalaryRankbyDept
from Developers_Views..staff
order by 
	department, SalaryRankbyDept

--10.3
select
	last_name,
	Department,
	salary,
	--Refers to the Row which came PREVIOUSLY/Above the current row result. (next higher salary)
	lag(salary) over (partition by department order by salary desc) as NextHigherSalary
from Developers_Views..staff
order by 
	department

--10.4
select
	last_name,
	Department,
	salary,
	--Refers to the Row which cones NEXT/before the current row result (Next lower salary)
	lead(salary) over (partition by department order by salary desc) as NextLowerSalary
from Developers_Views..staff
order by 
	department


--10.5
select
	last_name,
	Department,
	salary,
	ntile(2) over (partition by department order by salary desc) as tile
from Developers_Views..staff
order by 
	department

select
	last_name,
	Department,
	salary,
	ntile(2) over (order by salary desc) as tile
from Developers_Views..staff
order by 
	department


--//*********************************************************************************************************************************************
--SQL Day 11 
-- exists
--training to create tables / alter tables / insert records into a table / update table record / drop a table
--//*********************************************************************************************************************************************

--write a sql query using exists function in the where clause for person who have adopted pets
--The result of EXISTS is a boolean value True or False ....the select can be anything after select...I just choose *
select
	*
from 
	Developers_Views..z_Persons P
where
	exists (
			select * 
			from Developers_Views..z_adoptions 
			where 
				Adopter_Email = P.Email
			)

--//*********************************
--Create table

--CREATE TABLE table_name
--(
--column_name1 data_type(size),
--column_name2 data_type(size),
--column_name3 data_type(size),
--)


Create table developers_views.dbo.NicoleTestTable
(
	Name varchar(50) not null,
	age int not null,
	primary key (NAme)
)

select* from  developers_views.dbo.NicoleTestTable
--//*********************************
--Insert INTO (add records to a table)

INSERT INTO 
	developers_views.dbo.NicoleTestTable (Name,age)
values 
	('Nicole Reents','23'),
	('Brian','33')


--//*********************************
-- Drop table (Delete)

IF OBJECT_ID('Developers_Views.dbo.NicoleTestTable') IS NOT NULL Drop table Developers_Views.dbo.NicoleTestTable

--//*********************************
--Alter table (add or remove columns)

Alter Table Developers_views..NicoleTestTable
Add height_inches int

--//****************************
--Update
select *
from Developers_Views..staff

Update
	Developers_Views..staff
Set
	salary = 75000
where
	last_name = 'Kelley' 
	and department = 'Computers'

--//*********************************************
-- delete function if (delete rows from a table)
Begin Tran
Delete from Developers_Views.._ref_REST_VSTSTeamFieldValues
Where
    TeamId = '9F91E6F4-6B21-498E-8D0B-913A5A9B5B57'
    and TeamFieldValue in ('Amtrust\ETS\AOMobile\External Facing Team 3','Amtrust\ETS\Digital API')
 
if @@ROWCOUNT <> 2
	BEGIN
		print 'something went wrong'
		Rollback Tran
	END
Else
	BEGIN
		print 'Rows deleted'
		Commit Tran
	END

--Trans update
Begin Transaction

update Authors
set
	Address = '700 willow street',
	city = 'Buffalo',
	State = 'NY',
	zip = '30951'
Where
	LastName = 'Couch'
	and PhoneNumber = 2164442222

If @@ROWCOUNT = 1
	Begin
		COmmit Transaction
		print 'Updated record'
	End
Else
	Begin
		Rollback Transaction
		print 'no updated records'
	End
--test
select* from Developers_Views..Authors



   
--//***********************************************************
-- SQL Day 12	
-- Stored Procedures --> procs can update/insert/delete/selete while function cannot insert/update/delete
--//***********************************************************


--//CREATE the stored Proc
--Create Procedure myTest
--As
--BEGIN
--select 'Hello'
--END

--//Execute the Stored PRoc (can do this in 2 wyas)
--execute mytest
--exec mytest


--//Alter the stored proc
Alter procedure Mytest
as
Begin
Select 'Hello World this is a test to run with and without go' as 'Text'
end

--Add a GO "Keyword" to let the machine know these are two chunks of code
Go

execute mytest

--//Return keyword
create procedure dbo.Mytest
as
Begin
Select 'Return' as 'Text'
--Add Return keyword
Return 1
end

execute dbo.mytest

Go
declare @return_value as int
execute @return_value = myTest
select @return_value


--//Stored Procedure with input parameter
Alter procedure Mytest2 (@Param1 as int, @param2 as varchar(50))
as
Begin
Select @Param1 as 'Number', @param2 as 'text'
Return 1
end

Go

--No paranthesis when passing parameters
exec mytest2 12, yo


--//Stored Procedure with output paramater
Alter procedure Mytest1 (@Param1 as int OUTPUT)
as
Begin
Select @Param1 as 'Number'
set @Param1 = 26
end

Go

Declare @X as int = 13
exec mytest1 @x OUTPUT


--after excuting the stored proc, then this is what happens....pass in 13 to the stored proc, then it is set to 26...so when you select X you get 26
Select @X


--//PRocedure with transactions
Alter Proc addAuthor (@First varchar(50), @last varchar(50), @phone nvarchar(12))
As
Begin
	Begin Transaction

		Insert into Developers_Views..Authors(FirstName,LastName,PhoneNumber,Active)
		Values (@First,@last,@phone,1)

	if @@ROWCOUNT <> 1
		Begin
			Rollback Transaction
			print 'Did not add record'
		End
	Else
		Begin
			Commit Transaction
			print 'Record added'
		End
End

go

execute addAuthor 'Tim','Couch',2164442222

go

select* from developers_views..authors

--Create Stored proc --> execute stored proc --> select from that table to test updates

Create Procedure addBSA (@Name varchar(50), @Manager varchar(50), @Title varchar(50), @Team varchar(50))
As
Begin
	Begin Transaction
		insert into Developers_Views.._refBSAData(BSA,Manager,BSATitle,team)
		values (@Name, @Manager, @Title, @Team)

	if @@ROWCOUNT = 1
		begin
			commit transaction
			print 'Record added for ' + @Name
		End
	Else
		BEgin
			Rollback Transaction
			print 'No records added'
		End
End

Execute addBSA 'New BSA','Brian Roth','BSA III','Fake Team'
go
select * from Developers_Views.._refBSAData

Create Proc dbo.ActiveAuthors
As
Begin
	Select*
	from
		Developers_Views..Authors
	Where
		Active = 1
End

execute dbo.ActiveAuthors

Create Proc dbo.AddAuthor


--//***********************************************************************************************
--SQL Day 13
--Functions
--//************************************************************************************************

--Creating a function

create function dbo.testFunc()
returns int
as
Begin
	Return 7
End

go

--test running function.
select dbo.testFunc()






-- Create a function with input values to return an address:

ALter FUNCTION dbo.formatAddress
--func takes 4 inputs
(@street as varchar(50),
 @city as varchar(50),
 @state as varchar(50),
 @zip as varchar(50)
 )
 --function will returns a single piece of text (scalar-valued)
 RETURNS varchar(255)
 AS

 BEGIN

	IF (@street IS NULL OR  
		@city IS NULL OR  
		@state IS NULL OR  
		@zip IS NULL)
		
		RETURN 'Incomplete Address'
    --Will change the state
	SET @state = (
		CASE @state
			WHEN 'LA' THEN 'Louisiana'
			WHEN 'NY' THEN 'New York'
			WHEN 'CA' THEN 'California'  
		END 
				)
		 
	RETURN @street + ' ' + @city + ', ' + @state + ' ' + @zip 
 END

--execute the function with the 4 inputs to verify it works

SELECT  dbo.formatAddress ('100 Main', 'Buffalo', 'NY', '39117')

--Combine the function and a regular select statement
select 
	FirstName,
	LastName,
	dbo.formataddress([Address],[City],State,Zip) as 'Formatted Address'
from Developers_Views..Authors




--//***************************************************************************************************************
-- SQL Day 14
-- Triggers
-- "After" trigger executes after insert, update or delete function  --> allow state to execute and then take over
-- examples with tables developers_views.dbo.categories and developers_views.dbo.products
-- "Instead of" trigger will block original statement and leave the data unchanged
--//***************************************************************************************************************
select* from developers_views.dbo.categories 
select* from developers_views.dbo.products

--creating a trigger where if records on the category table are set to inactive that we also set the products to inactive --> vice versa
ALter Trigger dbo.CategoryDeactivation
on dbo.categories
After Update
as
Begin
	
	Declare @isActive as bit

	--setting the active column from from the category table as bit variable
	select @isActive = Active
	--temporary table created automatically in the trigger which contains all of the new info from the update
	from inserted

	--if the active in category table is 0, then we update the corressponding categoryid in the product table to 0
	if(@isActive = 0)
		Update dbo.Products
		set active = 0
		where categoryid in (select categoryid from inserted)

	--if the active in category table is 1, then we update the corressponding categoryid in the product table to 1
	if(@isActive = 1)
		Update dbo.products
		set active = 1
		where categoryid in (select categoryid from inserted)


End

--run update statement on categories tables as a test

update Developers_Views..categories set active = 1 where categoryid = 1

go
--categoryid = 1 active is set to 0....this should update categoryids = 1 to make active  = 1 on those 3 productids
select* from Developers_Views..categories
go
select* from developers_views.dbo.products

--"Instead of" trigger will block original statement and leave the data unchanged
-- Business rule --> cannot delete a category from the categories table (e.g. delete from Developers_Views..categories where categoryid = 1)

Alter Trigger dbo.StopCategoryDelete
on dbo.categories
Instead of delete
as
Begin
	Update Categories
	set Active = 0
	where 
		CategoryID in (select CategoryID from deleted)
End

GO

--test to delete try to delete a category
Delete from Developers_Views..Categories where CategoryID = 1

go

--ensure the record wasn't delete but was instead updating to set active to 0
select* from developers_views.dbo.Categories



--//*******************************************************************************************************
-- SQL Day 15
-- Import a flat file (excel) to create a table under .dbo schema
-- Flat file was uploaded into table called dbo.students
-- Creating more complex real world examples of procs for inserts/updates/deletes
-- Creating a log table and using it for the proc
--//******************************************************************************************************

--Creating a proc with 2 business rules
--rule 1 --> ensure the ID doesnt exsits
--rule 2 --> ensure the GPA is between 0 and 4 with 2 decimal places

ALTER PROCEDURE [dbo].[Students_Insert]
(	@ID int,
    @LASTNAME varchar(50),
    @FIRSTNAME varchar(50),
    @STATE varchar(50),
    @PHONE varchar(50),
    @EMAIL varchar(50),
    @GRADYEAR int,
    @GPA decimal(20,10),
	@PROGRAM varchar(50),
	@NEWSLETTER bit
)
AS
BEGIN

	--Check to make sure the ID does not already exist
	--If it does, return error
	DECLARE @existing AS int
	SET @existing = 
		--going to count the number of records in the existing table which have IDs which match the possible insert
		(SELECT count(ID) FROM Students WHERE ID = @ID)
	
	IF @existing > 0
	BEGIN
		RAISERROR ('ID already exists',1,1)
		RETURN 0		
	END

	--Format GPA as 2 decimal places
	DECLARE @TwoDecimalGPA AS DECIMAL(3,2)
	SET @TwoDecimalGPA = CAST(@GPA as numeric(3,2))

	--Make sure GPA is within range
	IF ((@TwoDecimalGPA > 4) OR (@TwoDecimalGPA < 0))
	BEGIN
		RAISERROR ('GPA value is invalid', 1, 1)
		RETURN 0
	END	 

Begin Transaction
		Declare @Last_name as varchar(50)
		set @LASTNAME = @LASTNAME

	--Attempt insert
INSERT INTO [dbo].[Students]
           ([ID]
           ,[LASTNAME]
           ,[FIRSTNAME]
           ,[STATE]
           ,[PHONE]
           ,[EMAIL]
           ,[GRADYEAR]
           ,[GPA]
           ,[PROGRAM]
           ,[NEWSLETTER])
     VALUES
           (@ID
           ,@LASTNAME
           ,@FIRSTNAME
           ,@STATE
           ,@PHONE
           ,@EMAIL
           ,@GRADYEAR
           ,@TwoDecimalGPA
           ,@PROGRAM
           ,@NEWSLETTER)

		
		   --check to see if insert occured 
		   --and return status
		IF @@ROWCOUNT = 1
			BEgin
				Print 'Record was added for ' + Cast(@LAst_Name as varchar(50))
				Commit Transaction				
			End
		ELSE 
			Begin
				Rollback Transaction
				RETURN 0
				Print 'Not the correct row count of 1'
			End
END


GO

--execute stored proc
EXEC dbo.Students_INSERT  
	'555513131', 
	'BRian', 
	'Rothbone', 
	'Louisiana', 
	'(337) 555-1234', 
	'martin.guidry@alumni.rouxacademy.com', 
	'2011', 
	--Will fail because GPA if above 4.0
	4.0, 
	'Computer Science', 
	'1' 

GO

SELECT* FROM Developers_Views..Students WHERE ID = '5555555'


--Create a procedure to update Cell phone number for a student if the ID exists

Alter Procedure dbo.StudentUpdateCell 
	(@ID int, 
	@Phone varchar(50))
As
Begin

Declare @exists as int
set @exists = (select count(ID) from Developers_Views..Students where ID = @ID)

IF @exists <> 1
	raiserror('ID does not exist',1,1)

		

	Begin Transaction
		Update 
			Developers_Views..Students
		set
			PHONE = @Phone
		Where
			ID = @ID

		if @@ROWCOUNT = 1
			Commit Transaction
		else
			Begin
				Raiserror('Not committed',1,1)
				rollback transaction
			end
		End

execute dbo.StudentUpdateCell 2, '(216)548-2559'

go

Select* from Students order by id desc


--Delete stored procedure --> ensure ID exists --> log the results to the log table (user / Event / date)
--create logging table

Create Table developers_views.dbo.studentlog
(
	LogID int identity (1,1) PRimary Key,
	[User] varchar(100) not null,
	[Event] varchar(max) not null,
	[Date] datetime not null
)

Alter Procedure dbo.delete_students (@ID as int)
As
Begin

Declare @user as Varchar(50)
Set @User = SUSER_NAME()

Declare @ValidID as Int

set @ValidID =  (select count(id) from dbo.Students where ID in(@ID))
IF @ValidID <> 1
Begin
	Raiserror('ID does not  exist',1,1)
	Return 0
End

Begin Transaction

delete from dbo.Students
where
	ID = @ID


if @@ROWCOUNT = 1
	Begin
		Print ('ID ' + cast(@ID as varchar(50)) + ' has been deleted')
		Commit Transaction
		insert into dbo.studentlog ([User],[Event],[Date])
			values(@user,('Deleted ID ' + cast(@ID as varchar(10))),GETDATE())
	End
Else
	Begin
		Print (cast(@ID as varchar(50)) + ' has Not been deleted')
		Rollback transaction
		--Return 0
	End
End

select* from Students order by ID

execute dbo.delete_students 443

go
select* from Students order by ID
SElect* from dbo.studentlog


--//****************************************************************************
--SQL Day 16 TRY and CATCH
--//****************************************************************************

Begin Try
	--Code to execute
End Try
Begin Catch
	--Code to run if Try block encounter an error
	--If no errors are encounter then nothing else happens
End Catch
	


--simple example with Developers_Views.dbo.students where NONE of the columns can contain nulls --> insert a new lastname with insert statement and no other data
--select* from Developers_Views.dbo.Students

--Query will error because the table does NOT accept Null values
insert into 
		Developers_Views..Students (ID,LASTNAME,FIRSTNAME)
	values
		(12000,'Roth',null)

--Add Try catch

Begin Try
	Begin Transaction
		insert into 
			Developers_Views..Students (ID,LASTNAME,FIRSTNAME)
		values
			(12000,'Roth',null)
	IF @@ROWCOUNT <> 1
		Begin
			RollBack Transaction
			print 'No records were added'
		End
	Else
		Begin
			Commit Transaction
			PRint 'Record was added'
		End

End Try
Begin Catch
	--Can simply print a message or get errors
	--print 'There was a problem and records we not added'
	Select
		ERROR_NUMBER() as 'Error Number',
		Error_MEssage() as 'Error Message',
		ERROR_SEVERITY() as 'Error Severity',
		ERROR_STATE() as 'Error State',
		ERROR_LINE() as 'Error Line',
		ERROR_PROCEDURE() as 'Error PRocedure',
		XACT_STATE() as 'Transaction state'
End Catch
	


--//*****************************************************************************************************
--SQL Day 17
--Create a table, insert records, create a proc with trans & try catch, with rules
--Create a transaction in a try catch with multiple transactions
--//****************************************************************************************************


--Create a table with 2 columns --> 1 for ID and 1 for her balance and enter values for $50, $200, and $350
--Procedure to move moneny into an account when the 3 criterias are ment
--Ensure the from account has enough funds for the transfer
--Ensure the from account exists
--Ensure the to account exists

Create table developers_views.dbo.Bankaccounts
(
	AccountID int not null PRIMARY Key,
	Balance decimal(18,2)
)

insert into 
	Developers_Views..Bankaccounts
values
	(1,50),
	(2,200),
	(3,350)

select* from Developers_Views..Bankaccounts


select* from dbo.Bankaccounts


--Try Catch Roll Back
DROP Procedure dbo.transferfunds4
go
CREATE Procedure dbo.TransferFunds4 (@FromAccount as int, @Amount as decimal(18,2),@ToAccount as int)
as
BEgin Try

	Begin Transaction
		--Make sure toacount exists
		if (select accountid from dbo.Bankaccounts where AccountID = @ToAccount) is null
			Throw 51000, '@ToAccount does not exist.  Please select a different ID',1

		--make sure the from account exist
		if (select accountid from Developers_Views..Bankaccounts where AccountID = @FromAccount) is null
			Throw 51000, '@FromAccount does not exist. Please select a different ID',1
		
		--Make sure the @FromAccount has enough money to cover the amount
		if @Amount > (Select balance from Developers_Views..Bankaccounts where AccountID = @FromAccount)  
			Throw 51000, '@From Account does NOT have enough money to make the transfer',1
	

		--Update the ToAccount
		Update 
			Developers_Views..Bankaccounts
		set 
			Balance = (Select balance from Developers_Views..Bankaccounts where AccountID = @ToAccount) + @Amount
		Where 
			AccountID = @ToAccount

		--Update the FromAccount
		Update
			Developers_Views..Bankaccounts
		set 
			Balance = (Select balance from Developers_Views..Bankaccounts where AccountID = @FromAccount) - @Amount
		Where 
			AccountID = @FromAccount

	Begin
		Commit Transaction
		print cast(@amount as varchar(50)) + ' was transferred from account ' + cast(@FromAccount as varchar(50)) + ' to ' + cast(@toaccount as varchar(50))
	End	

End Try

Begin Catch
	Begin
		print 'Error: ' + error_message() + '. No funds were transfered'
		rollback transaction
	End
End Catch

execute dbo.TransferFunds4 1,5,2  

Go



select* from Developers_Views.dbo.Bankaccounts

--Script with try catch and transaction which sends infor to the catch
Declare @AcctID as int
set @AcctID = (Select max(accountid) from Developers_Views.dbo.Bankaccounts) - 1

if not exists (select accountid from Developers_Views.dbo.Bankaccounts where AccountID = AccountID)
	Begin
		Print'script by passed'
	End
Else
	Begin
		Begin Transaction
		Begin Try

			insert into Developers_Views..Bankaccounts
			values (@AcctID,250)

			if @@ROWCOUNT = 1

				Begin
					Commit Transaction
					Print 'Successful'
				End

			else
				Begin
					Rollback Transaction
					Print 'error'
				End

			End Try

		Begin Catch
			print 'you idiot - your script was sent to the catch - ID already exists'
		End Catch
End




--//*************************************************************************
--  Handle row count with multiple transactions
--//*************************************************************************

Begin Try
	Begin Transaction

	Declare @RowCount1 int
	Declare @RowCount2 int
	Declare @TotalRowCount int

			Update
				Developers_Views..Students
			Set
				STATE = 'PA'
			Where
				ID in (453,471)

			set @RowCount1 = @@ROWCOUNT

			Update
				Developers_Views..Students
			Set
				STATE = 'OH'
			Where
				ID = 447

			Set @RowCount2 = @@ROWCOUNT

	set @TotalRowCount = @RowCount1 + @RowCount2

	if @TotalRowCount <> 2
		Throw 51000,'Not 2 records idiot',1

	Commit Transaction
	PRint 'Records were Changed'

End Try
Begin Catch
	Begin
		Rollback Transaction
		Select
			ERROR_NUMBER() as 'Error Number',
			Error_MEssage() as 'Error Message',
			ERROR_LINE() as 'Error Line',
			@TotalRowCount as 'Updated Record Attempt'
	End
End Catch

select* from Developers_Views..Students
select* from Developers_Views..studentlog


--//************************************************************************************************
--SQL Day 18
--Create a new procedure for bankaccounts to insert cash (write to log table as well)
--Create a log table for events to account
--//************************************************************************************************

select * from Developers_Views..Bankaccounts


Drop Proc dbo.CreateBankAccount
go

Create Proc dbo.CreateBankAccount ( @Balance as decimal(8,2))
as

Begin Try

--Auto increment a new ID
Declare @NewID as int
set @NewID = (Select max(AccountID) from Developers_Views..Bankaccounts) + 1

Declare @NewBalance as decimal(8,2)
Set @NewBalance = @Balance

--check that accountid does NOT exist (Not needed if removing from parameter
	if exists (select AccountID from Developers_Views..Bankaccounts where AccountID = @NewID)
		Throw 51000,'Error: ID already exists - Please add a different accountID',1

--insert records
	insert into Developers_Views..Bankaccounts (AccountID,Balance)
	Values
		(@NewID,@Balance)

	Begin Transaction
		Begin
			Commit Transaction
			Print 'Success: AccountID ' + cast(@NewID as varchar(10)) + ' was added with $' + cast(@Newbalance as varchar(50))
		End

End Try
	
Begin catch
	Begin Transaction
		BEgin
			Rollback transaction
			select 
				ERROR_MESSAGE() as 'Error Message',
				ERROR_LINE() as 'Error Line'
		End
End Catch
--end

execute dbo.CreateBankAccount 10000

select* from Developers_Views..Bankaccounts 

--//************************************************************************************************
--SQL Day 19
--Create ANimal/Adoption Tables
--Except operator
--//************************************************************************************************

--Except
--filter records when two SELECT statements are being used to select records
--statement returns those records from the left SELECT query, that are not present in the results returned by the SELECT query on the right side of the EXCEPT statement

-- pull back all animals except where animals have been adopted
select top 10 * from Developers_Views..z_Animals
Select top 10* from Developers_Views..z_Adoptions

--Will return 30 records
--100 records total
select
	Name,
	Species
from
	Developers_Views..z_Animals

Except

--70 animal adopted	
Select
	Name,
	Species
From
	Developers_Views..z_Adoptions


--// Bring back breeds which have no adoptions
--pull back all breeds excep
select breed from Developers_Views..z_Animals

except

--where there was an adoption as we're joining the tables together
select AN.Breed
from Developers_Views..z_Animals AN
join Developers_Views..z_Adoptions AD
on
	AN.Name = AD.Name
	and AN.Species = AD.Species
	
--//Show adopters who adopted 2 animals on the same day

select
	a1.Adopter_Email,
	a1.Adoption_Date,
	a1.Name as NAme1,
	a1.Species as Species1,
	A2.Name as Name2,
	A2.Species as Species2
from 
	Developers_Views..z_Adoptions a1
Join
	Developers_Views..z_Adoptions a2
On
	a1.Adopter_Email = a2.Adopter_Email
	and a1.Adoption_Date = a2.Adoption_Date
	and a1.Name <> A2.Name
Order by
	A1.Adopter_Email

--//************************************************************************************************
--SQL Day 20
--Cross Apply and Outer apply
--Use bankaccounts table
--Create invoice table
--//************************************************************************************************

select * from Developers_Views..Bankaccounts

drop table developers_views.dbo.invoice

create table developers_views.dbo.invoice
(
	AccountID int not null,
	TransactionDate Datetime not null,
	InvoiceTotal decimal(20,2) not null
)

Insert into Developers_Views.dbo.invoice
values
(2, '4/16/2021', 20000),
(3, '4/17/2021',1500)



select 
	ba.*,
	sub.InvTot 
from 
	Developers_Views.dbo.Bankaccounts ba
Cross apply (
			select
				sum(invoicetotal) as InvTot,
				AccountID
			from Developers_Views.dbo.invoice i
			Where
				i.AccountID = ba.AccountID
			Group by
				AccountID
			) sub

select 
	ba.*,
	sub.InvTot 
from 
	Developers_Views.dbo.Bankaccounts ba
outer apply (
			select
				sum(invoicetotal) as InvTot,
				AccountID
			from Developers_Views.dbo.invoice i
			Where
				i.AccountID = ba.AccountID
			Group by
				AccountID
			) sub

select 
	ba.AccountID,
	ba.Balance,
	sum(i.InvoiceTotal) as totalinv
from 
	Developers_Views.dbo.Bankaccounts ba
Left join Developers_Views.dbo.invoice i
on ba.AccountID = i.AccountID

group by
	BA.AccountID,
	BA.Balance


--//************************************************************************************************
--SQL Day 21
--WHile loop / counter
--Insert records into a table dynamically
--//************************************************************************************************

Declare @AccountID as int
Set @AccountID = 21
Declare @Balance as int
set @Balance = 12000

while (@AccountID between 20.5 and 30.5)
Begin
	Insert into Developers_Views..Bankaccounts (AccountID, Balance)
	Values(@AccountID,@Balance)
	Set @AccountID = @AccountID+1
	Set @Balance = @Balance + 255
End



--Create Proc which will submit an invoice to in the invoice table and subtract from the bank account table
select * from Developers_Views..Bankaccounts
select* from Developers_Views.dbo.invoice;


execute InvoicetoBankAcct 1,-170
select* from invoice
select* from Bankaccounts

Alter Procedure dbo.InvoicetoBankAcct (@AccountID as int, @InvoiceTotal as int)
As
IF not exists (Select Accountid from Developers_Views..Bankaccounts where AccountID = @AccountID)
	Begin
		Print 'The accountID does not exist'
	End

Else
	Begin
		Begin Transaction
			Begin Try
				Declare @Rollback as bit

				IF (Select balance from Developers_Views..Bankaccounts where accountid = @AccountID) < @InvoiceTotal
					Throw 51000, 'AccountID does NOT have enough money to pay the invoice',1

				Insert into Developers_Views.dbo.invoice
				Values
					(@AccountID,GetDate(),@InvoiceTotal)

				IF @@ROWCOUNT = 1
				Set @Rollback = 0

				Update Developers_Views..Bankaccounts
				set Balance = (select balance from Bankaccounts where AccountID = @AccountID) - @InvoiceTotal
				Where AccountID = @AccountID

				IF @@ROWCOUNT = 1
				Set @Rollback = 0


				If @Rollback = 0
					Begin
						Print 'Success'
						Commit Transaction
					End
				Else
					Begin
						Print 'Failure'
						Rollback Transaction
					End
				End Try
			Begin Catch
				Begin
					print error_message()
					Rollback Transaction
				End
			End Catch
		End
