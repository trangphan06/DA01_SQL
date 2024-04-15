/* III. Tạo metric trước khi dựng dashboard
    1. Build dataset
*/

with cte as
  (
    select 
    format_date('%Y-%m', c.created_at) as month,
    format_date('%Y', c.created_at) as year,
    b.category as product_category,
    round(sum(a.sale_price*c.num_of_item),2) as TPV,
    count(distinct c.order_id) as TPO,
    round(sum(b.cost*c.num_of_item),2) as total_cost
    from bigquery-public-data.thelook_ecommerce.order_items as a
    join bigquery-public-data.thelook_ecommerce.products as b
    on a.product_id=b.id
    join bigquery-public-data.thelook_ecommerce.orders as c
    on c.order_id=a.order_id
    group by month, year, product_category
    order by month, product_category
  ),
cte2 as
(
  select *, 
  round(100.00*(LEAD(TPV) over(partition by product_category order by month) - TPV)/TPV,2)||'%' as revenue_growth,
  round(100.00*(LEAD(TPO) over(partition by product_category order by month) - TPO)/TPO,2)||'%' as revenue_growth,
  round(TPV-total_cost,2) as total_profit,
  round((TPV-total_cost)/total_cost,2) as profit_to_cost_ratio
  from cte
)
select * from cte2

/* 2. Tạo retention cohort analysis
      Ở mỗi cohort chỉ theo dõi 3 tháng (indext từ 1 đến 4)
*/
with cte1 as 
    (
    select user_id, 
    format_date('%Y-%m',created_at) as order_date, 
    min(format_date('%Y-%m',created_at)) over(partition by user_id) as cohort_date
    from bigquery-public-data.thelook_ecommerce.orders
    ),
cte2 as 
    (
    select user_id, cohort_date,
    (extract(year from parse_date('%Y-%m',order_date))-extract(year from parse_date('%Y-%m',cohort_date)))*12 
    + (extract(month from parse_date('%Y-%m',order_date))-extract(month from parse_date('%Y-%m',cohort_date))) + 1 index
    from cte1
    ), 
cte3 as 
    (
    select cohort_date, index,
    count(distinct user_id) cnt
    from cte2
    group by cohort_date, index
    having index<=4
    order by cohort_date, index
    ),
cte4 as 
    (
    select cohort_date,
    sum(case when index=1 then cnt else 0 end) i1,
    sum(case when index=2 then cnt else 0 end) i2,
    sum(case when index=3 then cnt else 0 end) i3,
    sum(case when index=4 then cnt else 0 end) i4
    from cte3
    group by cohort_date
    )
select cohort_date,
round(100.0*i1/i1,2)||'%' as i1,
round(100.0*i2/i1,2)||'%' as i2,
round(100.0*i3/i1,2)||'%' as i3,
round(100.0*i4/i1,2)||'%' as i4
from cte4
order by cohort_date;
