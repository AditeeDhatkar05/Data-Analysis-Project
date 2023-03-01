create database excelr_project;
use excelr_project;
select * from hr_1;
select * from hr_2;

ALTER TABLE hr_2
RENAME COLUMN `Employee ID` TO empid;
###################################################################################################################################

#1st KPI - Average Attrition rate for all Departments
with summary as (
select hr2.empid , hr1.attrition,hr1.department from hr_1 as hr1 
join hr_2 as hr2 on  hr1.employeenumber = hr2.empid)
select department,count(case when attrition = 'yes' then empid end) as attrition_count,count(empid) as total_employees,round(
count(case when attrition = 'yes' then empid end)/count(empid)*100,2) as attrition_rate from summary
group by department;
####################################################################################################################################	

#2nd KPI - Average Hourly rate of Male Research Scientist
select count(Gender)'Male', JobRole, avg(HourlyRate) 'Average Hourly Rate'
from hr_1
where (Gender='Male' and Jobrole='Research Scientist');
####################################################################################################################################

select min(MonthlyIncome) from hr_2;
select max(MonthlyIncome) from hr_2;
select * from hr_1;
select * from hr_2;
###############################################################################################################################

#3rd KPI - Attrition rate Vs Monthly income stats
with summary as (
select hr2.empid,hr2.MonthlyIncome,hr1.attrition,
(case when MonthlyIncome >= 1000 and MonthlyIncome < 10000 then '1000-10000'
when MonthlyIncome >= 10000 and MonthlyIncome < 20000 then '10000-20000'
when MonthlyIncome >= 20000 and MonthlyIncome < 30000 then '20000-30000'
when MonthlyIncome >= 30000 and MonthlyIncome < 40000 then '30000-40000'
when MonthlyIncome >= 40000  then ' > 40000' end ) as monthly_income_bins
from hr_2 as hr2
join hr_1 as hr1 on  hr1.employeenumber = hr2.empid)
select count(empid) as total_employee_count,monthly_income_bins,count(case when attrition = 'Yes' then empid end) as attrition, 
ROUND((count(case when attrition = 'Yes' then empid end)/count(empid)*100),2) as attrition_rate
from summary
group by monthly_income_bins;
####################################################################################################################################

#4th KPI - Average working years for each Department
select Department, avg(TotalWorkingYears) 'Average Working Years'
from hr_project
group by Department; 
#####################################################################################################################################

#5TH KPI - Job Role Vs Work life balance
with summary as (
select hr2.WorkLifeBalance,hr2.empid,hr1.JobRole
from hr_2 as hr2 join  
hr_1 as hr1 on hr1.employeenumber = hr2.empid)
select jobrole ,round(avg(WorkLifeBalance),2) as avg_worklifebalance from summary
group by jobrole 
order by avg_worklifebalance desc;
#########################################################################################################################

#6th KPI - Attrition rate Vs Year since last promotion relation
with summary as (
select YearsSinceLastPromotion,empid,Attrition from hr_2 as hr2
join hr_1 as hr1 on  hr1.employeenumber = hr2.empid)
select YearsSinceLastPromotion, count(case when Attrition = 'Yes' then empid end) as No_of_emp_left,
round (count(case when Attrition = 'Yes' then empid end)/count(empid)*100,2) as attrition_rate from summary
group by YearsSinceLastPromotion
order by YearsSinceLastPromotion desc ,attrition_rate desc;