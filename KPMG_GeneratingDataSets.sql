-- Customer Demographic ///////////////////////////////////////////////

SELECT DISTINCT gender
FROM [dbo].[KPMG_CustomerDemographic];

UPDATE [dbo].[KPMG_CustomerDemographic]
SET gender='Female'
WHERE gender IN ('F', 'Femal');

UPDATE [dbo].[KPMG_CustomerDemographic]
SET gender='Male'
WHERE gender IN ('M');

SELECT [first_name]
FROM [dbo].[KPMG_CustomerDemographic]
WHERE gender='U';


SELECT [customer_id], [first_name], [gender], [past_3_years_bike_related_purchases], [wealth_segment], [owns_car],
    CASE WHEN DATEDIFF(year, DOB, GETDATE())<20 THEN 'below 20'
        WHEN 20<=DATEDIFF(year, DOB, GETDATE()) AND DATEDIFF(year, DOB, GETDATE())<30 THEN '20+'
        WHEN 30<=DATEDIFF(year, DOB, GETDATE()) AND DATEDIFF(year, DOB, GETDATE())<40 THEN '30+'
        WHEN 40<=DATEDIFF(year, DOB, GETDATE()) AND DATEDIFF(year, DOB, GETDATE())<50 THEN '40+'
        WHEN 50<=DATEDIFF(year, DOB, GETDATE()) AND DATEDIFF(year, DOB, GETDATE())<60 THEN '50+'
        WHEN 60<=DATEDIFF(year, DOB, GETDATE()) AND DATEDIFF(year, DOB, GETDATE())<70 THEN '60+'
        WHEN 70<=DATEDIFF(year, DOB, GETDATE()) AND DATEDIFF(year, DOB, GETDATE())<80 THEN '70+'
        ELSE '80+'
        END AS age_range
FROM [dbo].[KPMG_CustomerDemographic]
WHERE gender='Male'; 

SELECT COUNT(DISTINCT(customer_id))
FROM [dbo].[KPMG_CustomerDemographic];

-- Customer Address ///////////////////////////////////////////////

UPDATE [dbo].[KPMG_CustomerAddress]
SET state='Victoria'
WHERE state='VIC';

UPDATE [dbo].[KPMG_CustomerAddress]
SET state='New South Wales'
WHERE state='NSW';

UPDATE [dbo].[KPMG_CustomerAddress]
SET state='Queensland'
WHERE state='QLD';

SELECT DISTINCT state
FROM [dbo].[KPMG_CustomerAddress];


SELECT [customer_id], [address], [postcode], [state], [country], [property_valuation]
FROM [dbo].[KPMG_CustomerAddress]


-- Product detail /////////////////////////////////////////////// 
SELECT TOP 10 brand,
    CONCAT(brand,': ', product_line, ' (class: ', product_class, ')') AS Product_Detail,
    COUNT(*) AS Product_Sold
FROM [dbo].[KPMG_transactions]
GROUP BY [brand], [product_line], [product_class]
ORDER BY Product_Sold DESC;


-- Current Customer /////////////////////////////////////////////// 
SELECT t.customer_id, 
    CASE WHEN t.sum_profit>=9000 THEN '1st grade'
        WHEN 8000<=t.sum_profit AND t.sum_profit<9000 THEN '2nd grade'
        WHEN 7000<=t.sum_profit AND t.sum_profit<8000 THEN '3rd grade'
        WHEN 6000<=t.sum_profit AND t.sum_profit<7000 THEN '4th grade'
        WHEN 5000<=t.sum_profit AND t.sum_profit<6000 THEN '5th grade'
        WHEN 4000<=t.sum_profit AND t.sum_profit<5000 THEN '6th grade'
        WHEN 3000<=t.sum_profit AND t.sum_profit<4000 THEN '7th grade'
        WHEN 2000<=t.sum_profit AND t.sum_profit<3000 THEN '8th grade'
        WHEN 1000<=t.sum_profit AND t.sum_profit<2000 THEN '9th grade'
        ELSE '10th grade'
    END AS 'Current_Customer_Grade',
    t.no_of_transactions, t.sum_profit, t.sum_purchase, t.average_purchase, 
    d.owns_car, d.wealth_segment, d.past_3_years_bike_related_purchases, a.property_valuation,
    DATEDIFF(year, d.DOB, GETDATE()) AS age,
    d.[first_name], d.[last_name], a.[address], a.[postcode], a.[state], a.[country]
-- INTO dbo.current_customers
FROM
(SELECT customer_id, COUNT([transaction_id]) AS no_of_transactions, 
    ROUND(SUM(cast(list_price AS numeric)),2) AS sum_purchase, 
    ROUND(SUM(cast(list_price AS numeric))-SUM(convert(money, standard_cost)), 2) AS sum_profit,
    ROUND(AVG(cast(list_price AS numeric)), 0) AS average_purchase
FROM [dbo].[KPMG_transactions]
GROUP BY customer_id) AS t 
JOIN [dbo].[KPMG_CustomerDemographic] d 
ON t.customer_id=d.customer_id
JOIN [dbo].[KPMG_CustomerAddress] a
ON d.customer_id=a.customer_id
ORDER BY t.sum_profit DESC, t.sum_purchase DESC;

-- Regrade Current Customer with Labels /////////////////////////////////////////////// 
SELECT [label], [Current_Customer_Grade], COUNT(*) as num
FROM [dbo].[regrade_current_customer_with_labels]
GROUP BY [label], [Current_Customer_Grade]
ORDER BY [label], num DESC;


-- Create Final Combined Customer with Grades /////////////////////////////////////////////// 

SELECT r.[Current_Customer_Grade], d.[first_name], d.[last_name], d.[job_title], r.[address], r.[postcode], r.[state], r.[country]
INTO dbo.final_current
FROM [dbo].[re-grade] r JOIN [dbo].[KPMG_CustomerDemographic] d
ON r.customer_id=d.customer_id

ALTER TABLE dbo.final_current
ADD type nvarchar(50);

UPDATE dbo.final_current
SET type='Current';

SELECT * FROM [dbo].[final_current]
UNION ALL 
SELECT * FROM [dbo].[final_target]
ORDER BY Current_Customer_Grade;


