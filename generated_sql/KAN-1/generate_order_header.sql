-- Query: generate_order_header
-- Purpose: Fallback transform for order_header
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    so_mstr.so_nbr AS order_id,
  so_mstr.so_cust AS customer_id,
  so_mstr.so_nbr AS order_number,
  so_mstr.so_date AS order_date,
  so_mstr.so_status AS order_status,
  so_mstr.so_curr AS currency,
  so_mstr.so_total AS total_amount,
  so_mstr.so_rep AS sales_rep
FROM _source;