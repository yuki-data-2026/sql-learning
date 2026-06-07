WITH monthly_history AS(
 SELECT
  DATE_TRUNC(f.order_date, MONTH) AS order_month,
  SUM(f.order_amount) AS monthly_sales,
  COUNT(*) AS order_count
 FROM
  fact_orders AS f
 GROUP BY
  DATE_TRUNC(f.order_date, MONTH)),

 prev_monthly AS(
  SELECT
   m.order_month,
   m.monthly_sales,
   m.order_count,

   LAG(m.monthly_sales) OVER(
    ORDER BY m.order_month) AS prev_monthly_sales

  FROM
   monthly_history AS m),

 final_data AS(
  SELECT
   p.order_month,
   p.monthly_sales,
   p.order_count,
   p.prev_monthly_sales,

   p.monthly_sales -　p.prev_monthly_sales　AS sales_diff,

   ROUND((p.monthly_sales /NULLIF(p.prev_monthly_sales
    , 0)) *100, 2) AS mom_rate
 
  FROM
   prev_monthly AS p)

SELECT
 monthly_sales,
 order_count,
 sales_diff,
 mom_rate,

 CASE WHEN prev_monthly_salse IS NULL THEN 'FIRST_MONTH'
      WHEN mom_rate >= 120 THEN 'GROW'
      WHEN mom_rate < 80 TEHN 'DECLINE'
       ELSE 'STABLE' END AS sales_status

FROM
 final_data
;
