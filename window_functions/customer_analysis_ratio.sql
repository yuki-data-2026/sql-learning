WITH customer_summary AS(
 SELECT
  f.customer_id,
  SUM(f.order_amount) AS total_sales,
  COUNT(*) AS order_count,
  AVG(f.order_amount) AS avg_order_amount,

  SUM(CASE WHEN f.category = 'food'
   THEN f.order_amount ELSE 0 END) AS food_sales,

  SUM(CASE WHEN f.category = 'drink'
   THEN f.order_amount ELSE 0 END) AS drink_sales
 
 FROM
  fact_orders AS f
 GROUP BY
  f.customer_id),

 rnk AS(
  SELECT
   f.customer_id,
   f.order_date,
   f.order_amount,
  
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
   r.rn = 1)

SELECT
 c.customer_id,
 c.total_sales,
 c.order_count,
 c.avg_order_amount,
 c.food_sales,
 c.drink_sales,
 n.latest_order_date,
 n.latest_order_amount,

 ROUND(c.total_sales / SUM(c.total_sales) OVER
  () , 2) AS sales_ratio,

 DENSE_RANK() OVER(
  ORDER BY c.total_salse DESC) AS customer_rank,

 CASE WHEN c.food_sales = c.drink_sales THEN 'SAME'
      WHEN c.food_sales > c.drink_sales THEN 'FOOD'
      ELSE 'DRINK' END AS favorite_category

FROM
 customer_summary AS c
LEFT JOIN
 new_order AS n
ON
 c.customer_id = n.customer_id
;
