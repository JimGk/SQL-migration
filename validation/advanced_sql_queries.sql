
-- 1. Total Revenue per Customer with Rank
WITH customer_revenue AS (
  SELECT
    c.customer_id,
    c.full_name,
    SUM(p.price * o.quantity) AS total_revenue
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  JOIN products p ON o.product_id = p.product_id
  GROUP BY c.customer_id, c.full_name
)
SELECT *,
  RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_revenue;

-- 2. Monthly Revenue with Running Total
WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC('month', o.order_timestamp) AS month,
    SUM(p.price * o.quantity) AS revenue
  FROM orders o
  JOIN products p ON o.product_id = p.product_id
  GROUP BY month
)
SELECT *,
  SUM(revenue) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM monthly_revenue;

-- 3. Most Popular Product per Month
WITH monthly_products AS (
  SELECT
    DATE_TRUNC('month', o.order_timestamp) AS month,
    p.product_name,
    COUNT(*) AS order_count
  FROM orders o
  JOIN products p ON o.product_id = p.product_id
  GROUP BY month, p.product_name
),
ranked_products AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY order_count DESC) AS rnk
  FROM monthly_products
)
SELECT * FROM ranked_products
WHERE rnk = 1;

-- 4. Customer Retention: First vs Last Order
WITH order_dates AS (
  SELECT
    customer_id,
    MIN(order_timestamp) AS first_order,
    MAX(order_timestamp) AS last_order
  FROM orders
  GROUP BY customer_id
)
SELECT
  c.full_name,
  first_order,
  last_order,
  AGE(last_order, first_order) AS customer_lifespan
FROM order_dates od
JOIN customers c ON c.customer_id = od.customer_id;

-- 5. Products Never Ordered
SELECT p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- 6. Product Sales Percent Contribution
WITH product_sales AS (
  SELECT p.product_name, SUM(p.price * o.quantity) AS revenue
  FROM orders o
  JOIN products p ON o.product_id = p.product_id
  GROUP BY p.product_name
),
total_revenue AS (
  SELECT SUM(revenue) AS total FROM product_sales
)
SELECT ps.product_name,
       ps.revenue,
       ROUND((ps.revenue / tr.total) * 100, 2) AS percent_contribution
FROM product_sales ps, total_revenue tr
ORDER BY percent_contribution DESC;

-- 7. Average Time Between Orders Per Customer
WITH ordered_dates AS (
  SELECT
    customer_id,
    order_timestamp,
    LEAD(order_timestamp) OVER (PARTITION BY customer_id ORDER BY order_timestamp) AS next_order
  FROM orders
),
order_intervals AS (
  SELECT customer_id,
         next_order - order_timestamp AS days_between
  FROM ordered_dates
  WHERE next_order IS NOT NULL
)
SELECT customer_id,
       AVG(days_between) AS avg_days_between_orders
FROM order_intervals
GROUP BY customer_id;

-- 8. Detect Customers with Order Spikes
WITH customer_orders AS (
  SELECT customer_id, DATE(order_timestamp) AS order_day, COUNT(*) AS daily_orders
  FROM orders
  GROUP BY customer_id, order_day
)
SELECT customer_id, order_day, daily_orders
FROM customer_orders
WHERE daily_orders > (
  SELECT ROUND(AVG(daily_orders) + STDDEV(daily_orders), 0)
  FROM customer_orders
);

-- 9. Customers with Highest Return-to-Order Ratio
WITH order_counts AS (
  SELECT customer_id, COUNT(*) AS total_orders
  FROM orders
  GROUP BY customer_id
),
return_counts AS (
  SELECT o.customer_id, COUNT(*) AS total_returns
  FROM returns r
  JOIN orders o ON r.order_id = o.order_id
  GROUP BY o.customer_id
)
SELECT oc.customer_id,
       oc.total_orders,
       COALESCE(rc.total_returns, 0) AS total_returns,
       ROUND(COALESCE(rc.total_returns::decimal / oc.total_orders, 0), 2) AS return_ratio
FROM order_counts oc
LEFT JOIN return_counts rc ON oc.customer_id = rc.customer_id
ORDER BY return_ratio DESC;

-- 10. Last Order Info per Customer
SELECT DISTINCT ON (c.customer_id)
  c.customer_id,
  c.full_name,
  o.order_timestamp,
  p.product_name,
  o.quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
ORDER BY c.customer_id, o.order_timestamp DESC;

