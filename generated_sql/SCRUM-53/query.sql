-- ============================================================
-- Query     : d_buyer_transformation
-- Table Type: DIMENSION
-- Purpose   : Transform and load buyer data
-- ============================================================
WITH
  _source AS (
    SELECT
      NULL AS buyer_cd,
      NULL AS buyer_nm,
      'byd_brsbn' AS src_sys_cd
    FROM sap_dim_buyer
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
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