WITH base AS(
 SELECT 
  DATE_TRUNC(f.order_date, MONTH) AS order_month,
  SUM(f.order_amount) AS monthly_sales,
  d.region
 FROM
  fact_orders AS f
 LEFT JOIN
  dim_customers AS d
 ON
  f.customer_id = d.customer_id
 GROUP BY
  DATE_TRUNC(f.order_date, MONTH),
  d.region),

 lag_data AS(
  SELECT
   b.order_month,
   b.region,
   b.monthly_sales,

   LAG(b.monthly_sales) OVER(
    PARTITION BY b.region
     ORDER BY b.order_month) AS perv_month_sales

  FROM
   base AS b)

SELECT
 order_month,
 region,
 monthly_sales,
 prev_month_sales,

 ROUND(monthly_sales / NULLIF(prev_month_sales
        , 0) ,2) AS mom_rate,

 DENSE_RANK() OVER(
  PARTITION BY order_month
   ORDER BY monthly_sales DESC) AS region_rank

FROM
 lag_data
;
