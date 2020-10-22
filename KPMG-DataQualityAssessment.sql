/* Column Distribution Analysis */
SELECT count(DISTINCT(customer_id))
FROM dbo.KPMG_transaction;

SELECT transaction_date 
FROM dbo.KPMG_transaction
ORDER BY transaction_date;

SELECT online_order, count(*) as frequency
FROM dbo.KPMG_transaction
GROUP BY online_order;

SELECT order_status, count(*) as frequency
FROM dbo.KPMG_transaction
GROUP BY order_status;

SELECT brand, count(*) as frequency
FROM dbo.KPMG_transaction
GROUP BY brand;

SELECT product_line, count(*) as frequency
FROM dbo.KPMG_transaction
GROUP BY product_line;

SELECT product_class, count(*) as frequency
FROM dbo.KPMG_transaction
GROUP BY product_class;

SELECT product_size, count(*) as frequency
FROM dbo.KPMG_transaction
GROUP BY product_size;

SELECT MIN(list_price) as min_listPrice, MAX(list_price) as max_listPrice, 
     MIN(convert(money,standard_cost)) as min_standardCost, MAX(convert(money,standard_cost)) as max_standardCost
FROM dbo.KPMG_transaction;

-- values in product_first_date_sold column are meaningless


SELECT count(DISTINCT(customer_id))
FROM dbo.KPMG_CustomerDemographic;

SELECT gender, COUNT(*)
FROM dbo.KPMG_CustomerDemographic
GROUP BY gender;

-- gender column is not formatted 

SELECT MIN(past_3_years_bike_related_purchases) as min_purchase, MAX(past_3_years_bike_related_purchases) as max_purchase,
    MIN(tenure) as min_tenure, MAX(tenure) as max_tenure
FROM dbo.KPMG_CustomerDemographic;

SELECT customer_id, DOB, DATEDIFF(year, DOB, GETDATE()) as age
FROM dbo.KPMG_CustomerDemographic
ORDER BY age DESC;

-- the customer with id=34 was born in 1843 which does not seem logical

SELECT job_industry_category, COUNT(*) as sum_of_category
FROM dbo.KPMG_CustomerDemographic
GROUP BY job_industry_category;

SELECT wealth_segment, COUNT(*) as sum_of_wealth_segment
FROM dbo.KPMG_CustomerDemographic
GROUP BY wealth_segment;

SELECT deceased_indicator, COUNT(*) as sum_of_deceased_indicator
FROM dbo.KPMG_CustomerDemographic
GROUP BY deceased_indicator;

SELECT owns_car, COUNT(*) as sum_of_owns_car
FROM dbo.KPMG_CustomerDemographic
GROUP BY owns_car;


SELECT count(DISTINCT(customer_id))
FROM dbo.KPMG_Customeraddress;

SELECT state, COUNT(*) as sum_of_state
FROM dbo.KPMG_Customeraddress
GROUP BY state;

-- state values are not consistant

/* Distinct customer_id Analysis */
SELECT a.*
FROM KPMG_CustomerDemographic d RIGHT JOIN KPMG_Customeraddress a
ON d.customer_id=a.customer_id
WHERE d.customer_id is NULL;

-- “customer address” table has three more (4001 4002 4003)

SELECT t.*
FROM KPMG_transaction t LEFT JOIN KPMG_Customeraddress a
ON t.customer_id=a.customer_id
WHERE a.customer_id is NULL;