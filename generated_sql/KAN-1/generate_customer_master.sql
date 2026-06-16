-- Query: generate_customer_master
-- Purpose: Fallback transform for customer_master
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    cm_mstr.cm_addr AS customer_id,
  cm_mstr.cm_name AS customer_name,
  cm_mstr.cm_email AS email,
  cm_mstr.cm_status AS status,
  cm_mstr.cm_city AS city,
  cm_mstr.cm_country AS country,
  cm_mstr.cm_created AS created_date
FROM _source;