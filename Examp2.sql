use Library

--1. Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name.{1 Point}		Select  [Full Name] = Concat(E.Fname ,' ',E.Lname) 		From dbo.Employee E		where LEN(E.Fname) > 3--2. Write a query to display the total number of Programming books		Select Count(B.Id) as [NO OF PROGRAMMING BOOKS]		From dbo.Category C inner join dbo.Book B		on C.Id = B.Cat_id		where C.Cat_name = 'Programming'--3. Write a query to display the number of books published by (HarperCollins)				Select Count(B.Id) as [NO_OF_BOOKS]		From dbo.Publisher P inner join dbo.Book B		on P.Id = B.Publisher_id		where P.Name = 'HarperCollins '--4. Write a query to display the User SSN and name, date of borrowing and due date of the User whose due date is before July 2022. 		Select U.SSN,U.User_Name, B.Due_date,B.Borrow_date		From dbo.Users U inner join dbo.Borrowing B		on U.SSN = B.User_ssn		where b.Due_date < '2022-07-01'--5. Write a query to display book title, author name and display in the following format,' [Book Title] is written by [Author Name]. 		Select  CONCAT(' [ ',B.Title,' ] ',' is written by ',' [ ',A.Name,' ] ') as Book_By_Author		From dbo.Book B inner join dbo.Book_Author BA on B.Id = BA.Book_id 		inner join Author A on A.Id =BA.Author_id--6. Write a query to display the name of users who have letter 'A' in their names.		Select User_Name		From Users		where User_Name like '%A%'--7. Write a query that display user SSN who makes the most borrowing		Select  top 1 User_SSN
		From Borrowing
		GROUP BY User_SSN
		ORDER BY COUNT(User_SSN) DESC--8. Write a query that displays the total amount of money that each user paid for borrowing books.		Select User_SSN , SUM(Amount) as [Total Amount]
		From Borrowing
		Group By User_SSN
		Order By SUM(Amount) --9. write a query that displays the category which has the book that has the minimum amount of money for borrowing				-- هنا بيجمع سعر الكتب المتكرره ويجيب الاقل		Select c.Cat_name , b.Title, bo.Amount		From dbo.Category c inner join dbo.Book b on c.Id = b.Cat_id		inner join dbo.Borrowing bo on b.Id = bo.Book_id		where bo.Amount = (		Select top 1 sum(Amount) From Borrowing bo		Group By bo.Book_id 		Order By SUM(Amount) ASC		)				--هنا بيجيب الاقل وخلاص		Select c.Cat_name , b.Title, bo.Amount		From dbo.Category c inner join dbo.Book b on c.Id = b.Cat_id		inner join dbo.Borrowing bo on b.Id = bo.Book_id		where bo.Amount = (		Select min(Amount) From Borrowing bo		)--10.write a query that displays the email of an employee if it's not found, display address if it's not found, display date of birthday		Select E.Id ,coalesce(E.Email, E.Address, convert(nvarchar(50), E.DOB) , 'NOT found' ) as Info 		From dbo.Employee E-- 11. Write a query to list the category and number of books in each category with the alias name 'Count Of Books'.		Select c.Cat_name , count(b.Id) as [Count Of Books]		From Category C , Book b		where C.Id = b.Cat_id		Group by c.Cat_name--12. Write a query that display books id which is not found in floor num = 1 and shelf-code = A1.		Select *		From Book B  inner join dbo.Shelf s		on B.Shelf_code = S.Code where s.Floor_num != 1 and B.Shelf_code != 'A1'--13.Write a query that displays the floor number , Number of Blocks and number of employees working on that floor.		Select F.Number , F.Num_blocks , count(e.Id) as [Employee Count]		From dbo.Floor F , Employee E		where F.Number = E.Floor_no		Group By F.Number , F.Num_blocks--14.Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’.		Select b.Title, E.User_Name 		From Borrowing bo inner join Book b on b.Id = bo.Book_id		inner join Users E on E.SSN = bo.User_ssn 		where bo.Borrow_date Between'2022-03-01' and '2022-10-01'-- 15.Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name.		Select E.Id, [Full Name] = Concat(E.Fname ,' ',E.Lname)  ,SV.Fname		From Employee E inner join Employee SV		on E.Super_id = SV.id		order by E.Fname--16.Select Employee name and his/her salary but if there is no salary display Employee bonus. 		Select E.Fname , ISNULL(E.Salary,E.Bouns) as [Salary or bonus]		From Employee E--17.Display max and min salary for Employees 		Select max(Salary) as maximum_Salary , Min(Salary) as Minimun_Salary		From Employee--18.Write a function that take Number and display if it is even or odd 		create function EvenOROdd(@num int)		returns nvarchar(10)		as		begin			declare @res nvarchar(10)			if(@num % 2 = 0)				set @res ='Even'			else				Set @res ='ODD'			return @res		End		Select dbo.EvenOROdd(5)--19.write a function that take category name and display Title of books in that category		Create Function GetBookInfo(@name nvarchar(50))		returns table		return(			Select B.Title			From Category c inner join Book B			on C.Id = B.Cat_id			where c.Cat_name = @name		)		Select * From GetBookInfo('programming')--20. write a function that takes the phone of the user and displays Book Title , user-name, amount of money and due-date.		create function InfoByPhone(@phone nvarchar(50))		returns Table		return(			Select b.Title, u.User_Name , bo.Amount , bo.Due_date			From dbo.User_phones up inner join Users u on  u.SSN = up.User_ssn			inner join Borrowing bo on u.SSN = bo.User_ssn 			inner join Book b on b.Id = bo.Book_id			where up.Phone_num = @phone		)				Select * From InfoByPhone('0120255444')--21.Write a function that take user name and check if it's duplicated		Create Function checkforEmp(@username  nvarchar(50))		returns nvarchar(100)		Begin			declare @count int , @msg nvarchar(100) 			Select @count = Count(U.User_Name)			From Users U			where u.User_Name = @username			IF @count > 1				Set @msg = '[' + @username + '] is Repeated ' + CAST(@count AS NVARCHAR(10)) + ' times'			Else IF @count = 1
				 Set @msg = '[' + @username + '] is not duplicated'			ELSE
				 Set @msg = '[' + @username + '] is Not Found'			Return @msg						End		Select dbo.checkforEmp('Amr Ahmed')		Select dbo.checkforEmp('Rawan Walid')		Select dbo.checkforEmp('ali alkady')--22.Create a scalar function that takes date and Format to return Date With That Format.			Create function FormatDate ( @inputDate DATE, @format NVARCHAR(20) )
		returns nvarchar(100)		Begin
		    declare @formattedDate nvarchar(50)
		    Set @formattedDate = FORMAT(@inputDate, @format)
		    return @formattedDate
		End

		SELECT dbo.FormatDate(GETDATE(), 'yyyy-MM-dd')
		SELECT dbo.FormatDate('2023-12-31', 'dd/MM/yyyy')

		--^^^^^^^^^^^^^^^^^^^^^^^^-- حل تاني
		Create or alter function FormatDate2 ( @inputDate DATE, @format int )
		returns nvarchar(100)		Begin
		    declare @formattedDate nvarchar(50)
		    Select @formattedDate =  Convert(nvarchar(50),@inputDate, @format)
		    return @formattedDate
		End

		SELECT dbo.FormatDate2(GETDATE(), 101)
		SELECT dbo.FormatDate2('2023-12-31', 105)



