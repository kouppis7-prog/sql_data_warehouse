--This script creates the view for the gold layer in the data warehouse.
--These views can be queried directly for analytics and reporting

CREATE VIEW gold_layer.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ca.bdate AS birthdate,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gender != 'Unknown' THEN ci.cst_gender
		 ELSE COALESCE(ca.gen, 'Unknown')
	END AS gender,
	ci.cst_create_date AS create_date
FROM silver_layer.crm_cust_info ci
LEFT JOIN silver_layer.erp_cust_az12 ca 
		  ON ci.cst_key = ca.cid
LEFT JOIN silver_layer.erp_loc_a101 la
		  ON ci.cst_key = la.cid

CREATE VIEW gold_layer.dim_products AS	
SELECT 
	ROW_NUMBER() OVER(ORDER BY pin.prd_start_date, pin.prd_key ) AS product_key,
	pin.prd_id AS product_id,
	pin.prd_key AS product_code,
	pin.prd_nm AS product_name,
	pin.cat_id AS category_id,
	pcat.cat AS category,
	pcat.subcat AS sub_category,
	pcat.maintenance,
	pin.prd_cost AS cost,
	pin.prd_line AS product_line,
	pin.prd_start_date AS start_date
FROM silver_layer.crm_prd_info pin
LEFT JOIN silver_layer.erp_px_cat_g1v2 pcat ON pin.cat_id = pcat.id
WHERE prd_end_dt IS NULL --Filter out historical data

CREATE VIEW gold_layer.fact_sales AS
SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver_layer.crm_sales_details sd
LEFT JOIN gold_layer.dim_products pr ON sd.sls_prod_key = pr.product_code
LEFT JOIN gold_layer.dim_customers cu ON sd.sls_cust_id = cu.customer_id

