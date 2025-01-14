DROP DATABASE IF EXISTS `Parks_and_Recreation`;
CREATE DATABASE `Parks_and_Recreation`;
USE `Parks_and_Recreation`;


CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');

-- ---------------------------------------------------------------------------------------------


#UNION
#THIS GIVES THE DISTINCT VALUES FROM THE TWO QUERIES
SELECT first_name, last_name  FROM employee_demographics
UNION
SELECT first_name, last_name FROM employee_demographics;


#UNION ALL
#THIS GIVES THE EVERY VALUE FROM THE QUERIES
SELECT first_name, last_name FROM employee_demographics
UNION ALL
SELECT first_name, last_name FROM employee_demographics;

#Usecase
select first_name, last_name , 'Old Man' as Label
from employee_demographics
where age > 45 and gender = 'Male'
Union
select first_name, last_name, 'Old Lady' as Label
from employee_demographics
where age > 45 and gender = 'Female'
UNION
select first_name, last_name, 'Highly Paid' as Label	
from employee_salary
where salary > 70000

#----------------------------------------------------------------------------------
#STRING FUNCTIONS

#LENGTH()
select length('amazon'); #returns 6

select first_name, length(first_name) len 
from employee_demographics
order by 2 desc;

#UPPER() AND LOWER()
select first_name, upper(first_name) up
from employee_demographics;

select first_name, lower(first_name) low
from employee_demographics;

#TRIM :  trims the spaces on both sides

select trim('     hello ' )

select ltrim('     hello ' ) #left trim

select rtrim('     hello ' ) #right trim

select first_name, trim(first_name)  
from employee_demographics;

#LEFT / RIGHT VALUES
select first_name, left(first_name, 4)
from employee_demographics;

select first_name, right(first_name, 4)
from employee_demographics;

#SUBSTRING : can take any character from any where using indexes
select first_name, substring(first_name, 3,2) as two_characters_from_3rd_pos
from employee_demographics;

select first_name , substring(birth_date,6,2) as birth_month
from employee_demographics;

#REPLACE
select first_name, REPLACE(first_name, 'A', 'Z') as replaced_name
from employee_demographics
order by 1;

#LOCATE : returns the index of the searched values
select first_name, LOCATE('A', first_name)
from employee_demographics;

#CONCAT
select first_name, last_name, concat(first_name,' ',last_name) as full_name
from employee_demographics;
#----------------------------------------------------------------------------------
#CASE STATEMENTS

select first_name, last_name, age,
CASE 
	WHEN age <= 30 then 'Young'
    WHEN age Between 31 and 50  then 'Middle age'
    WHEN age > 50 then 'Old'
END	AS age_brackets
from employee_demographics;

-- ---------------------------------


select employee_id, concat(first_name,' ', last_name) as FullName,salary,
CASE 
	when salary < 50000 then salary * 1.05
    when salary > 50000 then salary * 1.07
END as salary_increase,
COALESCE(CASE
	when dept_id = 6 then salary * 1.1
END,'NO bONUS')  as bonus  #COALESCE REPLACES THE NULL VALUES WITH 0 OR ANY GIVEN VAL
from employee_salary;

#----------------------------------------------------------------------------------
#SUBQUERIES
#using WHERE
#selecting people who only work in parks and recreation dept
select * from employee_demographics
where employee_id IN (
	select employee_id from employee_salary
    where dept_id = 1
);
-- -------------------------------------------------------
#Comparing avg salary for every employee
select first_name, salary,
(select avg(salary) as avg_sal from employee_salary) AS AVG_SAL
from employee_salary
group by first_name, salary;

-- ------------------------------------------
#Averages of aggregate functions using subqueries
select avg(max_age) 
from (select gender, avg(age) avg_age,
 max(age) max_age , 
 min(age) min_age, 
 count(age) coun
from employee_demographics
group by gender) as new_table
;
#----------------------------------------------------------------------------------
#WINDOW FUNCTIONS

#OVER()

-- generally we use group by but it has its drawbacks
select gender, avg(salary) as avg_sal
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
group by 1;
-- The above code has a problem we don't get the individual averages like below

-- This gives the avg salary of each group but compares with each person 
-- THE ABOVE DOESN'T DO THAT
select dem.first_name, gender, avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

#ROLLING TOTAL USING OVER()
-- This gives the rolling total for each gender / we can also use it for departments as well
select dem.employee_id, dem.first_name, gender,
sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
from employee_demographics dem
join employee_salary sal on
dem.employee_id = sal.employee_id;

-- Rolling total per departments
select dem.employee_id, sal.dept_id, dem.first_name, gender,
sum(salary) over(partition by sal.dept_id order by sal.dept_id) as rolling_total
from employee_demographics dem
join employee_salary sal on
dem.employee_id = sal.employee_id;

