-- ex1: datalemur-duplicate-job-listings. (https://datalemur.com/questions/duplicate-job-listings)
WITH job_count_cte AS (
  SELECT title, 
    description, 
    company_id, 
    count(job_id) as job_count
  FROM job_listings
  group by  title, description, company_id 
)
SELECT count(DISTINCT company_id) 
FROM job_count_cte
WHERE job_count>=2
;
-- ex2: datalemur-highest-grossing. (https://datalemur.com/questions/sql-highest-grossing)
(SELECT category, product, sum(spend)
FROM product_spend 
where extract(year from transaction_date)=2022
and category = 'electronics'
group by product, category
order by sum(spend) desc
limit 2)
UNION
(SELECT category, product, sum(spend)
FROM product_spend 
where extract(year from transaction_date)=2022
and category = 'appliance'
group by product, category
order by sum(spend) desc
limit 2)

-- ex3: datalemur-frequent-callers. (https://datalemur.com/questions/frequent-callers)
WITH total_count AS
(SELECT count(case_id) as call_count
FROM callers
group by policy_holder_id)
SELECT count(*) FROM total_count
WHERE call_count>=3
;

-- ex4: datalemur-page-with-no-likes. (https://datalemur.com/questions/sql-page-with-no-likes)
--- Cách 1
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes 
ON page_likes.page_id=pages.page_id
WHERE liked_date IS NULL
ORDER BY pages.page_id ASC
;
--- Cách 2
SELECT page_id
FROM pages 
WHERE NOT page_id IN (SELECT page_id from page_likes ) 
;

-- ex5: datalemur-user-retention. (https://datalemur.com/questions/user-retention)
with cte as (
select a.user_id, 
a.event_date as last_month, 
b.event_date as current_month
from user_actions as a
join user_actions as b
on a.user_id=b.user_id
where (extract(month from a.event_date)=6 
      and extract(year from a.event_date)=2022)
      and 
      (extract(month from b.event_date)=7 
      and extract(year from a.event_date)=2022)
)
select extract(month from current_month) as month, 
count(distinct user_id) as monthly_active_users
from cte
group by extract(month from current_month)
;

-- ex6: leetcode-monthly-transactions. (https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50)
select date_format(trans_date, '%Y-%m') as month, country, count(*) as trans_count, 
sum(case when state='approved' then 1 else 0 end) as approved_count ,sum(amount) as trans_total_amount, sum(case when state='approved' then amount else 0 end) as approved_total_amount
from transactions
group by month, country

--ex7: leetcode-product-sales-analysis. (https://leetcode.com/problems/product-sales-analysis-iii/?envType=study-plan-v2&envId=top-sql-50)
select product_id, year as first_year , quantity, price
from sales
where (product_id,year) in (select product_id, min(year)
from sales
group by product_id);

--ex8: leetcode-customers-who-bought-all-products. (https://leetcode.com/problems/customers-who-bought-all-products/?envType=study-plan-v2&envId=top-sql-50)
select customer_id
from customer
group by customer_id
having count(distinct product_key)=(select count(distinct product_key) from product);

--ex9: leetcode-employees-whose-manager-left-the-company. (https://leetcode.com/problems/employees-whose-manager-left-the-company/?envType=study-plan-v2&envId=top-sql-50)
select employee_id
from employees 
where manager_id not in (select distinct employee_id from employees)
and salary < 30000;

--ex10: leetcode-primary-department-for-each-employee (https://datalemur.com/questions/duplicate-job-listings)
with dup_com as(select company_id, title, description,count(job_id)
from job_listings
group by company_id, title, description
having count(job_id)>=2)
select count(*)
from dup_com;

--ex11: leetcode-movie-rating (https://leetcode.com/problems/movie-rating/?envType=study-plan-v2&envId=top-sql-50)
select results from
(select u.name results
from users as u
right join movierating as m
on u.user_id=m.user_id
group by u.name
order by count(distinct m.rating) desc, u.name
limit 1) as a
union 
(select mov.title results
from movies as mov
right join movierating as m
on mov.movie_id=m.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by mov.title 
order by avg(m.rating) desc, results  
limit 1);

--ex12: leetcode-who-has-the-most-friends (https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50)
with cte as ((select requester_id id ,accepter_id num
from requestaccepted )
union all
(select accepter_id id, requester_id num
from requestaccepted ))
select id, count(num) num
from cte 
group by id 
order by count(num) desc
limit 1;
