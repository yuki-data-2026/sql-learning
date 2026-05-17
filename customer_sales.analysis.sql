WITH base AS(
 SELECT
  *,
  ROW_NUMBER() OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date DESC) AS rn,

  LAG(f.order_amount) OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date) AS prev_order_amount

 FROM
  fact_orders AS f),

new_order AS(
 SELECT
  b.customer_id,
  b.order_date AS latest_order_date,
  b.order_amount AS latest_order_amount,
  b.prev_order_amount
 FROM
  base AS b
 WHERE
  b.rn = 1),

diff_amount AS(
 SELECT
  *,
  n.latest_order_amount - n.prev_order_amount AS diff
 FROM
  new_order AS n),

customer_data AS(
 SELECT
  f.customer_id,
  SUM(f.order_amount) AS cumulative_revenue,
  COUNT(*) AS order_count 
 FROM
  fact_orders AS f
 GROUP BY
  f.customer_id)

SELECT
 d.customer_id,
 d.latest_order_date,
 d.latest_order_amount,
 d.prev_order_amount,
 d.diff,
 c.cumulative_revenue,
 c.order_count,

 CASE WHEN d.diff IS NULL THEN 'FIRST_ORDER'
  WHEN d.diff > 0 THEN 'UP'
  ELSE 'DOWN' END AS sales_status

FROM
 diff_amount AS d
LEFT JOIN
 customer_data AS c
ON
 d.customer_id = c.customer_id
;
 
