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
