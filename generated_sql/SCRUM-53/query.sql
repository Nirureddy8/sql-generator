-- ============================================================
-- Query     : d_buyer_transformation
-- Table Type: DIMENSION
-- Purpose   : Transform and load data into 'd_buyer'
-- ============================================================
WITH
  _source AS (
    SELECT
      sap_dim_buyer.cee_id AS buyer_cd,
      sap_dim_buyer.tee_id AS buyer_nm,
      'EDP source name' AS src_sys_cd
    FROM sap_dim_buyer
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY sap_dim_buyer.cee_id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
    WHERE  sap_dim_buyer.cee_id IS NOT NULL
  ),
  _transformed AS (
    SELECT
      buyer_cd,
      buyer_nm,
      src_sys_cd
    FROM   _scd
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;
