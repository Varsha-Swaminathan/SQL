CREATE SCHEMA IF NOT EXISTS Employee;
USE Employee;
# import csv files in Employee database.

SELECT * FROM DEPARTMENT_DETAILS;
SELECT * FROM EMPLOYEE_DETAILS;

alter table employee_details modify HIRE_DATE date;

describe employee_details;
#Retrive employee_id , first_name , last_name and salary details of those employees whose salary is greater than the average salary of all the employees.
select employee_id,first_name,last_name,salary 
from employee_details 
where salary > (select avg(salary)
from employee_details);

# Display first_name , last_name and department_id of those employee where the location_id of their department is 1700
select first_name,last_name,department_id
from employee_details
where department_id in (select department_id from department_details where LOCATION_ID=1700);

#From the table employees_details, extract the employee_id, first_name, last_name, job_id and department_id who work in  any of the departments of Shipping, Executive and Finance.
select employee_id, first_name, last_name, job_id, department_id
from employee_details
where  department_id in (select department_id from department_details where DEPARTMENT_NAME in ('Shipping', 'Executive' , 'Finance'));

# Extract employee_id, first_name, last_name,salary, phone_number and email of the CLERKS who earn more than the salary of any IT_PROGRAMMER.
select employee_id, first_name, last_name,salary, phone_number, email
from employee_details
where job_id like '%clerk%' and salary>any(select salary from employee_details where job_id like '%IT_PROG%');


# Extract employee_id, first_name, last_name,salary, phone_number, email of the AC_ACCOUNTANTs who earn a salary more than all the AD_VPs.
select employee_id, first_name, last_name,salary, phone_number, email
from employee_details
where job_id like '%AC_ACCOUNTANT%' and salary>all(select salary from employee_details where job_id like '%AD_VP%');

#Write a Query to display the employee_id, first_name, last_name, department_id of the employees who have been recruited in the recent half timeline since the recruiting began. 
select employee_id, first_name, last_name, department_id from 
(select employee_id, first_name, last_name, department_id,ntile(2)over(order by HIRE_DATE) output from employee_details)t
where output = 2;
# Extract employee_id, first_name, last_name, phone_number, salary and job_id of the employees belonging to the 'Contracting' department 

select employee_id, first_name, last_name, phone_number, salary, job_id
from employee_details
where department_id in(select department_id  from department_details where DEPARTMENT_NAME like 'Contracting');


# Extract employee_id, first_name, last_name, phone_number, salary and job_id of the employees who does not belong to 'Contracting' department
select employee_id, first_name, last_name, phone_number, salary, job_id
from employee_details
where department_id not in(select department_id  from department_details where DEPARTMENT_NAME like 'Contracting');
# Display the employee_id, first_name, last_name, job_id and department_id of the employees who were recruited first in the department


select employee_id, first_name, last_name, phone_number, salary, job_id,department_id from (select *,row_number()over(partition by DEPARTMENT_ID order by HIRE_DATE)output from employee_details)t
where output=1;
# Display the employee_id, first_name, last_name, salary and job_id of the employees who earn maximum salary for every job.
select employee_id, first_name, last_name, phone_number, salary, job_id,department_id from (select *,row_number()over(partition by job_id order by salary desc)output from employee_details)t
where output=1;


CREATE SCHEMA IF NOT EXISTS Video_Games;
USE Video_Games;
SELECT * FROM Video_Games_Sales;
update  Video_Games_Sales set  Year_of_Release = Null where Year_of_Release='0';
update  Video_Games_Sales set  Critic_Score = '' where Critic_Score=null;
alter table Video_Games_Sales modify Year_of_Release int;
alter table Video_Games_Sales modify Critic_Score double;
describe Video_Games_Sales;
#Display the names of the Games, platform and total sales in North America for respective platforms.
select name,Platform,round(sum(NA_Sales)over(partition by Platform),2) from video_games_sales;

#Display the name of the game, platform , Genre and total sales in North America for corresponding Genre as Genre_Sales,total sales for the given platform as Platformm_Sales and also display the global sales as total sales .
# Also arrange the results in descending order according to the Total Sales.
select name,Platform,genre,round(sum(na_sales)over(partition by genre),2)Genre_sales,
round(sum(na_sales)over(partition by platform),2) as platformwise_sales,sum(Global_Sales)over(partition by name)total_sales 
from video_games_sales order by total_sales;

# Use nonaggregate window functions to produce the row number for each row 
# within its partition (Platform) ordered by release year.
select *,row_number()over(partition by platform)as Row_num
from video_games_sales
order by Year_of_Release;

#Use aggregate window functions to produce the average global sales of each row within its partition (Year of release). Also arrange the result in the descending order by year of release.
select *,round(avg(Global_Sales)over(partition by Year_of_Release),2)avg_sales_per_year
from video_games_sales;
#Display the name of the top 5 Games with highest Critic Score For Each Publisher. 
select name,Critic_Score,rank()over(order by critic_score desc)Ranks
from video_games_sales
order by ranks limit 5;


------------------------------------------------------------------------------------
# Write a query that displays the opening date two rows forward i.e. the 1st row should display the 3rd website launch date
select *,lead(launch_date,2)over() from web;
# Write a query that displays the statistics for website_id = 1 i.e. for each row, show the day, the income and the income on the first day.

select day,income,min(day)over() from website_stats where website_id=1;

-----------------------------------------------------------------
#For each game, show its name, genre and date of release. In the next three columns, show RANK(), DENSE_RANK() and ROW_NUMBER() sorted by the date of release.
select name,genre,Year_of_Release,rank()over(order by Year_of_Release),dense_rank()over(order by Year_of_Release),row_number()over(order by Year_of_Release)from video_games_sales;