-- Ex1: hackerrank-more-than-75-marks. (https://www.hackerrank.com/challenges/more-than-75-marks/problem?isFullScreen=true)
SELECT Name
FROM STUDENTS
WHERE Marks>75
ORDER BY RIGHT(Name,3), ID ASC
;

-- Ex2: leetcode-fix-names-in-a-table. (https://leetcode.com/problems/fix-names-in-a-table/?envType=study-plan-v2&envId=top-sql-50)
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)),LOWER(RIGHT(name,LENGTH(name)-1))) AS name
FROM Users
ORDER BY user_id
;

-- Ex3: datalemur-total-drugs-sales. (https://datalemur.com/questions/total-drugs-sales)
SELECT manufacturer,
CONCAT('$',ROUND(SUM(total_sales)/1000000),' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY ROUND(SUM(total_sales)/1000000) DESC, manufacturer DESC 
;
