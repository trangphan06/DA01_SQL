-- JOIN
--- INNER JOIN: trả về giá trị trùng khớp cả 2 bảng
--- Cú pháp: table1 INNER JOIN table 2
SELECT t1.*, t2.*
FROM table1 AS t1
INNER JOIN table2 AS t2
ON t1.key1=t2.key2;

--- Ví dụ:
SELECT a.payment_id, a.customer_id, b.first_name, b.last_name -- select các cột nào từ bảng đã inner join
FROM payment AS a
INNER JOIN customer AS b
ON a.customer_id=b.customer_id;

/* 
Challenge: có bn người chọn ghế ngồi theo các loại:
- Business
- Economy
- Comfort 
*/
select b.fare_conditions,
count(*)
from boarding_passes as a
inner join seats as b
on a.seat_no=b.seat_no
group by b.fare_conditions
;

--- LEFT/RIGHT JOIN: lấy gốc theo bảng bên trái/phải
/* 
tìm các chuyến bay của từng máy bay 
*/
select a.aircraft_code, b.flight_id
from aircrafts_data as a
left join flights as b
on a.aircraft_code = b.aircraft_code
;
/* 
tìm máy bay mà đang không có chuyến bay nào 
*/
select a.aircraft_code, b.flight_id
from aircrafts_data as a
left join flights as b
on a.aircraft_code = b.aircraft_code
where flight_id is null
;

/* Challenge
Tìm hiểu ghế nào đc chọn thường xuyên nhất
(đảm bảo các ghế đều đc liệt kê ngay cả khi chúng chưa bh đc đặt)
Có chỗ ngồi nào chưa bh đc đặt ko?
Chỉ ra hàng ghế nào đc đặt thường xuyên nhất (A,B,C...)
*/
select a.seat_no, 
count(*)
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
group by a.seat_no
order by count(*) DESC -- ghế 1A đc chọn thường xuyên nhất
;
select a.seat_no, 
count(*)
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
where a.seat_no is null
group by a.seat_no
order by count(*) DESC -- ko có chỗ ngồi nào chưa bh đc đặt
;
select right(a.seat_no,1), 
count(*)
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
group by right(a.seat_no,1)
order by count(*) DESC -- hạng A đc đặt thường xuyên nhất
;

-- FULL JOIN
--- tìm những vé máy bay không được cấp thẻ lên máy bay
select count(*)
from boarding_passes as a
full join tickets as b
on a.ticket_no=b.ticket_no
where a.boarding_no is null
;

-- JOIN ON MULTIPLE CONDITIONS
--- có những trường hợp phải cần 2 keys để thông tin được đúng nhất
/* 
Tính giá trung bình của từng số ghế máy bay
- Xdinh output, input => số ghế, giá trung bình
*/
select a.seat_no, avg(b.amount) as average_amount
from boarding_passes as a
left join ticket_flights as b
on a.ticket_no=b.ticket_no 
and a.flight_id=b.flight_id
group by a.seat_no
order by avg(b.amount)
;

-- JOIN MULTIPLE TABLES
--- truy vấn bảng gồm số vé, tên KH, giá vé, giờ bay, giờ kết thúc 
select a.ticket_no, a.passenger_name, b.amount, c.scheduled_departure, c.scheduled_arrival
from tickets as a
inner join ticket_flights as b on a.ticket_no=b.ticket_no
inner join flights as c on b.flight_id=c.flight_id
;

-- SELF JOIN
CREATE TABLE employee (
	employee_id INT,
	name VARCHAR (50),
	manager_id INT
);

INSERT INTO employee 
VALUES
	(1, 'Liam Smith', NULL),
	(2, 'Oliver Brown', 1),
	(3, 'Elijah Jones', 1),
	(4, 'William Miller', 1),
	(5, 'James Davis', 2),
	(6, 'Olivia Hernandez', 2),
	(7, 'Emma Lopez', 2),
	(8, 'Sophia Andersen', 2),
	(9, 'Mia Lee', 3),
	(10, 'Ava Robinson', 3);

select emp.employee_id, emp.name as emp_name, emp.manager_id, mng.name as mng_name
from employee as emp 
left join employee as mng 
on emp.manager_id = mng.employee_id
;

-- UNION
/*
- Số lượng cột ở 2 bảng giống nhau
- Kiểu dữ liệu trong cùng 1 cột giống nhau
- UNION loại trùng lặp, UNION ALL thì không
*/

--- cú pháp
select col1,col2,col3...
from table1
UNION/UNION ALL
select col1,col2,...
from table 2
UNION/UNION ALL
select col1,col2,...
from table 3
...

select first_name, 'actor' as source from actor
union all
select first_name, 'customer' as source from customer
union all
select first_name, 'staff' as source from staff
;
