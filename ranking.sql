WITH customer_sales AS (
 SELECT
  f.customer_id,
  SUM(f.order_amount) AS cumulative_revenue,
  COUNT(*) AS order_count,
  AVG(f.order_amount) AS avg_order_amount
 FROM
  fact_orders AS f
 GROUP BY
  f.customer_id),

sales_rank AS (
 SELECT
  *,
  DENSE_RANK() OVER(
  ORDER BY cumulative_revenue
  DESC) AS sales_rank
 FROM
  customer_sales)

SELECT
 s.customer_id,
 d.customer_name,
 s.cumulative_revenue,
 s.order_count,
 s.avg_order_amount,
 s.sales_rank,

 CASE WHEN s.sales_rank = 1
 THEN 'TOP' ELSE 'NORMAL'
 END AS customer_status

FROM
 sales_rank AS s
LEFT JOIN
 dim_customers AS d
ON
 s.customer_id = d.customer_id
;
