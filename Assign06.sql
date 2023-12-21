/*
###########################################################

--Part 01
-- use ITI DB

###########################################################
*/

--1.	Select max two salaries in instructor table. 

		Select top(2) Salary
		From Instructor
		order by Salary desc


--2.	Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”

		Select * 
		From
		(Select Dept_Id, Salary,
		ROW_NUMBER() OVER(partition by Dept_Id Order by Salary desc) as Ranked_INS
		From Instructor
		where Salary is not null) as NewTable
		where Ranked_INS <= 2


--3.	 Write a query to select a random  student from each department.  “using one of Ranking Functions”

		Select * , DENSE_RANK() over (order by dept_ID  ) as rankin
		From Student  
		where ranking = 1



/*
###########################################################

--Part 02
-- Part 02
Restore adventureworks2012 Database Then :

###########################################################
*/





use AdventureWorks2012
--1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’

		Select Sh.SalesOrderID, ShipDate
		From AdventureWorks2012.Sales.SalesOrderHeader SH
		Where sh.ShipDate BETWEEN '2002-07-28' AND '2014-07-29'

--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)

		Select pp.ProductID, pp.Name
		From Production.Product PP
		where pp.StandardCost < 110

--3.	Display ProductID, Name if its weight is unknown


		Select pp.ProductID, pp.Name, pp.Weight
		From Production.Product PP
		where pp.Weight is null

--4.	 Display all Products with a Silver, Black, or Red Color

		SELECT *
		FROM Production.Product PP
		WHERE pp.Color IN ('Silver', 'Black', 'Red')

--5.	 Display any Product with a Name starting with the letter B

		SELECT *
		FROM Production.Product PP
		Where PP.Name like 'B%'


--6.	Run the following Query Then write a query that displays any Product description with underscore value in its description.


		UPDATE Production.ProductDescription
		SET Description = 'Chromoly steel_High of defects'
		WHERE ProductDescriptionID = 3


		SELECT *
		FROM Production.ProductDescription PP
		Where PP.Description like '%_%'


--7.	 Display the Employees HireDate (note no repeated values are allowed)

		Select Distinct HE.HireDate
		From AdventureWorks2012.HumanResources.Employee HE


/*
8.	Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format
"The [product name] is only! [List price]"
(the list will be sorted according to its ListPrice value)
*/

		SELECT   CONCAT('Product: ',pp.Name , 'is only', pp.ListPrice )  as PRODUCT_INFO
		FROM Production.Product PP
		where pp.ListPrice BETWEEN 100 AND 120
		order by ListPrice

-----------------------------------------------------------------------------------------------------

/*
###########################################################

--Part 03 (Functions)
	Use ITI DB :

###########################################################
*/

--1.	Create a scalar function that takes a date and returns the Month name of that date.

	CREATE FUNCTION dbo.GetMonthName (@inputDate DATE)
	RETURNS NVARCHAR(50)
	AS
	BEGIN
	    DECLARE @monthName NVARCHAR(50)
	    SELECT @monthName = DATENAME(MONTH, @inputDate)	
	    RETURN @monthName
	END

	select dbo.GetMonthName('1-11-2023')

-- 2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

	CREATE FUNCTION dbo.GetValuesBetween (@start INT, @end INT)
	RETURNS @Result TABLE (Value INT)
	AS
	BEGIN
	    DECLARE @CurrentValue INT
	    SET @CurrentValue = @start
	    WHILE @CurrentValue <= @end
	    BEGIN
	        INSERT INTO @Result (Value) VALUES (@CurrentValue)
	        SET @CurrentValue = @CurrentValue + 1
	    END
	    RETURN
	END


	Select * from GetValuesBetween(1,6)



--3.	 Create a table-valued function that takes Student No and returns Department Name with Student full name.	

		create Function dbo.GetDepartmentByStudentID (@StudentId int)
		returns table
		As 
		return 
		(
			Select D.Dept_Name
			From ITI.DBO.Student S , ITI.DBO.Department D
			Where D.Dept_Id = S.Dept_Id and S.St_Id = @StudentId
		)
		
		Select * From dbo.GetDepartmentByStudentID(2)


--4.	Create a scalar function that takes Student ID and returns a message to user 

		Create or alter Function PrintStudentInfo(@studentID int)
		returns nvarchar(25)
		as
		BEGIN 
			Declare @fname nvarchar(25)
			Declare @lname nvarchar(25)
			Declare @msg nvarchar(50)
			Select @fname = S.St_Fname,@lname = S.St_Lname
			From Student S
			Where S.St_Id = @studentID

			if(@fname is null and @lname is null)
				Set @msg = '!First name & !last name are null'
			else if (@fname is null)
				Set @msg = 'First name are null' 
			else if (@lname is null)
				Set @msg = 'LAst name are null' 
			else 
				Set @msg = 'First name & last name are not null'
			RETURN @msg
		END

		Select dbo.PrintStudentInfo(1111)


--5.	Create a function that takes an integer which represents the format of the Manager hiring date and displays department name, Manager Name and hiring date with this format.   

		Create Function DisplayDateINDiffFormats(@form int)
		returns Table
		As
		return 
		(
			Select D.Dept_Name ,
			Case 
				when @form = 1 then CONVERT(nvarchar(30),D.Manager_hiredate,100)
				when @form = 2 then CONVERT(nvarchar(30),D.Manager_hiredate,101)
				when @form = 3 then CONVERT(nvarchar(30),D.Manager_hiredate,102)
				when @form = 4 then CONVERT(nvarchar(30),D.Manager_hiredate,110)
				when @form = 5 then CONVERT(nvarchar(30),D.Manager_hiredate,111)
				else CONVERT(nvarchar(30),D.Manager_hiredate,104)
			End as DATEFORMAT
			From ITI.dbo.Department D
		)

		Select * from dbo.DisplayDateINDiffFormats(4)



--6.	Create multi-statement table-valued function that takes a string
--a.	If string='first name' returns student first name
--b.	If string='last name' returns student last name 
--c.	If string='full name' returns Full Name from student table  (Note: Use “ISNULL” function)
--

		Create or alter Function GetStudentsNameByInput(@format nvarchar(25))
		returns @studentINf Table 
		(
		 stdId int,
		 StName nvarchar(50)
		)
		as 
		begin
		     if @format ='first name' 
			   Insert into @studentINf
			   Select St_Id,ISNULL(St_Fname,'FNAME NOT EXISTING')
			   From Student
		   else if @format = 'last name' 
		       Insert into @studentINf
			   Select St_Id,ISNULL(St_Lname,'LNAME NOT EXISTING')
			   From Student
		   else if @format ='Full Name'
		       Insert into @studentINf
			   Select St_Id,CONCAT(ISNULL(St_Fname,'FNAME NOT EXISTING'),' ',ISNULL(St_Lname,'LNAME NOT EXISTING')) as FullName
			   From Student
		
			 return
		end
		
		Select * from dbo.GetStudentsNameByInput('Full Name')


--7.	Create function that takes project number and display all employees in this project (Use MyCompany DB)
		
		use MyCompany
		

		create Function GETProjectEmployees(@Pnum int)
		returns table
		as
		return
		(
			Select E.*
			From Project p inner join dbo.Works_for W on p.Pnumber = w.Pno inner join Employee e on e.SSN = w.ESSn
			where W.Pno = @pnum
		)

		Select * from dbo.GETProjectEmployees(500)