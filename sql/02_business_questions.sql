-- Top 10 customers by sales
SELECT customer_id,
	   customer_name,
	   SUM(sales) AS sum_sales
FROM orders
GROUP BY customer_id, customer_name
ORDER BY sum_sales DESC
LIMIT 10
;

-- Top 10 cities by number of orders
SELECT city,
	   COUNT(DISTINCT order_id) AS number_of_orders
FROM orders
GROUP BY city
ORDER BY number_of_orders DESC
LIMIT 10
;

-- Category with the highest average order value
WITH order_totals AS (
	SELECT order_id,
		   category,
		   SUM(sales) AS order_total
	FROM orders
	GROUP BY order_id, category
)

SELECT category,
	   ROUND(AVG(order_total)::numeric, 2) AS avg_order_value
FROM order_totals
GROUP BY category
ORDER BY avg_order_value DESC
LIMIT 1
;

-- Most profitable region
SELECT region,
	   SUM(sales) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC
LIMIT 1
;

-- Best-selling subcategory in each region
WITH subcategory_sales AS (
	SELECT region,
		   sub_category,
		   SUM(sales) AS total_sales
	FROM orders
	GROUP BY region, sub_category
),

ranked_subcategories AS (
	SELECT *,
		   ROW_NUMBER() OVER (
		   	   PARTITION BY region
		   	   ORDER BY total_sales DESC
		   ) AS rn
	FROM subcategory_sales
)

SELECT region,
	   sub_category,
	   total_sales
FROM ranked_subcategories
WHERE rn = 1
;

-- Share of each category in total sales volume
SELECT category,
	   SUM(sales) AS total_sales,
	   ROUND((SUM(sales)*100.0 / SUM(SUM(sales)) OVER())::numeric, 2) 
			AS sales_share_percent
FROM orders
GROUP BY category
ORDER BY total_sales DESC
;

-- Contribution of each segment to total revenue
SELECT segment,
	   SUM(sales) AS total_sales,
	   ROUND((SUM(sales)*100.0 / SUM(SUM(sales)) OVER())::numeric, 2)
		AS revenue_share_percent
FROM orders
GROUP BY segment
ORDER BY total_sales DESC
;