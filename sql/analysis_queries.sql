## which region makes most profit 

SELECT 
    region,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales)*100)::numeric, 2) AS profit_margin_pct
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;


## monthly sales trend

SELECT 
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(sales)::numeric, 2) AS monthly_sales
FROM superstore
GROUP BY month
ORDER BY month;


## top 10 products by profit 
SELECT 
    product_name,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

## window function top 1 in each region
SELECT 
    region,
    category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
FROM superstore
GROUP BY region, category;


## Discount Impact on Profit using CTE
WITH discount_buckets AS (
    SELECT *,
        CASE 
            WHEN discount = 0 THEN 'No Discount'
            WHEN discount <= 0.2 THEN 'Low Discount'
            WHEN discount <= 0.4 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_level
    FROM superstore
)
SELECT 
    discount_level,
    ROUND(AVG(profit)::numeric, 2) AS avg_profit,
    COUNT(*) AS num_orders
FROM discount_buckets
GROUP BY discount_level
ORDER BY avg_profit DESC;