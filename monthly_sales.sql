WITH monthly_sales AS (
 SELECT
  DATE_TRUNC(f.order_date, MONTH) AS order_month,
  SUM(f.order_amount) AS monthly_sales
 FROM
  fact_orders AS f
 GROUP BY
  DATE_TRUNC(f.order_date, MONTH)),

monthly_history AS (
 SELECT
  m.order_month,
  m.monthly_sales,
  LAG(m.monthly_sales) OVER(
  ORDER BY m.order_month) AS prev_month_sales
 FROM
  monthly_sales AS m),

kpi_data AS (
 SELECT
  h.order_month,
  h.monthly_sales,
  h.prev_month_sales,
  
  h.monthly_sales - h.prev_month_sales AS diff,

  ROUND((h.monthly_sales /
  SUM(h.monthly_sales) OVER()) * 100,1
  ) AS sales_ratio

 FROM
  monthly_history AS h)

SELECT
 order_month,
 monthly_sales,
 prev_month_sales,
 diff,
 sales_ratio,

 CASE
  WHEN prev_month_sales IS NULL THEN 'FIRST_MONTH'
  WHEN diff > 0 THEN 'UP' ELSE 'DOWN'
  END AS sales_status

FROM
 kpi_data
;
