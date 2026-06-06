WITH union_data AS(
 SELECT
  sf.customer_id,
  sf.order_date,
  sf.order_amoun,
  'Food' AS category
 FROM
  sales_food AS sf

 UNION ALL

SELECT
  sd.customer_id,
  sd.order_date,
  sd.order_amoun,
  'Drink' AS category
 FROM
  sales_drink AS sd),

 totalling AS(
  SELECT
   u.customer_id,
   u.order_date AS latest_order_date,

   SUM(u.order_amount)  OVER(
    PARTITION BY u.customer_id) AS total_sales,

   COUNT(*) OVER(
    PARTITION BY u.customer_id) AS order_count

 FROM
  union_data AS u

 QUALIFY ROW_NUMBER() OVER(
  PARTITION BY u.customer_id
   ORDER BY u.order_date DESC) = 1)

SELECT
 latest_order_date,
 total_sales,
 order_count,
 
 ROUND(SAFE_DIVIDE(total_sales,
  order_count) , 2) AS avg_sales_per_order,

 ROUND(SAFE_DIVIDE(total_sales,
  SUM(total_sales) OVER())
   , 2) AS sales_ratio,

 DENSE_RANK() OVER(
  ORDER BY total_sales DESC) AS sales_rank

FROM
 totalling
;
