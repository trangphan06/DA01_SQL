-- WINDOW FUNCTION with SUM(), COUNT(), AVG(), COUNT()
/* Tính tỉ lệ số tiền thanh toán từng ngày với
tổng số tiền đã thanh toán của mỗi KH
Output: mã KH, tên KH, ngày thanh toán, số tiền thanh toán tại ngày, 
tổng số tiền đã thanh toán, tỉ lệ */
--- cách 1
with cte as (
select a.customer_id, a.first_name, to_char(b.payment_date, 'yyyy-mm-dd') as date, sum(b.amount) as daily_amount,
(select sum(amount) as total_amount from payment as c
 where c.customer_id=a.customer_id
group by customer_id)
from customer as a
inner join payment as b
on a.customer_id=b.customer_id
group by a.customer_id, to_char(b.payment_date, 'yyyy-mm-dd')
order by customer_id
)
select customer_id, first_name, date, daily_amount, total_amount, 
round(daily_amount/total_amount,2) as ratio from cte
;
--- cách 2
select a.customer_id, a.first_name, to_char(b.payment_date, 'yyyy-mm-dd'), sum(b.amount) as daily_amount,
sum(sum(b.amount)) over(partition by a.customer_id) as total_amount,
round(sum(b.amount)/sum(sum(b.amount)) over(partition by a.customer_id),2) as ratio
from customer as a
inner join payment as b
on a.customer_id=b.customer_id
group by a.customer_id, to_char(b.payment_date, 'yyyy-mm-dd')
order by a.customer_id, to_char(b.payment_date, 'yyyy-mm-dd')
;
