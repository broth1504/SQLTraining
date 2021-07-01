

Use Developers_Views

--//***************************************************************
--//Create Department Table
--//*****************************************************************

Create Table dbo.[Department]
	(
	DepartmentID int not null Primary Key,
	Name Varchar(250) not null
	)

--//***************************************************************
--//Create Employee Table
--//*****************************************************************

Create Table dbo.Employee
	(
	EmployeeID int not null primary key,
	FirstName varchar(250) not null,
	LastName varchar(250) not null,
	DepartmentID int not null
	)
--//***************************************************************
--//Insert Values into Department Table
--//*****************************************************************
Use Developers_Views

Insert Department (DepartmentID,Name)
VALUES (1,'Engineering')

Insert Department (DepartmentID,Name)
VALUES (2,'Administration')

Insert Department (DepartmentID,Name)
VALUES (3,'Sales')

Insert Department (DepartmentID,Name)
VALUES (4,'Marketing')

Insert Department (DepartmentID,Name)
VALUES (5,'Finance')

--//***************************************************************
--//Insert Values into Employee Table
--//*****************************************************************

Insert dbo.Employee
	(EmployeeID,FirstName,LastName,DepartmentID)
VALUES
	(1,'Orlando','Gee',1)

Insert dbo.Employee
	(EmployeeID,FirstName,LastName,DepartmentID)
VALUES
	(2,'Keith','Harris',2)

Insert developers_views.dbo.Employee
	(EmployeeID,FirstName,LastName,DepartmentID)
VALUES
	(6,'Dane','Cool',6),
	(5,'Jordan','Musser',5)

--//************************************************************************
--//Select all date from both tables to view tables
--//*************************************************************************

Select* from developers_views.dbo.Employee
Select* from developers_views.dbo.Department

--//************************************************************************
--//inner join on table before cross apply
--//*************************************************************************

Select*
from dbo.Employee E with (nolock)
inner join dbo.Department D with (nolock)
	on E.DepartmentID = D.DepartmentID

--//****************************************************************************************
--//cross apply to return same results as above.  Why use cross apply?  Table View function
--//*****************************************************************************************
Select*
from dbo.Employee E with (nolock)
	CROSS APPLY 
	(
	Select* from dbo.Department D with (nolock)
	Where
		E.DepartmentID = D.DepartmentID
	)D

--//************************************************************************
--//Outer Apply (Replace Left Join)
--//*************************************************************************

Select*
from dbo.Department d with (nolock)
LEFT join dbo.Employee E with (nolock)
	on D.DepartmentID = E.DepartmentID

--//****************************************************************************************
--//Outer apply to return same results as above with Left Join.  Why use Outer apply?  Table View function
--//*****************************************************************************************
Select*
from dbo.Department D with (nolock)
	Outer APPLY 
	(
	Select* from dbo.Employee E with (nolock)
	Where
		E.DepartmentID = D.DepartmentID
	)E

--//****************************************************************************************
--//Create Table Value function
--//Using employee table, select all columns where departmentID is equal to the parameter being passed through
--//*****************************************************************************************
CREATE Function developers_views.dbo.fn_GetallEmployeesofADepartment(@DeptID as INT)
Returns Table
as
Return
	(
	Select*
	FROM Developers_Views..Employee E with (nolock)
	Where E.DepartmentID = @DeptID
	)
GO

--//****************************************************************************************
--//Use function with the table
--//*****************************************************************************************

Select*
from Developers_Views..Department D with (nolock)
CROSS APPLY Developers_Views..fn_GetallEmployeesofADepartment (D.departmentid)