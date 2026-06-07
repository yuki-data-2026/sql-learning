
WITH category_data AS(
 SELECT
  f.category,
  SUM(f.order_amount) AS total_sales,
  AVG(f.order_amount) AS avg_sales,
  COUNT(*) AS order_count
 FROM
  fact_orders AS f
 GROUP BY
  f.category)

SELECT
 category,
 total_sales,
 avg_sales,
 order_count,

 ROUND((total_sales / SUM(total_sales)
 OVER() )*100,2) AS sales_ratio,

 DENSE_RANK() OVER(
 ORDER BY total_sales DESC) AS sales_rank

FROM
 category_data
;
