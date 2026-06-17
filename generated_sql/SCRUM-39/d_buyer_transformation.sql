-- Query: d_buyer_transformation
-- Purpose: Transform and load data into d_buyer
-- Query Type: SELECT

-- Query: d_buyer_transformation
-- Purpose: Transform and load data into 'd_buyer'
-- Query Type: SELECT

WITH
  _source_d_buyer_0 AS (
SELECT
  sap_dim_buyer.cee_id AS buyer_cd,
  sap_dim_buyer.tee_id AS buyer_nm
FROM sap_dim_buyer
WHERE sap_dim_buyer.cee_id IS NOT NULL
  ),
  _source_d_buyer_1 AS (
SELECT
  'byd_brsbn' AS src_sys_cd
FROM sap_dim_buyer
WHERE sap_dim_buyer.src_sys_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    buyer_cd AS buyer_cd,
    buyer_nm AS buyer_nm,
    'byd_brsbn' AS src_sys_cd
  FROM _source_d_buyer_1
  )
SELECT * FROM _transformed;