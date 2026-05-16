WITH order_history AS (
 SELECT
  f.customer_id,
  f.order_date,
  f.order_amount,
  SUM(f.order_amount) OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date) AS cumulative_revenue,

  ROW_NUMBER() OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date DESC) AS rn

 FROM
  fact_orders AS f ),

new_order AS (
 SELECT
  o.customer_id,
  o.order_date AS latest_order_date,
  o.order_amount AS latest_order_amount,
  o.cumulative_revenue
FROM
 order_history AS o
 WHERE
 o.rn = 1 ),

count_data AS (
 SELECT
  f.customer_id,
  COUNT(*) AS order_count
FROM
 fact_orders AS f
GROUP BY
 f.customer_id)

SELECT
 n.customer_id,
 n.latest_order_date,
 n.latest_order_amount,
 n.cumulative_revenue,
 c.order_count,

 CASE WHEN n.cumulative_revenue >= 1000
 THEN 'VIP' ELSE 'NORMAL' END AS customer_status

FROM 
　new_order AS n
LEFT JOIN 
　count_data AS c
ON
　 n.customer_id = c.customer_id
;
