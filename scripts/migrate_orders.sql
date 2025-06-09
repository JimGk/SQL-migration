
-- Migrate orders with order_date transformed to timestamp
INSERT INTO orders (customer_id, product_id, order_timestamp, quantity)
SELECT customer_id, product_id, TO_TIMESTAMP(order_date, 'YYYY-MM-DD'), quantity
FROM legacy_db.orders;
