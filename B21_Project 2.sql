II. Ad-hoc tasks
  1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
  Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng (Từ 1/2019-4/2022)
  Output: month_year (yyyy-mm) , total_user, total_order
  Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)
*/

select
format_date('%B %Y', cast(created_at as timestamp)) as month_year,
count(distinct user_id) as total_user,
count(distinct order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
group by month_year
order by month_year 
;
