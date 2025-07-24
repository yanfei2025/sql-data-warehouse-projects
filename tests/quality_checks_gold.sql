




--Check if there is duplicates after LEFT JOIN Table

SELECT cst_id, COUNT(*) FROM
(SELECT
ci.cst_id,
ci.cst_key,cst_firstname,
ci.cst_lastname,
ci.cst_mariatal_status,
ci.cst_gndr,
ci.cst_create_data,
ca.bdate,
ca.gen,
la.cntry
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
ON ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*) > 1




--Check if there is duplicates after LEFT JOIN Table
SELECT prd_key,
COUNT(*) 
FROM
(
SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL  --Filter out all historical dt
)t GROUP BY prd_key
HAVING COUNT(*) > 1


--Foreign key integrity（Dimentions）
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL






