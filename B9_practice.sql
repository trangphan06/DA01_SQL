-- ex1: datalemur-laptop-mobile-viewership. (https://datalemur.com/questions/laptop-mobile-viewership)
SELECT 
SUM(CASE
  WHEN device_type IN ('tablet','phone') THEN 1
  ELSE 0
END) AS mobile_views,
SUM(CASE
  WHEN device_type='laptop' THEN 1
  ELSE 0
END) AS laptop_views
FROM viewership
;

-- ex2: datalemur-triangle-judgement. (https://leetcode.com/problems/triangle-judgement/description/?envType=study-plan-v2&envId=top-sql-50)
select x, y, z, 
case 
    when (x+y>z and y+z>x and x+z>y) then 'Yes'
    else 'No'
end as triangle
from Triangle
;

-- ex3: datalemur-uncategorized-calls-percentage. (https://datalemur.com/questions/uncategorized-calls-percentage) (không có data)
SELECT 
SUM(CASE
  WHEN (call_category	IS NULL) OR (call_category	='n/a') THEN 1
  ELSE 0
END)/count(policy_holder_id)*100 AS call_percentage
FROM callers
; 

-- ex4: datalemur-find-customer-referee. (https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan-v2&envId=top-sql-50)
select name
from Customer
where referee_id!=2 or referee_id is null
;

-- ex5: stratascratch the-number-of-survivors. (https://platform.stratascratch.com/coding/9881-make-a-report-showing-the-number-of-survivors-and-non-survivors-by-passenger-class?code_type=1)
select survived, 
sum(case 
    when pclass=1 then 1
    else 0
end) as first_class,
sum(case 
    when pclass=2 then 1
    else 0
end) as second_class,
sum(case 
    when pclass=3 then 1
    else 0
end) as third_class	
from titanic
group by survived
;



