-- SUBQUERIES TRONG MỆNH ĐỀ WHERE
--- Tìm những hóa đơn có số tiền lớn hơn số tiền TB các hóa đơn
SELECT * FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment)
;
--- Tìm hóa đơn của KH có tên Adam
--- cách 1
select payment.payment_id, customer.first_name, customer.customer_id
from customer inner join payment on customer.customer_id=payment.customer_id
where customer.first_name='ADAM'
;
--- cách 2
select * from payment
where customer_id=(select customer_id from customer 
				   where first_name='ADAM');
				   	   
--- Challenge: Tìm những bộ phim có thời lượng lớn hơn TB các bộ phim 
select film_id, title
from film
where length > (select avg(length) from film)
;

--- Challenge: Tìm những bộ phim có ở store 2 ít nhất 3 lần 
select film_id, title from film
where film_id IN (select film_id
				  from inventory
				  where store_id=2 
				  group by film_id
				  having count(*)>=3);

--- Challenge: Tìm id, họ tên của các KH đã chi tiêu nhiều hơn 100
select customer_id, first_name, last_name FROM customer
where customer_id IN (select customer_id from payment
					  group by customer_id
					  having sum(amount)>100)

-- SUBQUERIES TRONG MỆNH ĐỀ FROM 
--- Tìm những KH có nhiều hơn 30 hóa đơn
select * from
(select customer_id, 
count(payment_id) as so_luong
from payment
group by customer_id) as new_table
where so_luong>30
--- lấy thêm tên KH
select customer.customer_id, new_table.so_luong from
(select customer_id, 
count(payment_id) as so_luong
from payment
group by customer_id) as new_table
inner join customer on customer.customer_id=new_table.customer_id
where so_luong>30
;

-- SUBQUERIES SAU CÂU LỆNH SELECT
--- tính giá trị chênh lệnh mỗi hóa đơn so với gtri TB
select *, 
(select avg(amount) from payment),
(select avg(amount) from payment) - amount as difference
from payment;
--- tính giá trị chênh lệnh giữa số tiền từng hóa đơn so với số tiền thanh toán lớn nhất
select *,
(select max(amount) from payment)-amount as difference
from payment
;

-- CORRELATED SUBQUERIES (truy vấn con tương quan) IN WHERE
--- lấy thông tin KH từ bảng customer có tổng hóa đơn >100
select * 
from customer as a
where customer_id = (select customer_id
					 from payment as b
					 where b.customer_id=a.customer_id
					 group by customer_id
					 having sum(amount)>100)
;
select * 
from customer as a
where EXISTS (select customer_id -- EXISTS chỉ dùng trong câu truy vấn con tương quan
					 from payment as b
					 where b.customer_id=a.customer_id
					 group by customer_id
					 having sum(amount)>100)
;
-- CORRELATED SUBQUERIES (truy vấn con tương quan) IN SELECT
--- mã KH, tên KH, mã thanh toán, số tiền lớn nhất của từng KH
select a.customer_id,
a.first_name||a.last_name,
b.payment_id,
(SELECT MAX(amount) FROM payment
where customer_id=a.customer_id
group by customer_id)
FROM customer as a
JOIN payment as b
ON a.customer_id=b.customer_id
GROUP BY 
a.customer_id,
a.first_name||a.last_name,
b.payment_id
ORDER BY customer_id
;

/* Challenge: 
Liệt kê các khoản thanh toán với tổng số hóa đơn và tổng số tiền mỗi KH phải trả
output: payment_id,customer_id,staff_id,rental_id,amount,payment_date,sum_amount,count_payments 
*/
select *,
(select sum(amount) as sum_amount
from payment
where customer_id = b.customer_id
group by customer_id),
(select count(*) as count_payment
from payment
where customer_id = b.customer_id
group by customer_id)
from payment as b
;
/* Challenge: 
Lấy DS các film có chi phí thay thế lớn nhất trong mỗi loại rating.
Ngoài film_id, title, rating, chi phí thay thế và chi phí thay thế TB mỗi loại rating đó
*/
select film_id, title, rating, replacement_cost,
(select avg(replacement_cost)
 from film as a
 where a.rating=b.rating
 group by rating)
from film as b
where replacement_cost=(select max(replacement_cost) 
						from film as c
						where c.rating=b.rating
						group by rating)
;
-- CTE (common table expression)
--- cú pháp
WITH CTE_name AS
(
  SELECT *
  FROM table
  WHERE conditions) -- CTE Body
SELECT * FROM CTE_name -- CTE usage

/* Tìm KH có nhiều hơn 30 hóa đơn,
kết quả trả ra gồm: mã KH, tên KH, số lượng hóa đơn, tổng số tiền, tg thuê TB 
*/

with total_payment as
(select customer_id, count(payment_id) as so_luong, sum(amount) as so_tien
 from payment
 group by customer_id
 order by customer_id),
avg_rental_time as
(select customer_id, avg(return_date-rental_date) as rental_time
 from rental
 group by customer_id)
SELECT a.customer_id, a.first_name, b.so_luong, b.so_tien, c.rental_time
from customer as a
join total_payment as b on a.customer_id=b.customer_id
join avg_rental_time as c on c.customer_id=a.customer_id
where b.so_luong>30
;

/* Tìm những hóa đơn có số tiền cao hơn
số tiền TB của KH đó chi tiêu trên mỗi hóa đơn,
kq trả ra gồm: mã KH, tên KH, số lượng hóa đơn, số tiền, số tiền TB của KH đó 
*/

with so_luong as
(select customer_id, count(payment_id) as so_luong
 from payment
 group by customer_id),
so_tien_TB as
 (select customer_id, avg(amount) as avg_amount
 from payment
 group by customer_id)
select a.customer_id, a.first_name, b.so_luong, c.avg_amount, d.amount
from customer as a
join so_luong as b on a.customer_id=b.customer_id
join so_tien_TB as c on a.customer_id=c.customer_id
join payment as d on d.customer_id=a.customer_id
where d.amount>c.avg_amount
