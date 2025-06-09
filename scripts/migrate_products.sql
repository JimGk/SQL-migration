
-- Migrate products as-is
INSERT INTO products (product_id, product_name, price)
SELECT product_id, product_name, price
FROM legacy.products;
