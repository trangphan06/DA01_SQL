-- CASE-WHEN
/* 
Hãy phân loại các bộ phim theo thời lượng short-medium-long cụ thể:
- short: <60p
- medium: 60-120p
- long: >120p 
*/
=>> CASE
		WHEN...THEN
	END ;
--- Cách 1:
SELECT film_id,
CASE
	WHEN length<60 THEN 'short'
	WHEN length BETWEEN 60 AND 120 THEN 'medium'
	WHEN length>120 THEN 'long' -- nếu không có câu này thì trả giá trị null
END AS category
FROM film
;
--- Cách 2:
SELECT film_id,
CASE
	WHEN length<60 THEN 'short'
	WHEN length BETWEEN 60 AND 120 THEN 'medium'
	ELSE 'long' -- cách 2
END AS category
FROM film
;

/* 
Muốn đếm mỗi loại có bao nhiêu phim 
*/
SELECT
CASE
	WHEN length<60 THEN 'short'
	WHEN length BETWEEN 60 AND 120 THEN 'medium'
	ELSE 'long'
END AS category,
COUNT(*) AS so_luong
FROM film
GROUP BY category
;

/* 
bộ phim có tag là 1 nếu trường rating là G hoặc PG,
tag là 0 nếu thuộc các trường hợp còn lại 
*/
SELECT film_id,
CASE
	WHEN rating='G' OR rating='PG' THEN 1
	ELSE 0
END AS tag
FROM film
;

/* Challenge 1:
tìm hiểu cty đã bán bn vé trong danh mục:
- Low price ticker: total_amount < 20,000
- Mid price ticker: 20,000 < total_amount < 150,000
- High price ticker: total_amount <= 150,000 
*/
select 
case
	when amount<20000 then 'Low price ticket'
	when amount between 20000 and 150000 then 'Mid price ticket'
	when amount>=150000 then 'High price ticket'
end as category,
count(*) as number_of_tickets
from ticket_flights
group by category
;

/* Challenge 2
Có bn chuyến bay đã khởi hành vào các mùa:
- Xuân: tháng 2,3,4
- Hè: tháng 5,6,7
- Thu: tháng 8,9,10
- Đông: tháng 11,12,1 */
select 
case 
	when extract(month from scheduled_departure) in (2,3,4) then 'xuân'
	when extract(month from scheduled_departure) in (5,6,7) then 'hè' 
	when extract(month from scheduled_departure) in (8,9,10) then 'thu'
	when extract(month from scheduled_departure) in (11,12,1) then 'đông'
end as season,
count(*) as number_of_flights
from flights
group by season
;

/* 
Challenge 3
Tạo list phim phân cấp độ theo cách:
- Xếp hạng 'PG' hoặc 'PG-13' hoặc thời lượng hơn 210 phút: 'Great rating or long (tier 1)'
- Mô tả chứa 'Drama' và thời lượng hơn 90 phút: 'Long drama (tier 2)'
- Mô tả chứa 'Drama' và thời lượng không quá 90 phút: 'Chcity drama (tier 3)'
- Giá thuê thấp hơn $1: 'Very cheap (tier 4)'  
Nếu 1 bộ phim có thể thuộc nhiều danh mục, nó sẽ được chỉ định ở cấp cao hơn.
Làm cách nào để chỉ lọc những phim xuất hiện ở ít nhất 1 trong 4 cấp độ?
*/
select film_id, 
case
	when ((rating in ('PG','PG-13')) or length>210) then 'Great rating or long (tier 1)'
	when (description like '%Drama%') and (length>90) then 'Long drama (tier 2)'
	when (description like '%Drama%') and (length<=90) then 'Chcity drama (tier 3)'
	when rental_rate<1 then 'Very cheap (tier 4)'
end as category
from film
where (case
	when ((rating in ('PG','PG-13')) or length>210) then 'Great rating or long (tier 1)'
	when (description like '%Drama%') and (length>90) then 'Long drama (tier 2)'
	when (description like '%Drama%') and (length<=90) then 'Chcity drama (tier 3)'
	when rental_rate<1 then 'Very cheap (tier 4)'
end) is not null
;

-- COALESE
-- CAST
-- PIVOT TABLE
