SELECT
 SUM(f.order_amount) AS  total_sales,
 COUNT(*) AS order_count,
 AVG(f.order_amount) AS avg_order_amount,
 d.region
FROM
 fact_orders AS f
LEFT JOIN
 dim_customers AS d
ON
 f.customer_id = d.customer_id
WHERE EXISTS(
 SELECT 1
 FROM
  fact_orders AS a
 WHERE
  f.customer_id = a.customer_id
 AND
  a.category = 'Food')
AND EXISTS(
 SELECT 1
 FROM
  fact_orders AS b
 WHERE
  f.customer_id = b.customer_id
 AND
  b.category = 'Drink')
GROUP BY
 f.customer_id,
 d.region
;
