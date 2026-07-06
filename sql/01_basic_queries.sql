-- Total number of orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders
;

-- Total number of customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM orders
;

-- Total number of products sold (unique)
SELECT COUNT(DISTINCT product_id) AS total_products
FROM orders
;

-- Average, minimum, and maximum sales
SELECT MIN(sales) AS min_sales,
	   MAX(sales) AS max_sales,
	   ROUND(AVG(sales)::numeric, 2) AS avg_sales
FROM orders
;

-- Number of orders by segment
SELECT segment,
	   COUNT(DISTINCT order_id) AS number_of_orders
FROM orders
GROUP BY segment
ORDER BY number_of_orders DESC;
;

-- Number of products in each category
SELECT category,
	   COUNT(DISTINCT product_id) AS number_of_products
FROM orders
GROUP BY category
ORDER BY number_of_products DESC;
;