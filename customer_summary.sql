WITH rnk AS(
 SELECT
  *,
  ROW_NUMBER() OVER(
  PARTITION BY f.customer_id
  ORDER BY f.order_date DESC) AS rn
 FROM
  fact_orders AS f),

 new_order AS(
  SELECT
   r.customer_id,
   r.order_date AS latest_order_date,
   r.order_amount AS latest_order_amount
  FROM
   rnk AS r
  WHERE
   r.rn = 1),

order_history AS(
  SELECT
   f.customer_id,
   SUM(f.order_amount) AS cumulative_revenue,
   COUNT(*) AS order_count,
   AVG(f.order_amount) AS avg_order_amount
  FROM
   fact_orders AS f
  GROUP BY
   f.customer_id)

SELECT
 n.customer_id,
 n.latest_order_date,
 n.latest_order_amount,
 o.cumulative_revenue,
 o.order_count,
 o.avg_order_amount,

 CASE WHEN o.avg_order_amount >= 300
  THEN 'HIGH_VALUE' ELSE 'NORMAL'
  END AS customer_type 

FROM
 new_order AS n
JOIN
 order_history AS o
ON
 n.customer_id = o.customer_id
;
