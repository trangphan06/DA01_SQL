II. Ad-hoc tasks
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