--23.Create a stored procedure to show the number of books per Category.

		
		Create Proc NumOfBooksInCategory
		as
		begin
			Select C.Cat_name , COUNT(B.Id)As NumberOfBooks
			From Category C inner join Book B
			on C.Id = B.Cat_id
			Group by C.Cat_name
		End

		NumOfBooksInCategory



/*
24.Create a stored procedure that will be used in case there is an old manager
who has left the floor and a new one becomes his replacement. The
procedure should take 3 parameters (old Emp.id, new Emp.id and the
floor number) and it will be used to update the floor table.
*/ 
		
		create Proc UpdateNewManger @old int, @new int, @Num int
		as
		update dbo.Floor 
		set MG_ID = @new
		where MG_ID = @old and  Number= @Num

		execute UpdateNewManger 1, 7, 2 
		execute UpdateNewManger 7, 1, 2 

		select * from Floor
  
   
 --25.Create a view AlexAndCairoEmp that displays Employee data for users who live in Alex or Cairo. 
		Create view AlexAndCairoEmp 
		as
			Select E.*
			From Employee E
			where E.Address in('Cairo','Alex')
		
		--^^^^^^^^^^^^^^^^^^^^^^^^^^^^

		Create view AlexAndCairoEmp2 
		as
			Select E.*
			From Employee E
			where E.Address like '%Cairo%' or E.Address like '%Alex%'


		Select * From AlexAndCairoEmp2
	    
	     
--26.create a view "V2" That displays number of books per shelf

		create View V2 
		as
		Select B.Shelf_code , Count(B.Id) as BooksCount
		From dbo.Book B		   
		Group by B.Shelf_code

		Select * From V2

-- 27.create a view "V3" That display the shelf code that have maximum number of books using the previous view "V2"

		Create View V3
		as
		Select  v.Shelf_code
		From V2 v
		where v.BooksCount = (Select Max(v.BooksCount) From V2 v)
		
		Select * From V3


