-- WINDOW FUNCTION 
-- OVER(PARTITION BY...)

/* Phân biệt Window function vs. Group by
- Group by: gộp lại các row giống nhau và chỉ trả ra 1 kqua đã gộp
- Window function: không gộp lại, trả ra 1 kết quả như nhau theo từng khối/window
*/

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

--- Challenge 1a:
select a.film_id, a.title, a.length, c.name, 
avg(length) over(partition by c.name) as avg_cgr_length
from film as a
join film_category as b
on a.film_id=b.film_id 
join category as c
on b.category_id=c.category_id
order by a.film_id
;

--- Challenge 1b:
select *,
count(*) over(partition by customer_id, amount) as count
from payment
order by payment_id
;

-- OVER(ORDER BY...)
SELECT payment_date, amount,
SUM(amount) OVER(ORDER BY payment_date) AS aggregate_total
FROM PAYMENT
;

--- CÚ PHÁP
SELECT col1, col2,
AGG(col2) OVER(PARTITION BY col1,col2 ORDER BY col3) --tính lũy kế theo col3 dựa vào col1, col2
FROM table

-- RANK()
--- Challenge 2:


