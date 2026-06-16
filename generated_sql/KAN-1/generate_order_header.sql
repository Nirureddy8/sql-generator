-- Query: generate_order_header
-- Purpose: Transform data for order_header
-- Query Type: SELECT

WITH
  _source AS (
    SELECT
      so_mstr.so_nbr AS order_id,
      so_mstr.so_cust AS customer_id,
      so_mstr.so_nbr AS order_number,
      so_mstr.so_date AS order_date,
      so_mstr.so_status AS order_status,
      so_mstr.so_curr AS currency,
      so_mstr.so_total AS total_amount,
      so_mstr.so_rep AS sales_rep
    FROM so_mstr
    WHERE so_mstr.so_status = 'COMPLETED'
  )
SELECT
  customer_master.customer_name AS customer_name,
  customer_master.email AS email,
  customer_master.city AS city,
  _source.order_date AS order_date,
  _source.total_amount AS total_amount,
  _source.sales_rep AS sales_rep
FROM _source
JOIN customer_master ON _source.customer_id = customer_master.customer_id
ORDER BY _source.order_date DESC;