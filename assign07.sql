/*

###############################################################

Part 01 (Views)
Use ITI DB:

###############################################################

*/


--1.	 Create a view that displays the student's full name, course name if the student has a grade more than 50. 

		create or alter view StudetCources
		with encryption
		as
		Select CONCAT(s.St_Fname , ' ' , s.St_Lname) as Full_Name, C.Crs_Name
		From Student s, Course C , Stud_Course sc
		where s.St_Id = sc.St_Id and Grade >50 and c.Crs_Id = sc.Crs_Id

		select * from StudetCources

--2.	 Create an Encrypted view that displays manager names and the topics they teach.  منين لفين معرفش انا

		create view MAngersTopic 
		with encryption
		as
		select I.Ins_Name , T.Top_Name
		From Instructor I, Department D, Topic T , Course C, Ins_Course IC
		where I.Ins_Id = d.Dept_Manager and t.Top_Id =c.Top_Id and I.Ins_Id = IC.Ins_Id and c.Crs_Id = IC.Crs_Id and t.Top_Id = c.Top_Id

		select * from MAngersTopic

--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or 
--‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding

		create view 



--4.	 Create a view “V1” that displays student data for students who live in Alex or Cairo. 

		Create view StudentCity(Student_name,Student_City,Student_age)
		with encryption
		as
		Select CONCAT(s.St_Fname , ' ' , s.St_Lname) as Full_Name , S.St_Address,S.St_Age
		From Student S
		where S.St_Address in ('Cairo','Alex')


		Select * from StudentCity

		
--5.	Create a view that will display the project name and the number of employees working on it. (Use Company DB)

		use MyCompany
		create view Pname
		with encryption
		as
		SELECT P.Pname, COUNT(E.SSN) as counts
		FROM Project P
		JOIN Works_for W ON P.Pnumber = W.Pno
		JOIN dbo.Employee E ON E.SSN = W.ESSn
		GROUP BY P.Pname;

		Select * from Pname


/*

###############################################################

Part 01 (Views)
use CompanySD32_DB:

###############################################################

*/

use [SD32-Company]

--1.	Create a view named   “v_clerk” that will display employee Number ,project Number, the date of hiring of all the jobs of the type 'Clerk'.

		create view Vclerk
		with encryption
		as
		Select w.EmpNo,w.ProjectNo,w.Enter_Date
		From dbo.Works_on w
		where w.Job = 'Clerk'

		select * from Vclerk

--2.	 Create view named  “v_without_budget” that will display all the projects data without budget

		create view vWithoutbudget
		with encryption
		as
		Select p.*
		From hr.Project p
		where p.Budget is null

		select * from vWithoutbudget

--3.	Create view named  “v_count “ that will display the project name and the Number of jobs in it

		create view V_count 
		with encryption
		as
		Select p.ProjectName , COUNT(p.ProjectNo) as number
		FRom hr.Project p
		GROUP BY P.ProjectName

		select * from V_count


--4.	 Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)

		Create or alter view  v_project_p2
		with encryption
		as
		Select EmpNo
		From Vclerk 
		--where ProjectNo ='p2' ??
		where ProjectNo = 2

		Select * from v_project_p2


--5.	modify the view named  “v_without_budget”  to display all DATA in project p1 and p2.

		alter view v_without_budget 
		as   
		select *  
		from HR.Project p
		where ProjectNo in(1 ,2)

		Select * from v_without_budget


--6.	Delete the views  “v_ clerk” and “v_count”
		
		delete from dbo.v_clerk 
		delete from dbo.V_count

--7.	Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’

		create view EmployeeNameBydep
		as
		Select E.EmpFname ,e.EmpLname 
		From dbo.Emp1 e, dbo.Department d
		where d.DeptNo = 2

		Select * from EmployeeNameBydep

--8.	Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)

		Select EmpLname from EmployeeNameBydep where EmpLname LIKE '%J%'
		
--9.	Create view named “v_dept” that will display the department# and department name
		
		create view v_dept  
		as   
		select DeptNo, DeptName  
		from Department
		
--10.	using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’

		insert into v_dept values(4,'Development')


		

--11.	Create view name “v_2006_check” that will display employee Number,
--the project Number where he works and the date of joining the project which must be from the first of January and the last of December 2006.
--this view will be used to insert data so make sure that the coming new data must match the condition


		create or alter view v_2006_check
		as
		Select e.EmpNo ,w.ProjectNo, w.Enter_Date
		From dbo.Emp1 e, dbo.Works_on w
		where e.EmpNo = w.EmpNo and w.Enter_Date between '2006-01-01' and '2006-12-31'





/*

###############################################################

Part 02

###############################################################

*/

use iti

--1.	Create a stored procedure to show the number of students per department.[use ITI DB] 

		Create  Procedure SP_NumofStudsbydep 
		as
		Select d.Dept_Id, count(s.St_Id)
		From Student s , Department d
		where s.Dept_Id = d.Dept_Id
		Group by d.Dept_Id

		SP_NumofStudsbydep

--2
		use MyCompany
		create or alter Proc numofemp
		as
		
			declare @num int 
			Select   @num= count(e.SSN)
			from dbo.Employee e inner join dbo.Works_for w
			on e.SSN = w.ESSn
			where w.Pno =100
			group by w.Pno
			If @num >=3
				Select 'number of employess in project 100 is 3 or more'
			Else
				Select 'the following employess work for projectt 100' , e.Fname , e.Lname
				From Employee e inner join Works_for w
				on e.SSN = w.ESSn
				where w.Pno = 100
		

			numofemp


--3
		
		create proc editemp @old int ,@new int , @pnum int
		as
			update Works_for
			set ESSn = @new
			where ESSn = @old and Pno = @pnum

			alter table Works_for nocheck constraint FK_Works_for_Employee

			editemp 102672, 22, 100

			alter table Works_for nocheck constraint FK_Works_for_Employee


--4	   مش عارف اعمل الجزء التاني
		use [SD32-Company]

		create table Audit(
			projectNo int,
			username nvarchar(20),
			modifieddate date,
			budget_old int,
			budget_now int,

		)




/*

###############################################################

Part 03

###############################################################

*/

--1.	Create a stored procedure that calculates the sum of a given range of numbers

		create or alter proc sums @s int , @e int , @o int output
		as
		declare @temp int = @s, @tempsum int = 0
		while @temp <= @e
			begin
			set @tempsum = @tempsum + @temp
			set @temp = @temp + 1
			end
			set @o = @tempsum



declare @Result int
exec sums  1,  5,  @Result output
select @Result AS 'SumResult'


--2

create or alter proc radius @r float ,  @res float output
		as
		declare @pi float = 3.13

		set @res = @pi  * POWER(@r , 2)


declare @Result float
exec radius 2 ,  @Result output
select @Result AS 'areaResult'


--3
create or alter procedure ageCAtegory
    @age int,
    @category varchar(50) out
as
begin

    if @age < 18
        set @category = 'child';
    else if @age >= 18 and @age < 60
        set @category = 'adult';
    else
        set @category = 'senior';
end

declare @Result varchar(50)
exec ageCAtegory 2 ,  @Result output
select @Result AS 'cat'


/*

###############################################################

Part 04

###############################################################

*/


use RouteCompany
	
	--1  .create table 
	
	
			create table Department
			(
				DeptNo int primary key  ,
				DeptName nvarchar(50),
				Location nvarchar(50)
	
			)
	
			--SET IDENTITY_INSERT Department ON مشتغلتش معايا
	
			insert into Department values('Research', 'NY')
			insert into Department (DeptName,Location) values('Accounting', 'DS')
			insert into Department values('Marketing', 'KW')
	
	
	--2 		
			create table Employee
			(
				EmpNo int primary key,
				Emp_Fname nvarchar(20) not null,
				Emp_Lname nvarchar(20) not null,
				DeptNo int,
				salary money,
				constraint FK_DEPTNO foreign key (DeptNo) references Department(DeptNo),
				constraint uni_Salary unique (salary)
			)
	
			
			insert into Employee  Values
				(25348, 'Mathew', 'Smith', 3, 2500),
				(10102, 'Ann', 'Jones', 3, 3000),
				(18316, 'John', 'Barrymore', 1, 2400),
				(29346, 'James', 'James', 2, 2800),
				(9031, 'Lisa', 'Bertoni', 2, 4000),
				(2581, 'Elisa', 'Hansel', 2, 3600),
				(28559, 'Sybl', 'Moser', 2, 2900);
	
		
	-- Testing Referential Integrity
	
		--1-Add new employee with EmpNo =11111 In the works_on table [what will happen]
				insert into Works_on values(11111,2,'Analyst','2006-12-2') 
				-- will confilct with the forign key Employee 
		
		
		--2-Change the employee number 10102  to 11111  in the works on table [what will happen]
		
				update Works_on 
				Set EmpNo = 11111
				where EmpNo = 10102
				-- will confilct with the forign key Employee 
		
		--3-Modify the employee number 10102 in the employee table to 22222. [what will happen]
		
				update Employee
				set EmpNo = 22222
				where EmpNo = 10102
		
				-- will confilect with the works_on table realtionship rules
				DELETE FROM Employee
				WHERE EmpNo = 10102
		
				-- to delete we must reassign in the tables that the pk of the employee table used as fk to null or to another pk
		
	--Table Modification
	
		--1-Add  TelephoneNumber column to the employee table[programmatically]
				Alter table Employee 
				Add TelephoneNumber nvarchar(20)
		
		--2-drop this column[programmatically]
				Alter table Employee
				Drop Column TelephoneNumber
	

--2.	Create the following schema and transfer the following tables to it 

	--a.	Company Schema 
			create schema company

			Alter schema company
			transfer Department

			Alter schema company
			transfer Project
	--b.	Company Schema 
			create schema HR

			Alter schema HR
			transfer Employee

--3.	Increase the budget of the project where the manager number is 10102 by 10%.

		update company.Project
		set Budget = Budget * 1.1
		where projectNo = (
			Select projectNo
			From dbo.Works_on
			where job= 'Manager' and EmpNo = 10102
		
		)


--4.	Change the name of the department for which the employee named James works.The new department name is Sales.

		update company.Department
		set DeptName = 'Sales'
		where DeptNo = (
			Select DeptNo 
			from HR.Employee 
			where Emp_Fname = 'James' 
		)

--5.	Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.

		update dbo.Works_on
		set Enter_Date = '2007.12.12'
		where EmpNo = (select EmpNo from HR.Employee e inner join company.Department w  on w.DeptNo = e.DeptNo where w.DeptNo =1 and w.DeptName ='Sales')


--6.	Delete the information in the works_on table for all employees who work for the department located in KW.

		Delete from works_on
		where EmpNo in (select EmpNo from HR.Employee e inner join company.Department w  on w.DeptNo = e.DeptNo where w.Location = 'Kw' )