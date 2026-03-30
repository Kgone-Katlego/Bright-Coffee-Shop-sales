----------------------------------------------------------------------------------------
--- Checking all the columns in the table ----
select * from `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1` limit 100;
----------------------------------------------------------------------------------------
--- Counting the number of rows in the table ---
SELECT COUNT(*) 
FROM `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`;
----------------------------------------------------------------------------------------
--------- Checking the different stores we have -------------

SELECT DISTINCT store_location 
FROM `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`;
----------------------------------------------------------------------------------------
------ Checking Product sold at our stores
SELECT DISTINCT product_category 
FROM `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`;
----------------------------------------------------------------------------------------
------ Checking the type of products we have in our stores -- we have 29 types of product
SELECT DISTINCT product_type 
FROM `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`;
----------------------------------------------------------------------------------------
------ Checking for null in various columns in our data -----
SELECT *
FROM `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`
WHERE unit_price is NULL;
----------------------------------------------------------------------------------------
-------- check when did they start collecting data and when last did theycollect data---
SELECT  MIN(transaction_date) AS Start_date,
         MAX(transaction_date) AS Last_date
FROM  `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`;  

----------------------------------------------------------------------------------------
--- check the the time for the first transaction and the last transaction 
SELECT MIN(transaction_time) AS open_time,
       MAX(transaction_time) AS close_time
FROM  `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`; 
-----------------------------------------------------------------------------------------
----- Calculate Revenue -----------------------------------------------------------------
SELECT store_location, 
      transaction_qty,
       unit_price,
      transaction_qty*unit_price AS Revenue
FROM  `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`;

-----------------------------------------------------------------------------------------
-------  checking the name of the day and the month name from the transaction date ------
SELECT transaction_date,
Dayname(transaction_date) As Dayname ,
       Monthname(transaction_date) AS Month_name
FROM  `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`;  
-----------------------------------------------------------------------------------------
--- Combining functions -----------------------------------------------------------------

SELECT 
       transaction_date,
         --- add columns to enhance our data set , add it close to the transaction date 
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Month_name,
       Dayofmonth(transaction_date) AS Day_of_Month,

  --------------------------------------------------------------------------------------------------------------     
       --- when do we make more sales , weekend or weekdays---
CASE 
 WHEN Dayname(transaction_date) IN('Sat','Sun') THEN'Weekend'
ELSE 'Weekday' 
END AS Day_Classification,
-----------------------------------------------------------------------------------------------------------------
       transaction_time,
       date_format(transaction_time,'HH:mm:ss') AS Purchase_time,
-----------------------------------------------------------------------------------------------------------------       
    --- case statement  time buckets , what time is the most sales---
CASE 
 WHEN date_format(transaction_time,'HH:mm:ss')BETWEEN '06:00:00' AND '07:30:59'  THEN'01 Early Commuter Start'
 WHEN date_format(transaction_time,'HH:mm:ss')BETWEEN '07:31:00' AND '10:00:59'  THEN'02 Morning Peak'
 WHEN date_format(transaction_time,'HH:mm:ss')BETWEEN '10:01:00' AND '11:30:59'  THEN'03 Mid Morning Steady'
 WHEN date_format(transaction_time,'HH:mm:ss')BETWEEN '11:31:00' AND '13:30:59'  THEN'04 Lunch Peak'
 WHEN date_format(transaction_time,'HH:mm:ss')BETWEEN '13:31:00' AND '15:30:59'  THEN'05 Post  Lunch Dip'
 WHEN date_format(transaction_time,'HH:mm:ss')BETWEEN '15:31:00' AND '17:30:59'  THEN'06 Afternoon Pck me Up'
 WHEN date_format(transaction_time,'HH:mm:ss')BETWEEN '17:31:00' AND '19:00:59'  THEN'07 Evening'
END AS Time_Classification ,
----------------------------------------------------------------------------------------------------------------
       SUM(transaction_qty) AS Number_of_quantity,
       COUNT(DISTINCT transaction_id) AS Number_of_sales,
       COUNT (DISTINCT product_id) AS number_of_products,
       COUNT(DISTINCT store_id ) AS number_of_stores,
       store_location, 
       product_category,
       product_type,
       product_detail,
 ------------------------------------------------------------------------------------------------------------      
--- Revenue column ----

SUM(transaction_qty*unit_price) AS  Revenue,

--------------------------------------------------------------------------------------------------------------
------ Spend Buckets --
CASE 
 WHEN SUM(transaction_qty*unit_price) <= 50 THEN'01 Low Spender'
 WHEN SUM(transaction_qty*unit_price) BETWEEN 51 AND 99.99 THEN'02 Lower-Mid Spender'
 WHEN SUM(transaction_qty*unit_price) BETWEEN 100.0 AND 169.99 THEN'03 Medium Spender '
 WHEN SUM(transaction_qty*unit_price) BETWEEN 170.00 AND 249.99 THEN'04 Upper-Mid Spender'
ELSE '05 Higher Spender' 
END AS Spend_buckets 
-----------------------------------------------------------------------------------------------------------------

FROM  `coffee`.`default`.`bright_coffee_shop_analysis_case_study_1`
GROUP BY  transaction_date,
          Dayname(transaction_date),
          Monthname(transaction_date),
          Dayofmonth(transaction_date),
          Time_Classification,
          Day_Classification,
          transaction_time,
          product_category,
          product_type,
          Store_location,
          product_detail;
