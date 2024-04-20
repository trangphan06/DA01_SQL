--Doanh thu theo từng ProductLine, Year  và DealSize?
select productline, year_id, dealsize, sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by productline, year_id, dealsize;

--Đâu là tháng có bán tốt nhất mỗi năm?
select  year_id, month_id, sum(sales),
dense_rank() over(partition by year_id order by sum(sales) desc) as r
from public.sales_dataset_rfm_prj_clean
group by year_id, month_id
order by year_id;

--Product line nào được bán nhiều ở tháng 11?
select  month_id, productline, sum(sales),
dense_rank() over(partition by month_id order by sum(sales) desc) as r
from public.sales_dataset_rfm_prj_clean
group by month_id, productline
having month_id=11;

--Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm?
select * from (select  year_id, productline, country, sum(sales),
dense_rank() over(partition by year_id,country order by sum(sales) desc) as r
from public.sales_dataset_rfm_prj_clean
group by year_id, productline, country
having country='UK')
where r=1;

--Ai là khách hàng tốt nhất, phân tích dựa vào RFM
with cte1 as 
  (
  select c.customer_id, current_date - max(s.order_date) as r,
  count(distinct s.order_id) as f,
  sum(s.sales) as m
  from customer as c
  join sales as s on c.customer_id=s.customer_id
  group by c.customer_id
  ),
cte2 as 
  (
  select customer_id,
  ntile(5) over(order by r desc) as r_score,
  ntile(5) over(order by f desc) as f_score,
  ntile(5) over(order by m desc) as m_score
  from cte1
  ),
cte3 as 
  (
  select customer_id,
  cast(r_score as varchar)||cast(f_score as varchar)||cast(m_score as varchar) rfm_score
  from cte2
  ),
cte4 as 
  (
  select cte3.customer_id, ss.segment
  from cte3
  join segment_score as ss on cte3.rfm_score=ss.scores
  )
select * 
from cte4
where segment='Champions'
