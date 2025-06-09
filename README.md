# Legacy to Modern Database Migration (PostgreSQL)

This project simulates a real-world database migration from a legacy schema to a modern PostgreSQL system. It includes schema design, data import, SQL-based data transformation, and post-migration validation.

---

## Folder Structure

```
SQL-Migration-Project/
├── data/           # CSV files used to simulate legacy data
├── schema/         # SQL files for legacy and modern schemas
├── scripts/        # SQL scripts to migrate and transform data
├── validation/     # Validation queries to check consistency
```

---

## Tools Used

- PostgreSQL
- DBeaver
- Git & GitHub

---

## Features & Steps

1. **Schema Design**
   - `legacy_schema.sql`: basic structure using first/last names
   - `modern_schema.sql`: normalized schema using full names and constraints

2. **Data Import**
   - Imported 1000 records into legacy tables from `customers_large.csv`, `products_large.csv`, `orders_large.csv`

3. **Data Migration**
   - Used SQL-only scripts to transform and load data into modern schema
   - Scripts: `migrate_customers.sql`, `migrate_products.sql`, `migrate_orders.sql`

4. **Validation**
   - Verified row counts and transformations via `check_counts.sql`
   - Ensured no missing joins, nulls, or inconsistencies

5. **Advanced SQL**
   - See `advanced_sql_queries.sql` for examples of revenue, customer behavior, duplicates, and monthly breakdowns

---

## What This Project Demonstrates

- PostgreSQL proficiency (DDL, DML, joins, constraints, casting)
- Migration and transformation logic using SQL only
- Use of DBeaver for real-world workflow
- Clean, documented folder and version control structure
- Data validation and basic analytics

---

## Author

**Dimitrios Gogos**  
