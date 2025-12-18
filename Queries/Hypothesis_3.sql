USE wonka_db;

-- THIS IS NOT FINISHED 

-- Customer Lifetime Summary:

SELECT
    c.customer_id,
    COUNT(s.sale_id) AS total_orders,
    SUM(s.sales_amount) AS lifetime_sales,
    SUM(s.units) AS total_units,
    AVG(s.sales_amount) AS avg_order_value
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_sales DESC;
-- Best customer is 122336 with a life time sales of 12920.60$ with only 188 orders and with a value of 
-- each order on 68.7$
-- Customer with more orders is 100111 with a total of 709 orders and a revenue of 9268$, average order 
-- sitting on 13$.

