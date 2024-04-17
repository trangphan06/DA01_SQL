-- Bước 1: Tính giá trị R-F-M
select * from customer;
select * from sales;
select * from segment_score;

with customer_rfm as
(
	select a.customer_id,
	current_date - max(b.order_date) as R,
	count(distinct b.order_id) as F,
	sum(b.sales) as M
	from customer as a
	join sales as b
	on a.customer_id=b.customer_id
	group by a.customer_id
),

-- B2: chia các giá trị theo khoảng từ 1 tới 5
rfm_score as
(
	select customer_id,
	ntile(5) over(order by R desc) as r_score,
	ntile(5) over(order by F asc) as f_score,
	ntile(5) over(order by M asc) as m_score
	from customer_rfm
),
-- B3: phân nhóm theo từng phân khúc
rfm_final as
(
	select customer_id, 
	cast(r_score as varchar) || cast(f_score as varchar) || cast(m_score as varchar) as rfm_score
	from rfm_score
)
SELECT c.customer_id,
d.segment
from rfm_final as c
join segment_score as d
on c.rfm_score = d.scores
order by segment
