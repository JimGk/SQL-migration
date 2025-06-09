
-- Compare row counts between legacy and modern tables
SELECT 
  'customers' AS table_name, 
  (SELECT COUNT(*) FROM legacy_db.customers) AS legacy_count, 
  (SELECT COUNT(*) FROM modern_db.customers) AS modern_count
UNION
SELECT 
  'products', 
  (SELECT COUNT(*) FROM legacy_db.products), 
  (SELECT COUNT(*) FROM modern_db.products)
UNION
SELECT 
  'orders', 
  (SELECT COUNT(*) FROM legacy_db.orders), 
  (SELECT COUNT(*) FROM modern_db.orders);
