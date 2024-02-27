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
-- Cách 2
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)), LOWER(SUBSTRING(name FROM 2))) AS name
FROM Users
ORDER BY user_id
;
-- Cách 3
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id
;

-- Ex3: datalemur-total-drugs-sales. (https://datalemur.com/questions/total-drugs-sales)
SELECT manufacturer,
CONCAT('$',ROUND(SUM(total_sales)/1000000,0),' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY ROUND(SUM(total_sales)/1000000) DESC, manufacturer DESC 
;

-- Ex4: avg-review-ratings.
SELECT 
EXTRACT(month FROM submit_date) AS month,
product_id,
ROUND(AVG(stars),2) AS avg_star_rating
FROM reviews
GROUP BY product_id, EXTRACT(month FROM submit_date)
ORDER BY month, product_id
;

-- Ex5: teams-power-users. (https://datalemur.com/questions/teams-power-users)
SELECT sender_id,
COUNT(message_id) AS total_message_count
FROM messages
WHERE sent_date BETWEEN '08/01/2022' AND '08/31/2022'
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2
;
-- Cách 2
SELECT sender_id,
COUNT(message_id) AS total_message_count
FROM messages
WHERE EXTRACT(month FROM sent_date)=8
AND EXTRACT(year FROM sent_date)=2022
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2
;

-- Ex6: invalid-tweets. (https://leetcode.com/problems/invalid-tweets/?envType=study-plan-v2&envId=top-sql-50)
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content)>15
;

-- Ex7: user-activity-for-the-past-30-days. (https://leetcode.com/problems/user-activity-for-the-past-30-days-i/?envType=study-plan-v2&envId=top-sql-50)
SELECT activity_date as day,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE (activity_date BETWEEN '2019-06-28' AND '2019-07-27')
GROUP BY activity_date
HAVING (COUNT(activity_type)>=1)
;

-- Ex8: number-of-hires-during-specific-time-period. (https://platform.stratascratch.com/coding/2151-number-of-hires-during-specific-time-period?code_type=1)
select EXTRACT(month from joining_date),
COUNT(DISTINCT id) AS number_of_employees
from employees
where EXTRACT(year from joining_date)=2022
and EXTRACT(month from joining_date) BETWEEN 1 AND 7
group by EXTRACT(month from joining_date)
;

-- Ex9: positions-of-letter-a. (ex9: positions-of-letter-a.)
select position('A' IN first_name)
from worker
where first_name='Amitah'
;

-- Ex10: macedonian-vintages. (https://platform.stratascratch.com/coding/10039-macedonian-vintages?code_type=1)
select title,
substring(title from position('2' in title) for 4) as year
from winemag_p2
where country='Macedonia'
;
-- Cách 2
select title,
substring(title from length(winery)+2 for 4) as year
from winemag_p2
where country='Macedonia'
;
