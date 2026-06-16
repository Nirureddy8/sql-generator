-- Query: generate_supplier_master
-- Purpose: Fallback transform for supplier_master
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    sup_mstr.sup_id AS supplier_id,
  sup_mstr.sup_name AS supplier_name,
  sup_mstr.sup_city AS supplier_city
FROM _source;