-- Query: d_gl_acct_transformation
-- Purpose: Transform and load data into d_gl_acct
-- Query Type: SELECT

-- Query: d_gl_acct_transformation
-- Purpose: Transform and load data into 'd_gl_acct'
-- Query Type: SELECT

WITH
  _source_d_gl_acct_0 AS (
SELECT
  dim_gl_acct.ccompany_uuid AS co_cd,
  dim_gl_acct.cglacct AS gl_acct_id,
  dim_gl_acct.tglacct AS gl_acct_nm
FROM dim_gl_acct
WHERE dim_gl_acct.src_sys_cd IS NOT NULL AND dim_gl_acct.gl_acct_id IS NOT NULL
  ),
  _source_d_gl_acct_1 AS (
SELECT
  sap_dim_gl_acct.tcompany_uuid AS co_nm,
  sap_dim_gl_acct.CCOST_CTR_UUID AS cost_center_branch_cd,
  sap_dim_gl_acct.TCOST_CTR_UUID AS cost_center_branch_nm
FROM sap_dim_gl_acct
WHERE sap_dim_gl_acct.src_sys_cd IS NOT NULL AND sap_dim_gl_acct.gl_acct_id IS NOT NULL
  ),
  _source_d_gl_acct_2 AS (
SELECT
  CAST(NULL AS STRING) AS coa_id,
  CAST(NULL AS STRING) AS curncy_cd,
  CAST(NULL AS STRING) AS curncy_nm,
  CAST(NULL AS STRING) AS dtl_lvl_nbr,
  CAST(NULL AS STRING) AS object_acct_cd,
  CAST(NULL AS STRING) AS object_acct_cost_type_cd,
  CAST(NULL AS STRING) AS object_acct_subsdry_nm,
  CAST(NULL AS STRING) AS object_acct_type_cd,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS STRING) AS subsdry_cd
FROM dim_gl_acct
WHERE gl_acct_id IS NOT NULL AND src_sys_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    co_cd AS co_cd,
    gl_acct_id AS gl_acct_id,
    gl_acct_nm AS gl_acct_nm,
    co_nm AS co_nm,
    cost_center_branch_cd AS cost_center_branch_cd,
    cost_center_branch_nm AS cost_center_branch_nm,
    coa_id AS coa_id,
    curncy_cd AS curncy_cd,
    curncy_nm AS curncy_nm,
    dtl_lvl_nbr AS dtl_lvl_nbr,
    object_acct_cd AS object_acct_cd,
    object_acct_cost_type_cd AS object_acct_cost_type_cd,
    object_acct_subsdry_nm AS object_acct_subsdry_nm,
    object_acct_type_cd AS object_acct_type_cd,
    src_sys_cd AS src_sys_cd,
    subsdry_cd AS subsdry_cd
  FROM _source_d_gl_acct_2
  )
SELECT * FROM _transformed;