/*
##############################################################

*************************Part 01
*************************Use ITI DB

##############################################################

*/

use ITI

--1.	Retrieve a number of students who have a value in their age. 
		Select Count(S.St_Age)
		From Student S

		-------------- تاكيد بس

		Select Count(S.St_Id)
		From Student S
		Where S.St_Age is not null


--2.	Display number of courses for each topic name 

		Select Count(C.Crs_Id) as [Courses Count ] , C.Top_Id
		From Course C
		Group By C.Top_Id

--3.	Select Student first name and the data of his supervisor 

		Select  S.St_Fname as [STudent name] , SV.* 
		From Student S , Student SV
		where SV.St_Id =S.St_super

--4.	Display student with the following Format (use isNull function)

		Select ISNULL(S.St_Id, '--NA--') as [Student ID] , CONCAT(ISNULL(S.St_Fname, '--NA--'),
		ISNULL(S.St_Lname, '--NA-- ')) as [Full Name], ISNULL(D.Dept_Name, '--NA--') as [Department Name]
		From Student S , Department D
		Where D.Dept_Id = S.Dept_Id


--5.	Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function” 

		Select I.Ins_Name, ISNULL(I.Salary,'0000')
		From Instructor I 


--6.	Select Supervisor first name and the count of students who supervises on them

		Select Sv.St_Fname ,Count(S.St_Id) as numOFStuds
		From Student S, Student SV
		where SV.St_Id = S.St_super
		Group by Sv.St_Fname


--7.	Display max and min salary for instructors

		Select MIN(I.Salary) as  minimum_salary, MAX(I.Salary) as  max_salary
		From Instructor I


--8.	Select Average Salary for instructors 

		Select AVG(I.Salary) as   average_salary
		From Instructor I

--9.	Display instructors who have salaries less than the average salary of all instructors.


		Select I.*
		From Instructor I
		WHERE Salary < (SELECT AVG(Salary) FROM Instructor)



--10.	Display the Department name that contains the instructor who receives the minimum salary

		Select D.Dept_Name
		From Instructor I , Department D
		where D.Dept_Id = I.Dept_Id and Salary < (SELECT AVG(Salary) FROM Instructor)
		Group by D.Dept_Name


------------------------------------------------****************************************************----------------------------------------------------------


/*
##############################################################

*************************Part 02
*************************Use MyCompany  DB

##############################################################

*/
use MyCompany
 
 -- == DQL

--1.	For each project, list the project name and the total hours per week (for all employees) spent on that project.
		
		sELECT P.Pname , SUM(W.Hours) as Working_hours
		From Works_for W, Project P
		where P.Pnumber = W.Pno
		Group by P.Pname

--2.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

		Select D.Dname, Max(E.Salary) as max_salary,MIN(E.Salary) as MIN_salary, AVG(E.Salary) as avg_salary
		From Departments D , Employee E
		where  E.Dno = D.Dnum
		Group by D.Dname 




--3.	Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.  مش فاهم


		Select E.Fname , P.Pname
		From Employee E inner join  Works_for W on E.SSN = W.ESSn inner join Project P on P.Pnumber = W.Pno
		order by  P.Dnum,E.Fname, E.Lname
		


--4.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 


		Update Employee Set Salary = Salary* 1.3 
		Where Employee.SSN in (
			Select W.ESSn
			From Works_for W , Project P 
			Where P.Pnumber = W.Pno and P.Pname ='Al Rabwah'
		)




--1.	In the department table insert a new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'.

		Insert INTo Departments  (Dnum, Dname, [MGRStart Date], MGRSSN) VAlues (100,'DEPT IT', '1-11-2006', (
			Select E.SSN
			From Employee E
			Where E.SSN = 112233
		))
		
			


/*
2.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100),
and they give you(your SSN =102672) her position (Dept. 20 manager) 
*/


--a.	First try to update her record in the department table

		Update Departments Set MGRSSN= 968574 WHERE Dnum = 100

--b.	Update your record to be department 20 manager. 

		
			-- ## there is no employee with ssn = 102672  >>>  Select Fname from Employee where SSN = 102672
			INsert Into Employee (Fname ,Lname,SSN,Bdate,Address,Sex,Salary)
			Values ('Ali','ALkady',102672,'1999-1-11','menufia','M',2500)

			Update Departments Set MGRSSN = 102672 Where Dnum =20
		
--c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)

		-- ## there is no employee with ssn = 102672  >>>  Select Fname from Employee where SSN = 102672    هستخدم واحد تاني

		Update Employee Set Superssn =102672 where SSN = 321654



--3.	Unfortunately the company ended the contract with  Mr.Kamel Mohamed (SSN=223344) so try 
--to delete him from your database in case you know that you will be temporarily in his position.
--Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handles these cases)
--

-- Check is in DEpendent

		SELECT *
		FROM Dependent D
		WHERE D.ESSN = 223344; 

-- Check is in DEpartment
		SELECT *
		FROM Departments D
		WHERE D.MGRSSN = 223344; 

--Check employess
		SELECT *
		FROM Employee E
		WHERE E.Superssn = 223344;

--Check projects
		SELECT *
		FROM Works_for W
		WHERE W.ESSn = 223344;

Update Departments Set MGRSSN = 102672 Where MGRSSN =223344
Update Employee Set Superssn = 102672 Where Superssn =223344
Update Works_for Set ESSn = 102672 Where ESSn =223344
Update Dependent Set ESSn = 102672 Where ESSn =223344

Delete From Employee WHERE SSN = 223344;



------------------------------------------------****************************************************----------------------------------------------------------


/*
##############################################################

*************************Part 03
*************************⮚	Using MyCompany Database and try to  create the following Queries:

##############################################################

*/

--1.	Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.

		Select E.Fname + ' ' + E.Lname as Full_name
		From Employee E, Works_for W , Project P
		Where E.SSN  = W.ESSn and p.Pnumber = W.Pno and P.Pname = 'AL Rabwah' and W.Hours >= 10 and E.Dno =10

--2.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name

		Select E.Fname , P.Pname
		From Employee E, Works_for W , Project P
		Where E.SSN = W.ESSn and P.Pnumber = W.Pno
		Order By P.Pname

--3.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.

		Select P.Pnumber ,D.Dname , E.Lname ,E.Address,E.Bdate
		From Project P inner join Departments D on  D.Dnum = p.Dnum inner join  Employee E on D.Dnum = E.Dno 
		Where P.City ='Cairo'

--4.	Display the data of the department which has the smallest employee ID over all employees' ID.
	
		Select D.*
		From Departments D
		where D.Dnum = (Select Dno From Employee where SSN = (Select MIN(SSN) From Employee)) 


--5.	List the last name of all managers who have no dependents

		Select E.Lname
		From Employee E
		Where E.SSN  not in(Select ESSN From Dependent)

--6.	For each department-- if its average salary is less than the average salary of all employees display its number, name and number of its employees.

		Select D.Dname , D.Dnum , Count(E.SSN) as NumOfEmployees 
		From Departments D inner join Employee E on D.Dnum = E.Dno
		GROUP BY D.Dnum, D.Dname
		Having AVG(E.Salary) < (
			Select AVG(Salary) From Employee
		)


--7.	Try to get the max 2 salaries using subquery  منقول

SELECT DISTINCT Salary 
FROM Employee E1 
WHERE 2 > (
    SELECT COUNT(DISTINCT Salary) 
    FROM Employee E2 
    WHERE E2.Salary > E1.Salary 
) 