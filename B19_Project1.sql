-- 1. ALTER DATA TYPES
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN ordernumber TYPE INT USING (ordernumber::INT),
ALTER COLUMN quantityordered TYPE INT USING (quantityordered::INT),
ALTER COLUMN priceeach TYPE FLOAT USING (priceeach::FLOAT),
ALTER COLUMN orderlinenumber TYPE INT USING (orderlinenumber::INT),
ALTER COLUMN sales TYPE FLOAT USING (sales::FLOAT),
ALTER COLUMN orderdate TYPE TIMESTAMP USING (orderdate::TIMESTAMP),
ALTER COLUMN msrp TYPE INT USING (msrp::INT);

-- 2. Check NULL/BLANK (‘’): ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT 
SUM(CASE WHEN CAST(ORDERNUMBER AS VARCHAR)='' THEN 1
	 WHEN ORDERNUMBER IS NULL THEN 1
	 ELSE 0 
END) AS ORDERNUMBER_NB,
SUM(CASE WHEN CAST(QUANTITYORDERED AS VARCHAR)='' THEN 1
	 WHEN QUANTITYORDERED IS NULL THEN 1
	 ELSE 0 
END) AS QUANTITYORDERED_NB,
SUM(CASE WHEN CAST(PRICEEACH AS VARCHAR)='' THEN 1
	 WHEN PRICEEACH IS NULL THEN 1
	 ELSE 0 
END) AS PRICEEACH_NB,
SUM(CASE WHEN CAST(ORDERLINENUMBER AS VARCHAR)='' THEN 1
	 WHEN ORDERLINENUMBER IS NULL THEN 1
	 ELSE 0 
END) AS ORDERLINENUMBER_NB,
SUM(CASE WHEN CAST(SALES AS VARCHAR)='' THEN 1
	 WHEN SALES IS NULL THEN 1
	 ELSE 0 
END) AS SALES_NB,
SUM(CASE WHEN CAST(ORDERDATE AS VARCHAR)='' THEN 1
	 WHEN ORDERDATE IS NULL THEN 1
	 ELSE 0 
END) AS ORDERDATE_NB
FROM SALES_DATASET_RFM_PRJ
;

-- 3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME. 
-- Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
-- Gợi ý: ( ADD column sau đó UPDATE)
ALTER TABLE sales_dataset_rfm_prj
ADD column CONTACTLASTNAME VARCHAR, 
ADD column CONTACTFIRSTNAME VARCHAR;

UPDATE sales_dataset_rfm_prj
SET CONTACTLASTNAME=CONCAT(UPPER(LEFT(CONTACTFULLNAME,1)),
						   SUBSTRING(CONTACTFULLNAME FROM 2 FOR (POSITION('-' in CONTACTFULLNAME)-2))),
	CONTACTFIRSTNAME=CONCAT(UPPER(SUBSTRING(CONTACTFULLNAME FROM (POSITION('-' IN CONTACTFULLNAME)+1) FOR 1)),
							RIGHT(CONTACTFULLNAME,LENGTH(CONTACTFULLNAME)-POSITION('-' in CONTACTFULLNAME)-1));

-- 4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT, 
ADD COLUMN YEAR_ID INT;

UPDATE sales_dataset_rfm_prj
SET MONTH_ID=EXTRACT(month FROM orderdate),
	YEAR_ID=EXTRACT(year FROM orderdate),
	QTR_ID=EXTRACT(quarter FROM orderdate);


