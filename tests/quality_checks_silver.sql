
--Check for nulls or duplicates in Primary key
--Expection: No result

SELECT
cst_id,
COUNT(*)
FROM Bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--Check for unwanted spaces
--Expectation: No results
SELECT cst_key
FROM Bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key)

--Data Standardization & Consistency
SELECT DISTINCT cst_material_status
FROM Bronze.crm_cust_info


--Check for nulls or duplicates in Primary key
--Expection: No result

SELECT
prd_id,
COUNT(*)
FROM Bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--Check for unwanted spaces
--Expectation: No results
SELECT prd_nm
FROM Bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for Nulls or Negative Numbers
--Expectation: No results
SELECT
prd_cost
FROM Bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM Bronze.crm_prd_info

--Check for Invalid date
SELECT
NULLIF(sls_order_dt,0) sls_order_date
FROM Bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt <19000101

--Check for Invalid Date Orders
SELECT
*
FROM Bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


-- >> sales = quantity * price
-- >> Values must not be NULL, zero, or negative.
SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
     THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0
     THEN sls_sales / NULLIF(sls_quantity, 0)
     ELSE sls_price
END AS sls_price
FROM Bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

--Identify Our-Of-Range Date
SELECT DISTINCT
bdate
FROM Bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

--Check for unwanted spaces
SELECT *
FROM Bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

--Data Standardization & Consistency
SELECT DISTINCT
maintenance 
FROM Bronze.erp_px_cat_g1v2
