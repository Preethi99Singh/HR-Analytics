create database P424;
use p424;
select * from hr_1;
select * from hr_2;

# total_employees
CREATE VIEW `total_employees` AS
select count(*) total_employees from hr_1;

select * from total_employees;


# attrition_summary
CREATE VIEW `attrition_summary` AS
select attrition,count(*) as count
FROM hr_1 
group by attrition;

select * from attrition_summary;


##KPI - 1


select * from hr_1;

select Department,Count(attrition) 'Number of Attrition' from hr_1
where attrition = 'Yes'
group by Department;

CREATE VIEW `department_average` AS
select Department, 
round(count(attrition)/ (select count(EmployeeNumber)from hr_1)*100,2) 
as attrition_rate from hr_1
where attrition = 'Yes'
group by Department;

select * from department_average;


##KPI -2

# Gender_count
CREATE VIEW `count_gender` AS
select Gender, count(Gender) count_gender from hr_1
group by Gender;

select * from count_gender;

CREATE PROCEDURE `hourly_rate` (IN input_Gender VARCHAR(20), IN input_JobRole VARCHAR(30))
BEGIN
    SELECT 
        Gender,
        ROUND(AVG(HourlyRate), 2) AS Average_Hourly_Rate
    FROM 
        hr_1
    WHERE 
        Gender = input_Gender AND Job_Role = input_JobRole
    GROUP BY 
        Gender;
END;

call p424.hourly_rate('Male', 'Research Scientist');


##KPI 3

select h1.Department,
round(count(h1.attrition)/(select count(h1.EmployeeNumber) from hr_1 h1)*100,2) `Attrtion_rate`,
round(avg(h2.MonthlyIncome),2) average_income from hr_1 h1 join hr_2 h2
on h1.EmployeeNumber = h2.`Employee ID`
where attrition = 'Yes'
group by h1.Department;

CREATE VIEW attrition_employeeincome AS
select h1.Department,
round(count(h1.attrition)/(select count(h1.EmployeeNumber) from hr_1 h1)*100,2) `Attrtion rate`,
round(avg(h2.MonthlyIncome),2) average_income from hr_1 h1 join hr_2 h2
on h1.EmployeeNumber = h2.`Employee_ID`
where attrition = 'Yes'
group by h1.Department;


## KPI 4
 
select h1.Department,Round(avg(h2.totalworkingyears),0) from hr_1 h1
join hr_2 h2 on h1.EmployeeNumber = h2.`Employee ID`
group by h1.Department;

Create view `employee_age` as 
select h1.Department,Round(avg(h2.totalworkingyears),0) from hr_1 h1
join hr_2 h2 on h1.EmployeeNumber = h2.`Employee ID`
group by h1.Department;

select * from Employee_Age;


##KPI - 5

select * from hr_2;

SELECT h1.JobRole, h2.WorkLifeBalance_status, COUNT(h2.WorkLifeBalance_status) AS Employee_count
FROM hr_1 h1
JOIN hr_2 h2 ON h1.EmployeeNumber = h2.`Employee ID`
GROUP BY h1.JobRole, h2.WorkLifeBalance_status
ORDER BY h1.JobRole;

CREATE PROCEDURE Get_Count (in job_role varchar(30),in Work_balance varchar(30),out Ecount int)
BEGIN
select count(h2.WorkLifeBalance_status)  Employee_count into ecount
from hr_1 h1 join hr_2 h2
on h1.EmployeeNumber = h2.`Employee ID`
where h1.JobRole = Job_Role and h2.WorkLifeBalance_status = Work_Balance
group by Job_Role,Work_Balance;
END //


##KPI-6


select * from  hr_2;

select h2.`YearsSinceLastPromotion`,count(h1.attrition)  attrition_count
from hr_1 h1 join hr_2 h2 on h1.EmployeeNumber = h2.`Employee ID`
where h1.attrition = 'Yes'
group by `YearsSinceLastPromotion`
order by 'YearsSinceLastPromotion';