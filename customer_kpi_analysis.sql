WITH rnk AS(
 SELECT
  *,
  ROW_NUMBER() OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date DESC) AS rn,

  LAG(f.order_amount) OVER(
  PARTITION BY f.cusomer_id
  ORDER BY f.order_date) AS prev_order_amount

 FROM
  fact_orders AS f),

diff_data AS(
 SELECT
  r.cusomer_id,
  r.order_date,
  r.order_amoun,
  r.prev_order_amount,
  r.rn,
  
  r.order_amoun - r.prev_order_amount AS diff

 FROM
  rnk AS r),

new_data AS(
 SELECT
  d.cusomer_id,
  d.order_date AS latest_order_date,
  d.order_amount AS latest_order_amount,
  d.prev_order_amount,
  d.diff
 FROM
  diff_data AS d
 WHEREnew_order
  d.rn = 1),
  
customer_data AS(
 SELECT
  f.customer_id,
  SUM(f.order_amount) AS cumulative_revenue,
  MIN(f.order_date) AS first_order_date,
  COUNT(*) AS order_count
 FROM
  fact_orders AS f
 GROUP BY
  f.customer_id)

SELECT
 n.cusomer_id,
 n.latest_order_date,
 n.latest_order_amount,
 n.prev_order_amount,
 n.diff,
 c.cumulative_revenue,
 c.first_order_date,
 c.order_count,

 CASE WHEN n.prev_order_amount IS NULL THEN 'NEW_CUSTOMER'
      WHEN diff > 0 THEN 'GROWING' ELSE 'DECLINING'
      END AS customer_status

FROM
 new_data AS n
LEFT JOIN
 customer_data AS c
ON
 n.cusomer_id = c.cusomer_id
;
