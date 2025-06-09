
-- 1. Total number of customers
SELECT COUNT(*) AS total_customers FROM customers;

-- 2. List of all customers who ordered more than once
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

-- 3. Top 5 customers by total quantity ordered
SELECT c.customer_id, c.full_name, SUM(o.quantity) AS total_quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_quantity DESC
LIMIT 5;

-- 4. Total revenue per product
SELECT p.product_name, SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 5. Average order quantity per product
SELECT p.product_name, AVG(o.quantity) AS avg_quantity
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY avg_quantity DESC;

-- 6. Monthly order volume
SELECT DATE_TRUNC('month', order_timestamp) AS month, COUNT(*) AS orders
FROM orders
GROUP BY month
ORDER BY month;

-- 7. Find duplicate customer emails (if any)
SELECT email, COUNT(*) 
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- 8. Find customers who ordered 'Laptop'
SELECT DISTINCT c.full_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE p.product_name = 'Laptop';

-- 9. Customers with no orders
SELECT c.full_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 10. Most popular product by number of orders
SELECT p.product_name, COUNT(*) AS times_ordered
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY times_ordered DESC
LIMIT 1;