--28.Create a table named ‘ReturnedBooks’ With the Following Structure :

		create table returnedbooks (
		    user_ssn int,
		    book_id int,
		    due_date date,
		    return_date date,
		    fees decimal(10, 2)
		);

		/*
		then create A trigger that instead of inserting the data of returned book
		checks if the return date is the due date or not if not so the user must pay
		a fee and it will be 20% of the amount that was paid before.
		*/

		create or alter trigger refunFees
		on returnedbooks
		instead of insert
		as
		begin
			declare @book_id int , @userssn int, @duedate date, @returndate date, @fees decimal(10, 2)
			select @book_id = book_id, @userssn = user_ssn, @duedate = due_date, @returndate = return_date
			from inserted
			
			If @returndate > @duedate 
				begin
					Select @fees = (B.Amount * 0.2) from Borrowing B where B.Book_id = @book_id and B.User_ssn = @userssn
					update returnedbooks
					set fees = @fees
					where user_ssn = @userssn  and Book_id = @book_id
				end
			else
				begin
				    insert into returnedbooks (user_ssn, book_id, due_date, return_date, fees)
				    select user_ssn, book_id, due_date, return_date, fees
				    from inserted
				end
		End


		insert into returnedbooks (user_ssn, book_id, due_date, return_date, fees)
		values (2, 3, '2023-12-10', '2023-12-10', 0)

		select * from returnedbooks

		insert into returnedbooks (user_ssn, book_id, due_date, return_date, fees)
		values (2, 3, '2023-11-25', '2023-12-05', 0.00)


/*
29.In the Floor table insert new Floor With Number of blocks 2 , employee
with SSN = 20 as a manager for this Floor,The start date for this manager
is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5)
moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
Mohamed(his SSN =12) His position .
*/

		Update dbo.Floor
		Set MG_ID = null
		where Number = 6

		Update dbo.Floor
		Set MG_ID = 12
		where MG_ID = 5

		Update dbo.Floor
		Set MG_ID = 5
		where Number = 6

		insert into dbo.Floor Values (7,2,20,GETDATE())


--30.Create view name (v_2006_check) 

		Create view v_2006_check
		as
			Select f.MG_ID as [Employee_Id]  , f.Number as [Floor_Number], f.Num_blocks [number_of_blocks] , f.Hiring_Date
			From Floor f 
			where f.Hiring_Date >= '2022-03-01' and f.Hiring_Date <= '2022-12-31'

			Select * from v_2006_check

		insert into v_2006_check ([Employee_Id], [Floor_Number], [number_of_blocks], Hiring_Date)
		values (2, 6, 2, '2023-08-07'), 
		(4, 7, 1, '2022-08-04')

		insert into v_2006_check ([Employee_Id], [Floor_Number], [number_of_blocks], Hiring_Date)
		values (4, 7, 1, '2022-08-04')

		-- to insert first the employee_id must exist in the "Employee" TABLE 
		-- Chect for repeated constraints
		-- For the inserted value Error Cannot insert duplicate key in object 'dbo.Floor'. The duplicate key value is (6). A floor with id already exists



--31.Create a trigger to prevent anyone from Modifying or Delete or Insert in the Employee table

			create or alter trigger preventModification
			on Employee
			instead of insert, update, delete
			as
			begin
				Select 'You are not allowed to modify the Employee table.'
			end
			
			insert into Employee( Fname) values ('alll')
			delete from Employee where id = 20


--32.Testing Referential Integrity
	
	--A. Add a new User Phone Number with User_SSN = 50 in User_Phones Table 
		Insert into User_phones(User_ssn, Phone_num) values(50,'01018062078')

		--A conflict will occur with FK 'user_ssn' because of not existing user with PK 'SSN' = 50
		
		--***********************

	--B. Modify the employee id 20 in the employee table to 21
		update Employee 
		Set Id = 21
		where Id = 20

		-- the trigger was excueted 
			Drop TRIGGER preventModification

		-- Will not update the Emp_id is used as Manager_Id in floor table

		--****************************

	--C. Delete the employee with id 1 

		Delete From Employee where Id = 1

		--Conflict with the Borrowing table FK "FK_Borrowing_Employee" conflicted with table "dbo.Borrowing", column 'Emp_id'
		-- Emp_Id '1' recorded the user with ssn '1'

		--****************************

	--D. Delete the employee with id 12 

		Delete From Employee where Id = 12
		-- Same Conflict with the Borrowing table FK "FK_Borrowing_Employee" conflicted with table "dbo.Borrowing", column 'Emp_id'
		-- but Emp_Id '12' recorded the user with ssn '16'

		--****************************
	--E. Create an index on column (Salary) that allows you to cluster the data in table Employee. 
		 Create Clustered Index indexsalary
		 on Employee(salary)

		 --Cannot create more than one clustered index on table 'Employee'. 
		 -- there is PK 'Id' that is clustered index by default 


/*

33.Try to Create Login With Your Name And give yourself access Only to
Employee and Floor tables then allow this login to select and insert data
into tables and deny Delete and update (Don't Forget To take screenshot
to every step)

*/
Create login Ali with password = 'Ali'
use Library
create user Aliuser For login Ali
Grant Select, Insert on Employee To Aliuser
Grant Select, Insert on Floor to Aliuser

Deny Delete, Update on Employee To Aliuser
Deny Delete, Update on Floor To Aliuser


create schema Aly

Alter Schema Aly
transfer Floor

Alter Schema Aly
transfer Employee

Alter Schema dbo
transfer aly.Floor

Alter Schema dbo
transfer aly.Employee