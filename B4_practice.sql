--- Ex1: hackerrank-weather-observation-station-3. (https://www.hackerrank.com/challenges/weather-observation-station-3/problem?isFullScreen=true)
SELECT DISTINCT CITY FROM STATION
WHERE ID%2=0
;

--- Ex2: hackerrank-weather-observation-station-4. (https://www.hackerrank.com/challenges/weather-observation-station-4/problem?isFullScreen=true)
SELECT COUNT(CITY)-COUNT(DISTINCT CITY) FROM STATION;

--- Ex3: hackerrank-the-blunder. (https://www.hackerrank.com/challenges/the-blunder/problem?isFullScreen=true)
SELECT CEILING(AVG(SALARY) - AVG(REPLACE(SALARY,"0","")))
FROM EMPLOYEES
;

--- Ex4: datalemur-alibaba-compressed-mean. (https://datalemur.com/questions/alibaba-compressed-mean)
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS DECIMAL), 1) AS mean
FROM items_per_order;
-- Dùng CAST ... AS decimal để chuyển đổi về số thập phân. 

--- Ex5: datalemur-matching-skills. (https://datalemur.com/questions/matching-skills)
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill)=3
ORDER BY candidate_id ASC
;

--- Ex6: datalemur-verage-post-hiatus-1. (https://datalemur.com/questions/sql-average-post-hiatus-1)
SELECT user_id,
MAX(DATE(post_date))-MIN(DATE(post_date)) AS days_between
FROM posts
WHERE DATE(post_date) BETWEEN '01/01/2021' AND '12/31/2021'
GROUP BY user_id
HAVING COUNT(post_id)>=2
;

--- Ex7: datalemur-cards-issued-difference. (https://datalemur.com/questions/cards-issued-difference)
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount)-MIN(issued_amount) DESC
;

--- Ex8: datalemur-non-profitable-drugs. (https://datalemur.com/questions/non-profitable-drugs)
SELECT manufacturer, 
COUNT(drug) AS drug_count,
SUM(cogs-total_sales) AS total_loss
FROM pharmacy_sales
WHERE (cogs-total_sales)>0
GROUP BY manufacturer
ORDER BY SUM(cogs-total_sales) DESC
;

--- Ex9: leetcode-not-boring-movies. (https://leetcode.com/problems/not-boring-movies/description/?envType=study-plan-v2&envId=top-sql-50)
SELECT id,
movie,
description,
rating
FROM Cinema
WHERE id%2!=0 AND description!='boring'
ORDER BY rating DESC
;

--- Ex10: leetcode-number-of-unique-subject. (https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/description/?envType=study-plan-v2&envId=top-sql-50)
SELECT teacher_id,
COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id
;

--- Ex11: leetcode-find-followers-count. (https://leetcode.com/problems/find-followers-count/?envType=study-plan-v2&envId=top-sql-50)
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
;

--- Ex12:leetcode-classes-more-than-5-students. (https://mentors.ripid.vn/dashboard/DA01?lesson=651af4cf2b2d72d37618ff74)
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student)>=5
;
