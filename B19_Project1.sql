-- ALTER DATA TYPES
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN ordernumber TYPE INT USING (ordernumber::INT),
ALTER COLUMN quantityordered TYPE INT USING (quantityordered::INT),
ALTER COLUMN priceeach TYPE FLOAT USING (priceeach::FLOAT),
ALTER COLUMN orderlinenumber TYPE INT USING (orderlinenumber::INT),
ALTER COLUMN sales TYPE FLOAT USING (sales::FLOAT),
ALTER COLUMN orderdate TYPE TIMESTAMP USING (orderdate::TIMESTAMP),
ALTER COLUMN msrp TYPE INT USING (msrp::INT);

-- Check NULL/BLANK (‘’): ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
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