#----------------------------------------------------------------------------------
#ROW NUMBER
-- This assigns a row number to the each row which are unique
select dem.employee_id, sal.dept_id, dem.first_name, gender,
ROW_NUMBER() over()
from employee_demographics dem
join employee_salary sal on
dem.employee_id = sal.employee_id;

-- Assigning row number to each groups here we took gender and ranking by salary
select dem.employee_id, dem.first_name, gender,sal.salary,
ROW_NUMBER() over(partition by gender order by sal.salary desc)
from employee_demographics dem
join employee_salary sal on
dem.employee_id = sal.employee_id;

#----------------------------------------------------------------------------------
#RANK AND DESNSE_RANK()
-- Rank gives the same values to the duplicate values
-- for ex if there are 50k sal 2 times it gives same rank then for the next value after that
-- if 50k's rank is 5 and repeats twice then the next value will have rank 7

#dense_rank : this gives the next rank unlike above here are the examples

select dem.employee_id, dem.first_name, gender,sal.salary,
ROW_NUMBER() over(partition by gender order by sal.salary desc) as row_num,
RANK() over(partition by gender order by sal.salary desc) as rank_num,
DENSE_RANK() over(partition by gender order by sal.salary desc) as dense_rank_num
from employee_demographics dem
join employee_salary sal on
dem.employee_id = sal.employee_id;
#----------------------------------------------------------------------------------
#CTE's : COMMON TABLE EXPRESSIONS
-- a better way of writing subqueires

with example_table as 
(
select dept_id, avg(salary) as a_s, max(salary) as m_s, count(salary) as c_s
from employee_salary
group by dept_id
)
select avg(a_s) from example_table;


-- -------------------------------
-- assigning the CTE column names 
with example_table(dept_id, avg_sl, max_sl,cn_sl) as 
(
select dept_id, avg(salary) , max(salary) , count(salary) 
from employee_salary
group by dept_id
)
select * from example_table;

-- --------------------------------
-- MULTIPLE CTE's

with ex1 as (
select employee_id, gender, age
from employee_demographics
where age > 40),
ex2 as (
select employee_id, salary, dept_id
from employee_salary
where salary > 50000)
select * from ex1 
join ex2 on
ex1.employee_id = ex2.employee_id;

#----------------------------------------------------------------------------------
#TEMPORARY TABLES
-- When you restart the workbench the table gets deleted as its a temporary one

drop table if exists `details`;
create temporary table details(
first_name varchar(50),
fav_movie varchar(100))

select * from details;

insert into details values('pk', 'interstellar');


-- ----------------------------
create temporary table salary_over_60k
select * from employee_salary
where salary > 60000;

select first_name, salary from salary_over_60k;
#----------------------------------------------------------------------------------
#STORED PROCEDURES : These are like functions in python
-- these are helpful to store the queries and use them over and over again
-- The correct way of creating a procedures is

use `parks_and_recreation`;
drop procedure if exists `salary_partitions`;

DELIMITER $$
use `parks_and_recreation`$$
create procedure `salary_partitions`()
BEGIN
select * from employee_salary
where salary >= 50000;
select * from employee_demographics
where age >= 30;
END $$

DELIMITER ;

CALL salary_partitions();

#PARAMETERS

DELIMITER $$
CREATE PROCEDURE salary(p_emp_id INT)
BEGIN
select employee_id, first_name, salary
from employee_salary
where employee_id = p_emp_id ;
END $$

DELIMITER ;

call salary(1);

#----------------------------------------------------------------------------------
#TRIGGERS
-- when a table is updated with new details 
-- and the same details needed to be updated in the other table
-- sal table has ron but demographics doesn't we need to update that

#TRIGGER

SELECT * FROM EMPLOYEE_SALARY;
SELECT * FROM employee_demographics;

DELIMITER $$
CREATE TRIGGER emp_insert
AFTER insert on employee_salary
FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    values (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

insert into employee_salary(employee_id,first_name, last_name, occupation, salary,dept_id)
values (13, 'John', 'cena','wrestler' , '1000000', 7); -- This will be automatically added to demographics

#----------------------------------------------------------------------------------
#EVENTS : a trigger happens when an event takes place and event is a scheduled approach
-- it is best for automation

show variables like 'event%'; -- to check that event scheduler is on or off

DELIMITER $$
create event delete_retires
on schedule every 30 second
DO
BEGIN
	DELETE
    from employee_demographics
    where age>= 60;
END $$

DELIMITER ;

SELECT * FROM employee_demographics; -- EMP_ID 5 IS DELETED

