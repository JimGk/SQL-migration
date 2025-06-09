
-- Migrate orders with order_date transformed to timestamp
INSERT INTO orders (customer_id, product_id, order_timestamp, quantity)
SELECT customer_id, product_id, order_date::timestamptz, quantity
FROM legacy.orders;
