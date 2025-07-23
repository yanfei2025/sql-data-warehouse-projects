


CREATE OR ALTER PROCEDURE Bronze.load_Bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DA
BEGIN TRY
PRINT '============================================================';
PRINT 'Loading Bronze Layer';
PRINT '============================================================';

PRINT '------------------------------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Truncating Table:Bronze.crm_cust_info';
TRUNCATE TABLE Bronze.crm_cust_info;

PRINT '>> Inserting Data Into:Bronze.crm_cust_info';
BULK INSERT Bronze.crm_cust_info
FROM 'C:\Users\86195\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
WITH(
 FIRSTROW = 2,
 FIELDTERMINATOR = ',',
 TABLOCK
 );
 SET @end_time = GETDATE();
 PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


TRUNCATE TABLE Bronze.crm_prd_info
BULK INSERT Bronze.crm_prd_info
FROM 'C:\Users\86195\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
WITH(
 FIRSTROW = 2,
 FIELDTERMINATOR = ',',
 TABLOCK
 );

TRUNCATE TABLE Bronze.crm_sales_details;
BULK INSERT Bronze.crm_sales_details
FROM 'C:\Users\86195\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
WITH(
 FIRSTROW = 2,
 FIELDTERMINATOR = ',',
 TABLOCK
 );

PRINT '------------------------------------------------------------';
PRINT 'Loading ERP Tables';
PRINT '------------------------------------------------------------';

TRUNCATE TABLE Bronze.erp_loc_a101;
BULK INSERT Bronze.erp_loc_a101
FROM 'C:\Users\86195\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
WITH(
 FIRSTROW = 2,
 FIELDTERMINATOR = ',',
 TABLOCK
 );

TRUNCATE TABLE Bronze.erp_cust_az12;
BULK INSERT Bronze.erp_cust_az12
FROM 'C:\Users\86195\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
WITH(
 FIRSTROW = 2,
 FIELDTERMINATOR = ',',
 TABLOCK
 );

TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
BULK INSERT Bronze.erp_px_cat_g1v2
FROM 'C:\Users\86195\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
WITH(
 FIRSTROW = 2,
 FIELDTERMINATOR = ',',
 TABLOCK
 );
 END TRY
 BEGIN CATCH
 END CATCH
 END
