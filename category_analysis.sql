WITH customer_summary AS(
 SELECT
  f.customer_id,
  SUM(f.order_amount) AS total_sales,
  
  SUM(CASE WHEN f.category = 'food'
       THEN f.order_amount ELSE 0
        END) AS food_sales,

  SUM(CASE WHEN f.category = 'drink'
       THEN f.order_amount ELSE 0
        END) AS drink_sales

 FROM
  fact_orders AS f
 GROUP BY
  f.customer_id)

SELECT
 customer_id,
 total_sales,
 food_sales,
 drink_sales,

 ROUND(food_sales / total_sales , 2) AS food_ratio,
 ROUND(drink_sales / total_sales , 2) AS drink_ratio,

 CASE WHEN food_sales = drink_sales THEN 'SAME'
      WHEN food_salse > drink_sales THEN 'FOOD'
       ELSE 'DRINK' END AS favorite_category,

 DENSE_RANK() OVER(ORDER BY total_sales
  DESC) AS customer_rank

FROM
 customer_summary
;
