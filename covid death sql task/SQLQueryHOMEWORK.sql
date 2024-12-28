select * from death_by_year
select * from year_month
select * from sex_year_age

 --1.	Select all data from the "Deaths by Year" table.
select * from death_by_year

--2.	Retrieve all records from the "Deaths by Year and Month" table where the year is 2021.
select * from year_month where year='2021'

--3.	Find the total number of excess deaths in the "Deaths by Year" table
select sum(excess_mean) as sum_of_excess_death from death_by_year

--4.	Display the distinct years available in the "Deaths by Year" table.
select distinct year from death_by_year

--5.	Find all records in the "Deaths by Year, Sex, and Age" table where the sex is "Female".
select * from sex_year_age where sex='female' 

--6.	Calculate the average excess deaths per year in the "Deaths by Year" table.
select avg(excess_mean) as avgof_excessdeath from death_by_year

--7.	Retrieve the total excess deaths by region in the "Deaths by Year" table.
select location, sum (excess_mean) as total_excess_mean from death_by_year group by location

--8.	Find the maximum and minimum excess deaths recorded in the "Deaths by Year and Month" table.
select max(excess_mean) as max_excessdeath from death_by_year
select min(excess_mean) as min_excessdeath from death_by_year

--9.	Count the number of records for each age group in the "Deaths by Year, Sex, and Age" table.
select age_group, count(age_group) as count_age from sex_year_age group by age_group

--10.	Display records from the "Deaths by Year and Month" table where excess deaths are higher than the expected deaths.
select * from year_month where cumul_excess_high>expected_mean

----11.	Create a temporary table to store the total excess deaths by region and year from the "Deaths by Year" table and then 
--select from it.
create table #temp_Covid_death (location varchar(50), total_excessdeaths int, year varchar (50))
insert into #temp_Covid_death
select location, sum(excess_mean), year from death_by_year group by location, year

--Using joins, find the regions and years where tge number of excess deaths in the "deaths by year" table matches the number of 
--excess deaths in the "deaths by year and month" table aggregated by year.
select death_by_year.excess_mean,death_by_year.location, 
death_by_year.year, year_month.location, year_month.year from death_by_year 
left join year_month on 
death_by_year.location =year_month.location
where death_by_year.excess_mean=year_month.excess_mean

select death_by_year.excess_mean,death_by_year.location, 
death_by_year.year from death_by_year 
left join year_month on 
death_by_year.location =year_month.location
where death_by_year.excess_mean=year_month.excess_mean

--13.	Identify the regions with the highest total excess deaths in 2021 using a temporary table.
CREATE TABLE #temp_Covid_tble(
location varchar(50), total_excess_deaths int, year varchar(50))
INSERT INTO #temp_Covid_tble
SELECT location, excess_mean, year FROM death_by_year WHERE year = '2021'
SELECT * FROM #temp_Covid_tble ORDER BY total_excess_deaths DESC

--14. Perform a join to compare the actual deaths to the expected deaths by region and
--month for the year 2021.
SELECT sex_year_age.excess_mean, sex_year_age.expected_mean FROM sex_year_age
LEFT JOIN year_month ON sex_year_age.location=year_month.location
WHERE sex_year_age.year = '2021'

----15. Using joins, determine the average excess deaths by age group for each region in
--2020 from the "Deaths by Year, Sex, and Age" table.
SELECT sex_year_age.age_group, sex_year_age.location, sex_year_age.year,
AVG(sex_year_age.excess_mean) AS avg_excess_mean
FROM sex_year_age WHERE sex_year_age.year= '2020'
GROUP BY sex_year_age.age_group,sex_year_age.location, sex_year_age.year

SELECT sex_year_age.age_group, sex_year_age.location, sex_year_age.year,
AVG(sex_year_age.excess_mean) AS avg_excess_mean
FROM sex_year_age
LEFT JOIN year_month ON sex_year_age.location=year_month.location
WHERE sex_year_age.year = '2020'
GROUP BY sex_year_age.age_group,sex_year_age.location, sex_year_age.year

----16. Create a temporary table for expected vs. actual deaths comparison and use it to
--filter regions with a significant difference in deaths.
CREATE TABLE #temp_exp_deaths (
location varchar(50), expected_deaths int, actual_death int )
INSERT INTO #temp_exp_deaths
SELECT location, expected_mean, excess_mean FROM sex_year_age ORDER BY location

--Call table

SELECT * FROM #temp_exp_deaths

--17. Find the regions where the difference between male and female excess deaths was
--greatest in 2021
SELECT location, excess_mean, year, sex FROM sex_year_age WHERE year = '2021'
ORDER BY excess_mean DESC




