--ex1: leetcode-mmediate-food-delivery
with cte1 as (select customer_id , 
min(order_date) as fo
from delivery
group by customer_id)
select round(100.0*(select count(*) as immediate
from cte1 left join delivery
on cte1.customer_id=delivery.customer_id
where fo=delivery.customer_pref_delivery_date)/count(distinct customer_id),2) as immediate_percentage 
from delivery;

--ex2: leetcode-game-play-analysis
select 
round((select count(*) 
from (select player_id , min(event_date) as first_log
from activity 
group by player_id) as cte join activity
on cte.player_id=activity.player_id
where datediff(activity.event_date,cte.first_log)=1)/count(distinct player_id),2) as fraction 
from activity;

--ex3: leetcode-exchange-seats
select id, 
coalesce (case when id%2 != 0 then lead(student) over (order by id) 
else lag(student) over (order by id)
end, student) student
from seat;
