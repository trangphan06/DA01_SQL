-- Ex1: hackerank-revising-the-select-query. (https://www.hackerrank.com/challenges/revising-the-select-query-2/problem?isFullScreen=true)
SELECT NAME FROM CITY
WHERE POPULATION>120000 
AND COUNTRYCODE='USA'
;

-- Ex2: hackerank-japanese-cities-attributes. (https://www.hackerrank.com/challenges/japanese-cities-attributes/problem?isFullScreen=true)
SELECT * FROM CITY
WHERE COUNTRYCODE='JPN'
;

-- Ex3: hackerank-weather-observation-station-1. (https://www.hackerrank.com/challenges/weather-observation-station-1/problem?isFullScreen=true)
SELECT CITY, STATE FROM STATION
;

-- Ex4: hackerank-weather-observation-station-6. (https://www.hackerrank.com/challenges/weather-observation-station-6/problem?isFullScreen=true)
SELECT DISTINCT CITY FROM STATION
WHERE (CITY LIKE 'A%') 
    OR (CITY LIKE 'E%') 
    OR (CITY LIKE 'I%')
    OR (CITY LIKE 'O%')
    OR (CITY LIKE 'U%')
;

-- Ex5: hackerank-weather-observation-station-7. (https://www.hackerrank.com/challenges/weather-observation-station-7/problem?isFullScreen=true)
SELECT DISTINCT CITY FROM STATION
WHERE (CITY LIKE '%a')
    OR (CITY LIKE '%e')
    OR (CITY LIKE '%i')
    OR (CITY LIKE '%o')
    OR (CITY LIKE '%u')
;

-- Ex6: hackerank-weather-observation-station-9. (https://www.hackerrank.com/challenges/weather-observation-station-7/problem?isFullScreen=true)
-- Cách 1:
SELECT DISTINCT CITY FROM STATION
WHERE NOT ((CITY LIKE 'A%') 
    OR (CITY LIKE 'E%') 
    OR (CITY LIKE 'I%')
    OR (CITY LIKE 'O%')
    OR (CITY LIKE 'U%'))
;
-- Cách 2:
SELECT DISTINCT CITY FROM STATION
WHERE NOT (CITY LIKE 'A%') 
    AND NOT (CITY LIKE 'E%') 
    AND NOT (CITY LIKE 'I%')
    AND NOT (CITY LIKE 'O%')
    AND NOT (CITY LIKE 'U%')
;

-- Ex7: hackerank-name-of-employees. (https://www.hackerrank.com/challenges/name-of-employees/problem?isFullScreen=true)
SELECT name FROM Employee
ORDER BY name
;

-- Ex8: hackerank-salary-of-employees. (https://www.hackerrank.com/challenges/salary-of-employees/problem?isFullScreen=true)
SELECT name FROM Employee
WHERE salary>2000 AND months<10
ORDER BY employee_id ASC
;

-- Ex9: leetcode-recyclable-and-low-fat-products. (https://leetcode.com/problems/recyclable-and-low-fat-products/?envType=study-plan-v2&envId=top-sql-50)
SELECT product_id FROM Products
WHERE low_fats='Y' AND recyclable='Y'
;

-- Ex10: leetcode-find-customer-referee. (https://leetcode.com/problems/find-customer-referee/?envType=study-plan-v2&envId=top-sql-50)
SELECT name FROM Customer
WHERE referee_id!=2 OR referee_id IS NULL
;

-- Ex11: leetcode-big-countries. (https://leetcode.com/problems/big-countries/description/?envType=study-plan-v2&envId=top-sql-50)
SELECT name, population, area FROM World
WHERE area>=3000000 OR population>=25000000
;

-- Ex12: leetcode-article-views. (https://leetcode.com/problems/article-views-i/?envType=study-plan-v2&envId=top-sql-50)
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id=viewer_id
ORDER BY id ASC
;

-- Ex13: datalemur-tesla-unfinished-part. (https://datalemur.com/questions/tesla-unfinished-parts)
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL
;

-- Ex14: datalemur-lyft-driver-wages. (https://platform.stratascratch.com/coding/10003-lyft-driver-wages?code_type=1)
SELECT * FROM lyft_drivers
WHERE yearly_salary<=30000 OR yearly_salary>=70000
;

-- Ex15: datalemur-find-the-advertising-channel. (https://platform.stratascratch.com/coding/10002-find-the-advertising-channel-where-uber-spent-more-than-100k-usd-in-2019?code_type=1)
SELECT * FROM uber_advertising
WHERE money_spent>100000 AND year='2019'
;
