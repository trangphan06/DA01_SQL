/* Khám phá & làm sạch data
- Quan tâm trường nào?
- Check null
- Chuyển đổi data type
- Số tiền & số lượng > 0
- Check dup */

select * from online_retail

-- bao nhiêu bản ghi? 541909
select count(*) from online_retail

-- check null
select * from online_retail
where invoiceno IS NULL OR invoiceno='';
select * from online_retail
where stockcode IS NULL OR stockcode='';
select count(*) from online_retail
where description IS NULL OR description='';
select * from online_retail
where quantity IS NULL OR quantity='';
select * from online_retail
where invoicedate IS NULL OR invoicedate='';
select * from online_retail
where unitprice IS NULL OR unitprice='';
select count(*) from online_retail
where customerid IS NULL OR customerid='';
select * from online_retail
where country IS NULL OR country='';

-- chỉ chọn bản ghi với customerid không null
select * from online_retail
where customerid IS NOT NULL OR customerid<>'';

-- Chuyển đổi data type; số tiền, số lượng > 0, check dup
with cleaned_online_retail as (
select invoiceno, 
stockcode, 
description, 
CAST(quantity AS int), 
CAST(invoicedate AS timestamp), 
CAST(unitprice AS numeric), 
customerid, 
country
from online_retail
where customerid IS NOT NULL OR customerid<>''
and CAST(unitprice AS numeric)>0 and CAST(quantity AS int)>0
),
main_online_retail as (
select * from (select  
row_number() over (partition by invoiceno, stockcode order by invoicedate) as stt, *
from cleaned_online_retail) as stt_table
where stt=1
)
select * from main_online_retail

/* B2: 
- Tìm ngày mua hàng đầu tiên của mỗi KH --> cohort_date
- Tìm index=tháng (ngày mua hàng-ngày đầu tiên)+1
- Count số lượng KH hoặc tổng doanh thu tại mỗi cohort_date và index tương ứng
- Pivot table */
