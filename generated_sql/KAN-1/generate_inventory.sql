-- Query: generate_inventory
-- Purpose: Fallback transform for inventory
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    invt_mstr.invt_id AS inventory_id,
  invt_mstr.invt_prod AS product_id,
  invt_mstr.invt_qty AS stock_qty
FROM _source;