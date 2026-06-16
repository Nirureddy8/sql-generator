-- Query: generate_invoice
-- Purpose: Fallback transform for invoice
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    inv_mstr.inv_id AS invoice_id,
  inv_mstr.inv_order AS order_id,
  inv_mstr.inv_nbr AS invoice_number,
  inv_mstr.inv_date AS invoice_date,
  inv_mstr.inv_amt AS invoice_amount
FROM _source;