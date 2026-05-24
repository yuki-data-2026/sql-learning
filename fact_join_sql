WITH orders_totalling AS(
 SELECT
  fo.custmer_id,
  SUM(fo.order_amount) AS total_order_sales,
  COUNT(*) AS order_count
 FROM
  fact_orders AS fo
 GROUP BY
  fo.customer_id),

 payments_totalling AS(
  SELECT
   fp.customer_id,
   SUM(fp.payment_amount) AS total_payment_amount,
   COUNT(*) AS payment_count
  FROM
   fact_payments AS fp
  GROUP BY
   fp.customer_id)

SELECT
 o.customer_id,
 o.total_order_sales,
 o.order_count,
 p.total_payment_amount,
 p.payment_count,
 
 o.total_order_sales - 
  p.total_payment_amount AS sales_diff,

 CASE WHEN o.total_order_sales -  
  p.total_payment_amount = 0 THEN 'PAID'
 WHEN o.total_order_sales -  
  p.total_payment_amount > 0 THEN 'UNPAID'
  ELSE 'OVERPAID' END AS customer_status

FROM
 orders_totalling AS o
LEFT JOIN
 payments_totalling AS p
ON
 o.customer_id = p.customer_id
;
