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
/* B2: 
- Tìm ngày mua hàng đầu tiên của mỗi KH --> cohort_date
- Tìm index=tháng (ngày mua hàng-ngày đầu tiên)+1
- Count số lượng KH hoặc tổng doanh thu tại mỗi cohort_date và index tương ứng
- Pivot table */
with cleaned_online_retail as (select invoiceno, 
							                 stockcode, 
                                description, 
							                 CAST(quantity AS int), 
							                 CAST(invoicedate AS timestamp), 
							                 CAST(unitprice AS numeric), 
							                 customerid, country
							                 from online_retail
							                 where customerid IS NOT NULL OR customerid<>''
					              		   and CAST(unitprice AS numeric)>0 and CAST(quantity AS int)>0
					              		  ),
main_online_retail as (select * from (select  
									                    row_number() over (partition by invoiceno, stockcode order by invoicedate) as stt, *
									                    from cleaned_online_retail
									                    ) as stt_table
			          		   where stt=1),
online_retail_index as (select customerid, amount,
				            		to_char(first_purchased_date, 'yyyy-mm') as cohort_date,
				            		invoicedate,
				            		(extract('year' from invoicedate)-extract('year' from first_purchased_date))*12+
				            		(extract('month' from invoicedate)-extract('month' from first_purchased_date))+1 as index
				            		from (select customerid, 
				            		      quantity*unitprice as amount,
				            		      min(invoicedate) over(partition by customerid) as first_purchased_date,
				            		      invoicedate
				            		      from main_online_retail
				            		      ) as a
				            		),
xxx as (select cohort_date, index, 
		    count(distinct customerid) as count,
		    sum(amount) as revenue						
		    from online_retail_index
	    	group by cohort_date, index
		    ),
/* B3: pivot table --> cohort chart */
xxy as (
select cohort_date,
sum(case when index=1 then count else 0 end) as "m1",
sum(case when index=2 then count else 0 end) as "m2",
sum(case when index=3 then count else 0 end) as "m3",
sum(case when index=4 then count else 0 end) as "m4",
sum(case when index=5 then count else 0 end) as "m5",
sum(case when index=6 then count else 0 end) as "m6",
sum(case when index=7 then count else 0 end) as "m7",
sum(case when index=8 then count else 0 end) as "m8",
sum(case when index=9 then count else 0 end) as "m9",
sum(case when index=10 then count else 0 end) as "m10",
sum(case when index=11 then count else 0 end) as "m11",
sum(case when index=12 then count else 0 end) as "m12",
sum(case when index=13 then count else 0 end) as "m13"
from xxx
group by cohort_date
order by cohort_date
)
-- retention cohort
select
round(100.00*m1/m1,2)||'%' as m1, 
round(100.00*m2/m1,2)||'%' as m2,
round(100.00*m3/m1,2)||'%' as m3,
round(100.00*m4/m1,2)||'%' as m4,
round(100.00*m5/m1,2)||'%' as m5,
round(100.00*m6/m1,2)||'%' as m6,
round(100.00*m7/m1,2)||'%' as m7,
round(100.00*m8/m1,2)||'%' as m8,
round(100.00*m9/m1,2)||'%' as m9,
round(100.00*m10/m1,2)||'%' as m10,
round(100.00*m11/m1,2)||'%' as m11,
round(100.00*m12/m1,2)||'%' as m12,
round(100.00*m13/m1,2)||'%' as m13
from xxy
-- churn cohort
select
(100-round(100.00*m1/m1,2))||'%' as m1, 
(100-round(100.00*m2/m1,2))||'%' as m2,
(100-round(100.00*m3/m1,2))||'%' as m3,
(100-round(100.00*m4/m1,2))||'%' as m4,
(100-round(100.00*m5/m1,2))||'%' as m5,
(100-round(100.00*m6/m1,2))||'%' as m6,
(100-round(100.00*m7/m1,2))||'%' as m7,
(100-round(100.00*m8/m1,2))||'%' as m8,
(100-round(100.00*m9/m1,2))||'%' as m9,
(100-round(100.00*m10/m1,2))||'%' as m10,
(100-round(100.00*m11/m1,2))||'%' as m11,
(100-round(100.00*m12/m1,2))||'%' as m12,
(100-round(100.00*m13/m1,2))||'%' as m13
from xxy
