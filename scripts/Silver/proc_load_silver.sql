
Script purpose:
  -Truncate silver tables
  -Inserts transformed and cleansed data from Bronze into Silver tables.

  




CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN
    TRUNCATE TABLE Silver.crm_cust_info
    INSERT INTO Silver.crm_cust_info(
      cst_id,
      cst_key,
      cst_firstname,
      cst_lastname,
      cst_material_status,
      cst_gndr,
      cst_create_data
    )
    SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
         WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
         ELSE 'n/a'
    END cst_marital_status,
    CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
         WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
         ELSE 'n/a'
    END cst_gndr,
    cst_create_data
    FROM(
    SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_data DESC) as flag_last
    FROM bronze.crm_cust_info
    )t WHERE flag_last = 1




    TRUNCATE TABLE silver.crm_prd_info
    INSERT INTO silver.crm_prd_info(
      prd_id,
      cat_id,
      prd_key,
      prd_nm,
      prd_cost,
      prd_line,
      prd_start_dt,
      prd_end_dt 
    )
    SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
         WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
         WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
         WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
         ELSE 'n/a'
    END AS prd_line,
    CAST (prd_start_dt AS DATE) AS prd_start_dt,
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
    FROM Bronze.crm_prd_info




    TRUNCATE TABLE silver.crm_sales_details
    INSERT INTO silver.crm_sales_details(
          sls_ord_num,
          sls_prd_key,
          sls_cust_id,
          sls_order_dt,
          sls_ship_dt,
          sls_due_dt,
          sls_sales,
          sls_quantity,
          sls_price
    )
    SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
    CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,
    CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
         THEN sls_quantity * ABS(sls_price)
         ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE WHEN sls_price IS NULL OR sls_price <= 0
         THEN sls_sales / NULLIF(sls_quantity, 0)
         ELSE sls_price
    END AS sls_price
    FROM Bronze.crm_sales_details





    TRUNCATE TABLE Silver.erp_cust_az12
    INSERT INTO Silver.erp_cust_az12(cid, bdate, gen)
    SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
         ELSE cid
    END AS cid,
    CASE WHEN bdate > GETDATE() THEN NULL
         ELSE bdate
    END AS bdate,
    CASE WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
         WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Feale'
         ELSE 'n/a'
    END AS gen
    FROM Bronze.erp_cust_az12


    TRUNCATE TABLE Silver.erp_loc_a101
    INSERT INTO Silver.erp_loc_a101(cid, cntry)
    SELECT 
    REPLACE(cid, '-', '') cid,
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
         WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
         WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
         ELSE cntry
    END AS cntry
    FROM Bronze.erp_loc_a101



    TRUNCATE TABLE Silver.erp_px_cat_g1v2
    INSERT INTO Silver.erp_px_cat_g1v2(
    id,
    cat,
    subcat,
    maintenance
    )
    SELECT
    id,
    cat,
    subcat,
    maintenance
    FROM Bronze.erp_px_cat_g1v2;
END
