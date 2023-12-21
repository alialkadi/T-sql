/*
###################################################
	----------Part 01---------------

	⮚	Restore MyCompany Database and then:
		1.	Try to create the following Queries:
###################################################
*/


use MyCompany
-- 1.	Display all the employees Data.
		
		Select * From Employee

--2.	Display the employee First name, last name, Salary and Department number.

		Select Fname, Lname, Salary,Dno from Employee

--3.	Display all the projects names, locations and the department which is responsible for it.

		Select p.Pname,p.Plocation,D.Dname
		From Project P inner Join Departments D
		on P.Dnum =D.Dnum  
		
--4.	If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .
--      Display each employee full name and his annual commission in an ANNUAL COMM column (alias).


		Select [full name ]=E.Fname+' '+E.Lname ,[ANNUAL COMM ] = (E.Salary*0.10)
		from Employee E

--5.	Display the employees Id, name who earns more than 1000 LE monthly.
		
		Select E.SSN,[full name ]=E.Fname+' '+E.Lname  
		from Employee E 
		where E.Salary>1000

--6.	Display the employees Id, name who earns more than 10000 LE annually.

		Select E.SSN,[full name ]=E.Fname+' '+E.Lname  
		from Employee E 
		where E.Salary>10000

--7.	Display the names and salaries of the female employees 

		Select [full name ]=E.Fname+' '+E.Lname ,E.Salary
		From Employee E
		Where E.Sex = 'F'

--8.	Display each department id, name which is managed by a manager with id equals 968574.

		Select D.Dnum,D.Dname
		From  Departments D
		Where D.MGRSSN =  '968574'

--9.	Display the ids, names and locations of  the projects which are controlled with department 10.

		Select P.Pnumber as ID, P.Pname as name, P.Plocation
		From Project P
		where P.Dnum ='10'


--**********************************************************************************************************************--

/*
###################################################
	----------Part 02---------------

	⮚	Restore ITI Database and then:
		1.	Try to create the following Queries:
###################################################
*/

use ITI
--1.	Get all instructors Names without repetition

		Select Distinct I.Ins_Name from Instructor I

--2.	Display instructor Name and Department Name 


		Select I.Ins_Name, D.Dept_Name
		From Instructor I full Outer Join Department D
		on I.Dept_Id = D.Dept_Id

--3.	Display student full name and the name of the course he is taking For only courses which have a grade	

		 Select S.St_Fname +' '+S.St_Fname as [Full Name] ,c.Crs_Name 
		 From Student S,Course C,Stud_Course SC
		 where S.St_Id = sc.St_Id and C.Crs_Id = SC.Crs_Id and SC.Grade is not null

		 --^^^^^^^^^^^^^^^^^^^^^^^
		 -- Another solution 

		 Select S.St_Fname +' '+S.St_Fname as [Full Name] ,c.Crs_Name 
		 From Student S inner join Stud_Course SC on S.St_Id = sc.St_Id
		 inner join Course C on C.Crs_Id = SC.Crs_Id
		 where SC.Grade is not null

--4.	Display results of the following two statements and explain what is the meaning of 
	
	-- @@AnyExpression

	print @@VERSION  -->>>> prints information about the current version  of the SQL Server instance.


	-- 
	print @@SERVERNAME -->>>>prints the name of the server where the SQL Server is installed.


--**********************************************************************************************************************--


/*
###################################################
	----------Part 03---------------

	⮚	Using MyCompany Database and try to  create the following Queries:
		
###################################################
*/

use MyCompany

--1.	Display the Department id, name and id and the name of its manager.
		
		Select D.Dname , D.Dnum as DId , E.Fname+ ' ' + E.Lname as [Full Name] ,E.SSN as EId
		from Departments D, Employee E
		where D.MGRSSN = E.SSN

--2.	Display the name of the departments and the name of the projects under its control.

		Select D.Dname ,P.Pname
		from Departments D, Project P
		where P.Dnum = D.Dnum

		

--3.	Display the full data about all the dependence associated with the name of the employee they depend on .

		Select D.*
		From Dependent D , Employee E
		where D.ESSN = E.SSN

	
--4.	Display the Id, name and location of the projects in Cairo or Alex city.

		Select P.Pnumber ,P.Pname, P.Plocation
		From Project P 
		where P.City in ('Cairo','Alex')

--5.	Display the Projects full data of the projects with a name starting with "a" letter.

		Select * 
		From Project P
		Where P.Pname like 'a%'

--6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly

		Select E.*
		From Employee E
		where E.Dno  =30 and E.Salary between 1000 and 2000

--7.	Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.
		
		Select E.*
		From Employee E, Project P, Works_for W
		Where E.Dno = 10 and W.ESSn = E.SSN and W.Hours >= 10 and P.Pname = 'AL Rabwah'  and P.Pnumber = W.Pno
		
		--^^^^^^^^^^^^^^^^^^^^^^^^^^-- 
		-- Another method for 7
		Select E.*
		From Employee E
		inner Join Works_for W
		on W.ESSn = E.SSN
		Inner Join   Project P
		on P.Pnumber = W.Pno
		Where E.Dno = 10 and W.Hours >= 10 and P.Pname = 'AL Rabwah' 


--8.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

		Select [full name ]=E.Fname+' '+E.Lname  , P.Pname
		From Employee E
		inner Join Works_for W
		on W.ESSn = E.SSN
		Inner Join   Project P
		on P.Pnumber = W.Pno
		order by P.Pname


--9.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
		
		Select P.Pnumber , D.Dname ,E.Lname 
		From  Project P, Departments D ,Employee E
		Where D.MGRSSN = E.SSN and P.Dnum = D.Dnum and P.City='Cairo'

--10.	Find the names of the employees who were directly supervised by Kamel Mohamed.    سؤال رخم

		 Select [full name ]=E.Fname+' '+E.Lname  , SE.Superssn , [Super's name ]=SE.Fname+' '+SE.Lname
		 From Employee E,Employee SE
		 where SE.Fname='Kamel' and SE.Lname = 'Mohamed' and SE.SSN = E.Superssn

		 --^^^^^^^^^^^^^^^^^^^^^^^^^^-- 
		-- Another method for 10

		 Select [full name ]=E.Fname+' '+E.Lname  , SE.Superssn , [Super's name ]=SE.Fname+' '+SE.Lname
		 From Employee SE inner Join Employee E
		 on  SE.Fname='Kamel' and SE.Lname = 'Mohamed' and SE.SSN = E.Superssn


--11.	Display All Data of the managers
	
	

		Select E.* ,D.*
		From Employee E
		inner Join Departments D
		on D.MGRSSN = E.SSN
		
--12.	Display All Employees data and the data of their dependents even if they have no dependents.
		
		Select E.* , DP.*
		From Employee E Full Outer Join Dependent DP
		on DP.ESSN = E.SSN


--**********************************************************************************************************************--