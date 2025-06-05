# Retail Store Sales Analysis 📊  

## Overview  
This project focuses on analyzing retail store transactions to derive **insights into customer behavior, sales patterns, and key business metrics**. The dataset consists of structured **sales transaction details**, including **customer demographics, product categories, and financial metrics**.

**Project Objectives** 📌  

✅ Ensure data accuracy and integrity by structuring a clean retail database.  
✅ Analyze total sales, unique customers, and product categories.  
✅ Identify customer purchasing patterns and top spenders.  
✅ Track sales trends, seasonal performance, and peak shopping hours.  
✅ Solve key business questions to optimize inventory and strategy decisions.  


## Database & Table Structure  
### **Database Creation**  
```sql
CREATE DATABASE retail_store;
```
### **Table Definition**  
```sql
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
    total_sale FLOAT
);
```

## Data Cleaning 🛠  
To ensure **data integrity**, null values are identified and removed:  
```sql
SELECT * FROM retail WHERE transactions_id IS NULL 
    OR sale_date IS NULL OR sale_time IS NULL 
    OR customer_id IS NULL OR gender IS NULL 
    OR age IS NULL OR category IS NULL 
    OR quantiy IS NULL OR price_per_unit IS NULL 
    OR cogs IS NULL OR total_sale IS NULL;
```
```sql
DELETE FROM retail WHERE transactions_id IS NULL 
    OR sale_date IS NULL OR sale_time IS NULL 
    OR customer_id IS NULL OR gender IS NULL 
    OR age IS NULL OR category IS NULL 
    OR quantiy IS NULL OR price_per_unit IS NULL 
    OR cogs IS NULL OR total_sale IS NULL;
```

## Exploratory Analysis 🔍  
### **Basic Metrics**  
- **Total Sales Transactions**  
```sql
SELECT COUNT(*) AS total_sales FROM retail;
```
- **Unique Customers**  
```sql
SELECT COUNT(DISTINCT customer_id) FROM retail;
```
- **Unique Product Categories**  
```sql
SELECT COUNT(DISTINCT category) FROM retail;
```

## Business Insights & Key Queries 💡  
### **1️⃣ Find all sales made on a specific date**  
```sql
SELECT * FROM retail WHERE sale_date = '2022-11-05';
```
### **2️⃣ Identify Clothing transactions with quantity ≥ 4 in Nov-2022**  
```sql
SELECT * FROM retail 
WHERE category = 'Clothing' AND quantiy >= 4 
    AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```
### **3️⃣ Total Sales per Product Category**  
```sql
SELECT category, SUM(total_sale) AS net_sales FROM retail GROUP BY category;
```
### **4️⃣ Average Age of Customers Purchasing from Beauty Category**  
```sql
SELECT category, AVG(age) AS avg_age FROM retail WHERE category = 'Beauty';
```
### **5️⃣ Transactions where Total Sales > 1000**  
```sql
SELECT * FROM retail WHERE total_sale > 1000;
```
### **6️⃣ Number of Transactions per Gender & Category**  
```sql
SELECT COUNT(transactions_id), category, gender FROM retail 
GROUP BY gender, category ORDER BY 1;
```
### **7️⃣ Best Selling Month Each Year**  
```sql
SELECT year, month, avg_sales FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           ROUND(AVG(total_sale),1) AS avg_sales,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) 
                        ORDER BY ROUND(AVG(total_sale),1) DESC) AS rankk 
    FROM retail 
    GROUP BY 1, 2 
    ORDER BY 1, 3 DESC
) as t1 WHERE rankk=1;
```
### **8️⃣ Top 5 Customers Based on Total Sales**  
```sql
SELECT customer_id, SUM(total_sale) AS total_sales FROM retail 
GROUP BY customer_id ORDER BY total_sales DESC LIMIT 5;
```
### **9️⃣ Unique Customers per Category**  
```sql
SELECT COUNT(DISTINCT customer_id) AS cnt_unique_cs, category FROM retail GROUP BY category;
```
### **🔟 Shift-wise Orders Distribution**  
```sql
WITH hourly_sales AS (
    SELECT *, CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
    FROM retail
) SELECT shift, COUNT(*) AS total_order FROM hourly_sales GROUP BY shift;
```

## Conclusion 🏆  
This analysis enables **data-driven decision-making for the retail business**, highlighting:  
✔️ Peak sales periods  
✔️ Top customers  
✔️ Gender & category-based sales trends  
✔️ Business opportunities for targeted marketing & inventory management  
