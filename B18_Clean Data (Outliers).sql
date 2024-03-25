select * from user_data
-- using boxplot/IQR
--- B1: Tính Q1, Q3, IQR
select 
percentile_cont(0.25) within group (order by users) as Q1,
percentile_cont(0.75) within group (order by users) as Q3,
(percentile_cont(0.75) within group (order by users) - percentile_cont(0.25) within group (order by users))
as IQR
from user_data

--- B2: Xđịnh min=Q1-1.5*IQR; max=Q3+1.5*IQR
select 
Q1-1.5*IQR as min_value,
Q3+1.5*IQR as max_value
from 
(
select 
percentile_cont(0.25) within group (order by users) as Q1,
percentile_cont(0.75) within group (order by users) as Q3,
(percentile_cont(0.75) within group (order by users) - percentile_cont(0.25) within group (order by users))
as IQR
from user_data
) as IQR_table

--- B3: Xđịnh outlier <min or >max
with cte as 
(
select 
Q1-1.5*IQR as min_value,
Q3+1.5*IQR as max_value
from 
(
select 
percentile_cont(0.25) within group (order by users) as Q1,
percentile_cont(0.75) within group (order by users) as Q3,
(percentile_cont(0.75) within group (order by users) - percentile_cont(0.25) within group (order by users))
as IQR
from user_data
) as IQR_table
)
select * from user_data
where users<(select min_value from cte)
   or users>(select max_value from cte)

-- using Z-SCORE = (users-avg)/stddev
with twt_outlier as (
with cte as (
select data_date,
users,
(select avg(users) from user_data) as avg,
(select stddev(users) from user_data) as stddev
from user_data
)
select data_date, users, 
(users-avg)/stddev as z_score
from cte
where abs((users-avg)/stddev)>2 -- chọn outlier, >2 hay >3 tùy bài toán
)
UPDATE user_data
SET users=(select avg(users) from user_data) -- thay thành giá trị TB
where users in(select users from twt_outlier)

--- or nếu muốn xóa
deleter from user_data
where users in(select users from twt_outlier)
