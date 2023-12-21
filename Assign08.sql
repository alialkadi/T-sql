/*
################################################

	--part 01
	--Use ITI

################################################
*/

--•	Create a trigger to prevent anyone from inserting a new record in the Department table 
--( Display a message for user to tell him that he can’t insert a new record in that table )

		create trigger PreventInsert
		on Department
		instead of insert 
		as
			Select 'You can’t insert a new record in that table'

		insert into Department(Dept_id,Dept_name) values (80,'ec')


--•	Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note) 

		Create table StudentAudit
		(
			Server_user_Name nvarchar(50),
			Date date,
			Note nvarchar(100)
		)

		create or alter trigger InsertAct
		on Student
		after insert
		as
		    declare @serverusername nvarchar(100)
		    select @serverusername = SYSTEM_USER
		    declare @note nvarchar(100)    
		    insert into StudentAudit (Server_user_Name, Date, Note)
		    select @serverusername, GETDATE(), '[' + @serverusername + '] Inserted new row with Key = ' + CONVERT(nvarchar(10), St_Id) + ' in table [Student]'
		    from inserted
		
		

		insert into Student (St_Id,St_Fname) values (34,'ali')
		Select * from StudentAudit


--Create a trigger on student table instead of delete to add Row in StudentAudit table 


		create or alter trigger deleteAct
		on Student
		instead of delete
		as
		    declare @serverusername nvarchar(100)
		    select @serverusername = SYSTEM_USER
		    declare @note nvarchar(100)    
		    insert into StudentAudit (Server_user_Name, Date, Note)
		    select @serverusername, GETDATE(), '[' + @serverusername + '] Try to delete Row with id = ' + CONVERT(nvarchar(10), St_Id) + ' in table [Student]'
		    from deleted



		delete from Student
		where st_id =33

		Select * from StudentAudit



/*
################################################

	--part 02
	--Use MyCompany 

################################################
*/


--
		
		create or alter Trigger prevIns
		On Employee
		Instead of insert
		as
		   if(Format(GETDATE(),'MMMM') = 'March')
				Select 'Insertion is not allowed in March'

			Else 
				insert into Employee(Fname, Lname, SSN ,Address)
				select Fname, Lname ,SSN ,Address
				From inserted

		insert into Employee(Fname, Lname, SSN ,Address) values('lolo','basha', 99,'cairo')


------------
--Use SD32-Company:

use [SD32-Company]

--

		create table budgetaudit (
		    projectno int,
		    username nvarchar(50),
		    modifieddate date,
		    budget_old money,
		    budget_new money
		)


		create  trigger budgetaudit        --- مع مساعدااااات
		on HR.Project
		after update
		as
		if update(budget)
		    declare @projectno nvarchar(20)
		    declare @username nvarchar(50)
		    declare @modifieddate date
		    declare @budgetold money
		    declare @budgetnew money
		
		    select @projectno = i.projectno,
		           @username = SYSTEM_USER,
		           @modifieddate = GETDATE(),
		           @budgetold = d.budget,
		           @budgetnew = i.budget
		    from inserted i
		    inner join deleted d on i.projectno = d.projectno
		    where i.budget <> d.budget;
		
		    insert into budgetaudit (projectno, username, modifieddate, budget_old, budget_new)
		    values (@projectno, @username, @modifieddate, @budgetold, @budgetnew)
		
		 
		 update HR.Project
		 set Budget = 1000
		 where ProjectNo = 1

		 Select * from budgetaudit


		----------------------------------

/*
################################################

	--part 03
	--Use ITI 

################################################
*/

use iti
Create Clustered Index cin
  on Department([Manager_hiredate]) 


  -- there is an existing cluster on Department table PK 'Dept_id'


--
Create Unique Clustered Index Uind
  ON Student(St_age)

  --if clustered then it will now be allowed because of the PK St_id

  Create Unique Index Uind2
  ON Student(St_age) 

  --terminated because a duplicate key was found for the object name 'dbo.Student' and the index name 'Uind2'. The duplicate key value is (<NULL>).
  -- same value was inserted and many was null