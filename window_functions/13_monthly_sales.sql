WITH order_history AS (
 SELECT
  f.customer_id,
  f.order_date,
  f.order_amount,

  ROW_NUMBER() OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date DESC) AS rn,

  LAG(f.order_amount) OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date) AS prev_order_amount
 
FROM
  fact_orders AS f),

base AS (
 SELECT
  *,
  order_amount - prev_order_amount AS diff
 FROM
  order_history)

SELECT
 customer_id,
 order_date AS latest_order_date,
 order_amount AS latest_order_amount,
 prev_order_amount,
 diff,
 
 CASE WHEN diff IS NULL THEN 'FIRST_ORDER'
  WHEN diff > 0 THEN 'UP' ELSE 'DOWN'
  END AS sales_status

FROM
 base
WHERE
 rn = 1
;
