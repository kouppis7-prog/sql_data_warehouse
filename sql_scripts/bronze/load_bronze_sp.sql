/*
Stored Procedure for loading data from external CSV files into the 'bronze_layer' schema.
It truncates the tables before loading the data and it uses the 'BULK LOAD' command in order
to load the data.
*/

CREATE OR ALTER PROCEDURE bronze_layer.load_bronze AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME;
		DECLARE @total_time_start DATETIME, @total_time_end DATETIME;
		--Loading Bronze Layer

		--Loading CRM Tables

		SET @total_time_start = GETDATE();

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze_layer.crm_cust_info;
		BULK INSERT bronze_layer.crm_cust_info
		FROM 'C:\Users\prank\Desktop\DWH Project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration for crm_cust_info: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze_layer.crm_prd_info;
		BULK INSERT bronze_layer.crm_prd_info
		FROM 'C:\Users\prank\Desktop\DWH Project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration for crm_prd_info: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze_layer.crm_sales_details;
		BULK INSERT bronze_layer.crm_sales_details
		FROM 'C:\Users\prank\Desktop\DWH Project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration for crm_sales_details: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+ ' sec';

		--Loading ERP Tables	

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze_layer.erp_cust_az12;
		BULK INSERT bronze_layer.erp_cust_az12
		FROM 'C:\Users\prank\Desktop\DWH Project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration for erp_cust_az12: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze_layer.erp_loc_a101;
		BULK INSERT bronze_layer.erp_loc_a101
		FROM 'C:\Users\prank\Desktop\DWH Project\datasets\source_erp\loc_a101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration for erp_loc_a101: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+ ' sec';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze_layer.erp_px_cat_g1v2;
		BULK INSERT bronze_layer.erp_px_cat_g1v2
		FROM 'C:\Users\prank\Desktop\DWH Project\datasets\source_erp\px_cat_g1v2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration for erp_px_cat_g1v2: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec';

		SET @total_time_end = GETDATE();

		PRINT '===================================';
		PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @total_time_start, @total_time_end) AS NVARCHAR) + ' sec';
		PRINT '===================================';
	END TRY

	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH

END
