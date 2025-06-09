
-- Migrate products as-is
INSERT INTO products (product_name, price)
SELECT product_name, price
FROM legacy_db.products;
