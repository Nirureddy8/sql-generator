-- Query: generate_product_master
-- Purpose: Fallback transform for product_master
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    pt_mstr.pt_part AS product_id,
  pt_mstr.pt_desc1 AS product_name,
  pt_mstr.pt_line AS category,
  pt_mstr.pt_brand AS brand,
  pt_mstr.pt_cost AS unit_cost,
  pt_mstr.pt_status AS status
FROM _source;