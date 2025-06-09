
-- Migrate customers with full name transformation
INSERT INTO customers (full_name, email)
SELECT first_name || ' ' || last_name, email
FROM legacy.customers;
