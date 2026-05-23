WITH rnk AS(
 SELECT
  f.customer_id,
  f.order_date,
  f.order_amount,
 
  SUM(f.order_amount)OVER(
   PARTITION BY f.customer_id) AS total_sales,

  ROW_NUMBER()OVER(
   PARTITION BY f.customer_id
    ORDER BY f.order_date DESC) AS rn

 FROM
  fact_orders AS f),

 new_order AS(
  SELECT
   r.customer_id,
   r.total_sales,
   r.order_date AS latest_order_date,
   r.amount AS latest_order_amount
  FROM
   rnk AS r
  WHERE
   r.rn = 1),

customer_summery AS(
 SELECT
  f.customer_id,
  SUM(CASE WHEN f.category = 'food' THEN f.order_aomount
   ELSE 0 END) AS food_sales,

  SUM(CASE WHEN f.category = 'drink' THEN f.order_amount
   ELSE 0 END) AS drink_sales

 FROM
  fact_orders AS f
 GROUP BY 
  f.customer_id)

SELECT
 n.customer_id,
 n.total_sales,
 n.latest_order_date,
 n.latest_order_amount,
 c.food_sales,
 c.drink_sales,

 ROUND(c.food_sales /  n.total_sales ,2) AS food_ratio,

 DENSE_RANK()OVER(
  ORDER BY n.total_sales DESC) AS customer_rank

FROM
 new_order AS n
LEFT JOIN
 customer_summery AS c
ON
 n.customer_id = c.customer_id
;
