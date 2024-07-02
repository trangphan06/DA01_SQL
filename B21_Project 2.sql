Ecommerce Dataset: Exploratory Data Analysis (EDA) and Cohort Analysis in SQL
/* Ad-hoc tasks
  1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
  Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng (Từ 1/2019-4/2022)
  Output: month_year (yyyy-mm) , total_user, total_order
  Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)
*/

select
format_date('%Y-%m', created_at) as month_year,
count(distinct user_id) as total_user,
count(distinct order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
group by month_year
order by month_year 
;

/* Insight: 
- Nhìn chung, số lượng order tăng đều theo thời gian, mỗi năm cũng tăng đều, chưa thấy seasonal trend rõ rệt. 
- Những năm đầu, số lượng total_order và total_user bằng nhau hoặc chênh nhau ít, chứng tỏ mỗi user mua hàng với số lượng lẻ tẻ, nhỏ giọt.
- Những năm gần đây, số lượng total_user lớn hơn số lượng total_order, chứng tỏ mỗi user bắt đầu mua hàng với số lượng nhiều hơn, đỉnh điểm là trong 4 tháng gần nhất.
*/

/* 
  2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
  Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng (Từ 1/2019-4/2022)
  Output: month_year (yyyy-mm), distinct_users, average_order_value
*/

select format_date('%Y-%m', b.created_at) as month_year,
count(distinct b.user_id) as distinct_users,
round(avg(a.sale_price*b.num_of_item),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.orders as b
on b.order_id=a.order_id
where format_date('%Y-%m', b.created_at) < '2022-05'
group by month_year
order by month_year 

/* 
  3. Nhóm khách hàng theo độ tuổi
  Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính (Từ 1/2019-4/2022)
  Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
*/
/* 
  3. Nhóm khách hàng theo độ tuổi
  Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính (Từ 1/2019-4/2022)
  Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
*/
with youngest_female as 
(
select first_name, last_name, gender, age,
"youngest" as tag
from bigquery-public-data.thelook_ecommerce.users
where gender='F'
and age=(select min(age) 
         from bigquery-public-data.thelook_ecommerce.users
         where gender='F')
),
youngest_male as 
(
select first_name, last_name, gender, age,
"youngest" as tag
from bigquery-public-data.thelook_ecommerce.users
where gender='M'
and age=(select min(age) 
         from bigquery-public-data.thelook_ecommerce.users
         where gender='M')
),
oldest_female as 
(
select first_name, last_name, gender, age,
"oldest" as tag
from bigquery-public-data.thelook_ecommerce.users
where gender='F'
and age=(select max(age) 
         from bigquery-public-data.thelook_ecommerce.users
         where gender='F')
),
oldest_male as 
(
select first_name, last_name, gender, age,
"oldest" as tag
from bigquery-public-data.thelook_ecommerce.users
where gender='M'
and age=(select max(age) 
         from bigquery-public-data.thelook_ecommerce.users
         where gender='M')
),
tong_hop as 
(
select first_name, last_name, gender, age, tag
from youngest_female
UNION ALL
select first_name, last_name, gender, age, tag
from youngest_male
UNION ALL
select first_name, last_name, gender, age, tag
from oldest_female
UNION ALL
select first_name, last_name, gender, age, tag
from oldest_male
)
select gender, tag, count(*)
from tong_hop
group by gender, tag

/* Insight:
- Ở cả 2 gender, trẻ nhất đều là 12 tuổi, lớn nhất đều là 70 tuổi
- Oldest female có số lượng ít nhất là 784
- Youngest female có số lượng nhiều nhất là 876
*/

/* 
  4.Top 5 sản phẩm mỗi tháng.
  Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
  Output: month_year (yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
*/
with cte as 
(
select format_date('%Y-%m', a.created_at) as month_year,
a.product_id as product_id,
b.name as product_name,
sum(a.sale_price) as sales,
sum(b.cost) as cost,
sum(a.sale_price)-sum(b.cost) as profit
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
group by month_year, a.product_id, b.name
order by month_year
),
rank_table as 
(
select *,
dense_rank() over(partition by month_year order by profit) as rank_per_month
from cte
)
select *
from rank_table
where rank_per_month <6
order by month_year
;

/* 
  5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
  Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua (giả sử ngày hiện tại là 15/4/2022) 
  Output: dates (yyyy-mm-dd), product_categories, revenue
*/
with cte as
(
select format_date('%Y-%m-%d', a.created_at) as dates,
b.category as product_categories,
sum(a.sale_price) as revenue
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
group by dates, b.category
)
select * from cte
where PARSE_DATE('%Y-%m-%d',dates) >= date_sub('2022-04-15', interval 3 month)
and dates<='2022-04-15'
order by dates
;
