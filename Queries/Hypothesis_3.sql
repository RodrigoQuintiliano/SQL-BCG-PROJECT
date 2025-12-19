USE wonka_db;

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

-- Need to create a loyalty tier list for the customers in order to provide benefits for them:
CREATE TABLE loyal_customers AS
SELECT
    c.customer_id,
    COUNT(s.sale_id) AS total_orders,
    SUM(s.sales_amount) AS lifetime_sales,
    SUM(s.units) AS total_units,
    AVG(s.sales_amount) AS avg_order_value,

    CASE
        WHEN COUNT(s.sale_id) >= 300 AND SUM(s.sales_amount) >= 9000 THEN 'Premium'
        WHEN COUNT(s.sale_id) >= 200 AND SUM(s.sales_amount) >= 7000 THEN 'Gold'
        WHEN COUNT(s.sale_id) >= 100 AND SUM(s.sales_amount) >= 4000 THEN 'Silver'
        ELSE 'Standard'
    END AS loyalty_tier

FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_sales DESC;

-- Implementing benefits as discounts for silver, gold and premium cutomers:
SELECT
    customer_id,
    total_orders,
    lifetime_sales,
    loyalty_tier,

    CASE
        WHEN loyalty_tier = 'Premium' THEN '20% Discount'
        WHEN loyalty_tier = 'Gold' THEN '15% Discount'
        WHEN loyalty_tier = 'Silver' THEN '10% Discount'
        ELSE '5% Discount'
    END AS discount

FROM loyal_customers
ORDER BY 
	CASE
		WHEN loyalty_tier = 'Premium' THEN 1
        WHEN loyalty_tier = 'Gold' Then 2
        WHEN loyalty_tier = 'Silver' THen 3
        ELSE 4
	END,
    loyalty_tier DESC;

-- Even tho our customer 122336 is our customer with more lifetime sales he is still 
-- a silver customer due to low order numbers (188 as seen before), only customers with high lifetime sales
-- and high number of orders (more than 300 orders) can be premium customers and have a 20% discount.
-- This makes customer 122336 the customer who brought more revenue so far but not the most loyal 
-- This prevents giving rewards to one time big spenders.
-- So, our most loyal customers are customer 164756 and customer 100111.


