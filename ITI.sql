create database ITI
use ITI

create table Instructors(
	Id int primary key Identity(1,1),
	Name varchar(25),
	Address varchar(25),
	bonus money,
	salary money,
	Hour_Rate int,
	Dep_id int
)
create table Department(
	Id int primary key Identity(1,1),
	Name varchar(25),
	Hiring_date date,
	Ins_Id int references Instructors(Id) 
)

Alter table Instructors add foreign key (Dep_Id) References Department(Id)

create table Students (
	Id int primary key Identity(1,1),
	Fname varchar(25)  ,
	Lname varchar(25) ,
	Age varchar(10),
	Address varchar(30),
	Dep_id int references Department(Id)
)


create table Topics(
	Id int primary key Identity(1,1),
	Name varchar(25),
)

create table cources(
	Id int primary key Identity(1,1),
	Name varchar(25),
	Duration int,
	Description varchar(40),
	Top_id int references Topics(Id) 
)

create table Stud_Cources(
	Stud_id int references Students(Id),
	Cource_id int references cources(Id),
	Grade int,
	primary key(Stud_id,Cource_id)
)

create table Cource_Instructor(
	Inst_id int references Instructors(Id),
	Cource_id int references cources(Id),
	Evaluation dec(5,2),
	primary key(Inst_id,Cource_id)
)

