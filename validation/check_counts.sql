
-- Compare row counts between legacy and modern tables
SELECT 
  'customers' AS table_name, 
  (SELECT COUNT(*) FROM legacy.customers) AS legacy_count, 
  (SELECT COUNT(*) FROM public.customers c ) AS modern_count
UNION
SELECT 
  'products', 
  (SELECT COUNT(*) FROM legacy.products), 
  (SELECT COUNT(*) FROM public.products p  )
UNION
SELECT 
  'orders', 
  (SELECT COUNT(*) FROM legacy.orders), 
  (SELECT COUNT(*) FROM public.orders o );
