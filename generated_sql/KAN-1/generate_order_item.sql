-- Query: generate_order_item
-- Purpose: Fallback transform for order_item
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    sod_det.sod_line AS order_item_id,
  sod_det.sod_nbr AS order_id,
  sod_det.sod_part AS product_id,
  sod_det.sod_qty AS quantity,
  sod_det.sod_price AS unit_price,
  sod_det.sod_disc AS discount,
  sod_det.sod_tax AS tax_amount,
  sod_det.sod_total AS line_total
FROM _source;