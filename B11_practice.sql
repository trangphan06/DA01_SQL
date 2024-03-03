-- ex1: hackerrank-average-population-of-each-continent. (https://www.hackerrank.com/challenges/average-population-of-each-continent/problem?isFullScreen=true)
select b.CONTINENT, floor(avg(a.POPULATION))
from CITY as a
inner join COUNTRY as b
on b.CODE=a.COUNTRYCODE
group by b.CONTINENT
;

-- ex2: datalemur-signup-confirmation-rate. (https://datalemur.com/questions/signup-confirmation-rate)
SELECT
ROUND(SUM(CASE
  WHEN texts.signup_action='Confirmed' THEN 1
  ELSE 0
END)/CAST(COUNT(DISTINCT emails.email_id) AS decimal),2)  AS confirm_rate 
FROM emails 
LEFT JOIN texts
ON emails.email_id = texts.email_id
;

-- ex3: datalemur-time-spent-snaps. (https://datalemur.com/questions/time-spent-snaps)
SELECT age_breakdown.age_bucket,
ROUND(100*SUM(CASE
  WHEN activities.activity_type='send' THEN activities.time_spent
  ELSE 0
END)/(SUM(CASE
  WHEN activities.activity_type IN ('send','open') THEN activities.time_spent
  ELSE 0
END)),2) AS send_perc,
ROUND(100*SUM(CASE
  WHEN activities.activity_type='open' THEN activities.time_spent
  ELSE 0
END)/(SUM(CASE
  WHEN activities.activity_type IN ('send','open') THEN activities.time_spent
  ELSE 0
END)),2) AS open_perc
FROM activities
LEFT JOIN age_breakdown
ON activities.user_id = age_breakdown.user_id
GROUP BY age_breakdown.age_bucket
;

-- ex4: datalemur-supercloud-customer. (https://datalemur.com/questions/supercloud-customer)
SELECT customer_contracts.customer_id
FROM customer_contracts
LEFT JOIN products 
ON customer_contracts.product_id=products.product_id
GROUP BY customer_contracts.customer_id
HAVING COUNT(DISTINCT products.product_category)=(SELECT COUNT(DISTINCT product_category) FROM products)
;

-- ex5: leetcode-the-number-of-employees-which-report-to-each-employee. (https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/description/?envType=study-plan-v2&envId=top-sql-50)
SELECT mng.employee_id, mng.name, 
count(emp.employee_id) as reports_count, 
round(avg(emp.age),0) as average_age 
FROM Employees as emp
INNER JOIN Employees as mng
ON emp.reports_to=mng.employee_id
;

-- ex6: leetcode-list-the-products-ordered-in-a-period. (https://leetcode.com/problems/list-the-products-ordered-in-a-period/description/?envType=study-plan-v2&envId=top-sql-50)
SELECT Products.product_name,
SUM(Orders.unit) AS unit
FROM Products
INNER JOIN Orders
ON Products.product_id = Orders.product_id
WHERE EXTRACT(year from order_date)=2020 and EXTRACT(month from order_date)=2
GROUP BY Products.product_name
HAVING SUM(Orders.unit)>=100
;

-- ex7: leetcode-sql-page-with-no-likes. (https://datalemur.com/questions/sql-page-with-no-likes)
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes 
ON page_likes.page_id=pages.page_id
WHERE liked_date IS NULL
ORDER BY pages.page_id ASC
;

-- MID-COURSE TEST
/* Câu hỏi 1:
Task: Tạo danh sách tất cả chi phí thay thế (replacement costs) khác nhau của các film.
Question: Chi phí thay thế thấp nhất là bao nhiêu?
Answer: 9.99 */

SELECT DISTINCT replacement_cost FROM film
ORDER BY replacement_cost ASC
LIMIT 1
;

/* Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
1.	low: 9.99 - 19.99
2.	medium: 20.00 - 24.99
3.	high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?
Answer: 514 */

SELECT
SUM(CASE 
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1
	ELSE 0
END) AS low,
SUM(CASE 
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1
	ELSE 0
END) AS medium,
SUM(CASE 
	WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1
	ELSE 0
END) AS high
FROM film
;

/* Task: Tạo danh sách các film_title  bao gồm tiêu đề (title), độ dài (length) và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần. Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?
Answer: Sports : 184 */
SELECT film.title, film.length, category.name
FROM film JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON category.category_id=film_category.category_id
WHERE category.name IN ('Drama','Sports')
ORDER BY film.length DESC
;

/* Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?
Answer: Sports :74 titles */
SELECT category.name,
COUNT(film.title)
FROM film JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON category.category_id=film_category.category_id
GROUP BY category.name
ORDER BY COUNT(film.title) DESC
;

/* Task: Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?
Answer: Susan Davis : 54 movies */
SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id)
FROM actor JOIN film_actor ON actor.actor_id=film_actor.actor_id
GROUP BY actor.first_name, actor.last_name
ORDER BY COUNT(film_actor.film_id) DESC
;

/* Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy?
Answer: 4 */

SELECT COUNT(address.address_id)
FROM address LEFT JOIN customer ON address.address_id = customer.address_id
WHERE customer.address_id IS NULL
;

/* Task: Danh sách các thành phố và doanh thu tương ừng trên từng thành phố 
Question:Thành phố nào đạt doanh thu cao nhất?
Answer: Cape Coral : 221.55 */

SELECT city.city, SUM(payment.amount)
FROM city JOIN address ON city.city_id=address.city_id
JOIN customer ON customer.address_id = address.address_id
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY city.city
ORDER BY SUM(payment.amount) DESC
;

/* Task: Tạo danh sách trả ra 2 cột dữ liệu: 
-	cột 1: thông tin thành phố và đất nước ( format: “city, country")
-	cột 2: doanh thu tương ứng với cột 1
Question: thành phố của đất nước nào đat doanh thu thấp nhất
Answer: United States, Tallahassee : 50.85. */

SELECT CONCAT(city.city, ', ',country.country), SUM(payment.amount)
FROM city JOIN country ON city.country_id=country.country_id
JOIN address ON city.city_id=address.city_id
JOIN customer ON customer.address_id = address.address_id
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY CONCAT(city.city, ', ',country.country)
ORDER BY SUM(payment.amount) ASC
;






