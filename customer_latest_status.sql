WITH rnk AS(
 SELECT
  f.customer_id,
  f.category,
  f.order_date,

  SUM(f.order_amount) OVER(
   PARTITION BY f.customer_id
    ) AS total_sales,

  COUNT(*) OVER(PARTITION BY f.customer_id
   ) AS order_count,

  ROW_NUMBER() OVER(
   PARTITION BY f.customer_id
    ORDER BY f.order_date DESC) AS rn

  FROM
   fact_orders AS f)

SELECT
 customer_id,
 category AS latest_category,
 order_date AS letest_order_date,
 total_sales,
 order_count,

 SAFE_DIVIDE(total_sales, order_count
   ) AS avg_sales_per_order

FROM
 rnk
WHERE
 rn = 1
;
