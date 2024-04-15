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

