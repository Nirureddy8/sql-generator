-- Query: generate_shipment
-- Purpose: Fallback transform for shipment
-- Query Type: SELECT

WITH
    _source AS (
        SELECT *
        FROM <leading_table>
    )
SELECT
    sh_mstr.sh_id AS shipment_id,
  sh_mstr.sh_order AS order_id,
  sh_mstr.sh_date AS shipment_date,
  sh_mstr.sh_carrier AS carrier,
  sh_mstr.sh_track AS tracking_number,
  sh_mstr.sh_status AS delivery_status
FROM _source;