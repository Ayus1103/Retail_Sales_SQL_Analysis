-- CREATING DATABASE
CREATE DATABASE retail_store;

-- CREATING TABLE
CREATE TABLE retail (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale float
);

SELECT 
    COUNT(*)
FROM
    retail;


-- CHAECKING FOR NULL VALUES
SELECT 
    *
FROM
    retail
WHERE
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
	OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- DELETING  NULL VALUES
DELETE
FROM
    retail
WHERE
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
	OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

SELECT * FROM retail;
    
-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE
SELECT 
    COUNT(*) AS total_sales
FROM
    retail;
    
-- HOW MANY UNIQUE CUSTOMERS DO WE HAVE
SELECT 
    COUNT(DISTINCT customer_id)
FROM
    retail;
    
-- HOW MANY UNIQUE NO OF CATEGORY DO WE HAVE
SELECT 
    COUNT(DISTINCT category)
FROM
    retail;
    
-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS & ANSWERS
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    retail
WHERE
    sale_date = '2022-11-05';
    
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
    *
FROM
    retail
WHERE
    category = 'Clothing' AND quantiy >= 4
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
        
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS net_sales
FROM
    retail
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    category, AVG(age) AS avg_age
FROM
    retail
WHERE
    category = 'Beauty';
    
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail
WHERE
    total_sale > 1000;
    
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    COUNT(transactions_id), category, gender
FROM
    retail
GROUP BY gender , category
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year,month, avg_sales FROM (
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(AVG(total_sale),1) AS avg_sales,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY  ROUND(AVG(total_sale),1) DESC) AS rankk
FROM
    retail
GROUP BY 1 , 2
ORDER BY 1 ,3 DESC
) as t1
WHERE rankk=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    COUNT(DISTINCT customer_id) AS cnt_unique_cs, category
FROM
    retail
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales AS (
SELECT * ,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift
FROM retail
)
SELECT 
    shift, COUNT(*) AS total_order
FROM
    hourly_sales
GROUP BY shift

-- END OF PROJECT