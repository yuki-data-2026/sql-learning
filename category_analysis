WITH customer_summary AS(
 SELECT
  f.customer_id,
  SUM(f.order_amount) AS total_sales,
  AVG(f.order_amount) AS avg_order_amount,

  SUM(CASE WHEN f.category = 'food'
   THEN f.order_amount ELSE 0 END) AS food_sales,

  SUM(CASE WHEN f.category = 'drink'
   THEN f.order_amount ELSE 0 END) AS drink_sales,

  SUM(CASE WHEN f.category = 'food'
   THEN 1 ELSE 0 END) AS food_order_count,

  SUM(CASE WHEN f.category = 'drink'
   THEN 1 ELSE 0 END) AS drink_order_count

 FROM
  fact_orders AS f
 GROUP BY
  f.customer_id)

SELECT
 customer_id,
 total_sales,
 food_sales,
 drink_sales,
 food_order_count,
 drink_order_count,
 avg_order_amount,

 CASE WHEN food_sales = drink_sales THEN 'SAME'
      WHEN food_sales > drink_sales THEN 'FOOD'
       ELSE 'DRINK' END AS favorite_category,

 DENSE_RANK()OVER(
  ORDER BY total_sales DESC) AS customer_rank

FROM
 customer_summary
;
 
