-- Sales by year
SELECT EXTRACT(YEAR FROM order_date) AS year,
		ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM orders
GROUP BY year
ORDER BY year ASC
;

-- Sales by quarter
SELECT EXTRACT(YEAR FROM order_date) AS year,
		EXTRACT(QUARTER FROM order_date) AS quarter,
		ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM orders
GROUP BY year, quarter
ORDER BY year, quarter ASC
;

-- Sales by day of week
SELECT TRIM(TO_CHAR(order_date, 'Day')) AS day_of_week,
		ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM orders
GROUP BY EXTRACT(DOW FROM order_date),
    	TRIM(TO_CHAR(order_date, 'Day'))
ORDER BY EXTRACT(DOW FROM order_date)
;

-- Best Month of Each Year
WITH monthly_sales AS (
	SELECT EXTRACT(YEAR FROM order_date) AS year,
			EXTRACT(MONTH FROM order_date) AS month,
			TRIM(TO_CHAR(order_date,'Month')) AS month_name,
			ROUND(SUM(sales)::numeric, 2) AS total_sales
	FROM orders
	GROUP BY year, month, month_name
),

ranked_months AS (
	SELECT *,
			ROW_NUMBER() OVER(
				PARTITION BY year
				ORDER BY total_sales DESC
			) AS rn
	FROM monthly_sales
)

SELECT year,
		month,
		month_name,
		total_sales
FROM ranked_months
WHERE rn = 1
;

-- Average Sales by Calendar Month
WITH monthly_sales AS (
	SELECT EXTRACT(MONTH FROM order_date) AS month,
			EXTRACT(YEAR FROM order_date) AS year,
			ROUND(SUM(sales)::numeric, 2) AS total_sales
	FROM orders
	GROUP BY year, month
)

SELECT month,
		AVG(total_sales) AS avg_monthly_sales
FROM monthly_sales
GROUP BY month
ORDER BY month ASC
;

-- Year-over-Year Sales Comparison
WITH yearly_sales AS (
	SELECT EXTRACT(YEAR FROM order_date) AS year,
			ROUND(SUM(sales)::numeric, 2) AS total_sales
	FROM orders
	GROUP BY year
)

SELECT year,
		total_sales,
		ROUND(LAG(total_sales) OVER(ORDER BY year)::numeric, 2) 
			AS previuos_year_sales,
		ROUND(total_sales - LAG(total_sales) OVER(ORDER BY year)::numeric, 2) 
			AS sales_diff,
		ROUND((total_sales - LAG(total_sales) OVER(ORDER BY year))
			/ LAG(total_sales) OVER(ORDER BY year) * 100::numeric, 2)
			AS growth_percent
FROM yearly_sales
ORDER BY year
;