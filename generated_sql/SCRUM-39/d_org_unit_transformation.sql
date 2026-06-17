-- Query: d_org_unit_transformation
-- Purpose: Transform and load data into d_org_unit
-- Query Type: SELECT

-- Query: d_org_unit_transformation
-- Purpose: Transform and load data into 'd_org_unit'
-- Query Type: SELECT

WITH
  _source_d_org_unit_0 AS (
SELECT
  sap_dim_org_unit_site.ccity_name AS city_nm,
  sap_dim_org_unit_site.ccntry_code AS cntry_cd,
  sap_dim_org_unit_site.tcntry_code AS cntry_nm,
  sap_dim_org_unit_site.CBUYER AS co_cd,
  sap_dim_org_unit_site.TBUYER AS co_nm,
  sap_dim_org_unit_site.CPARTY_ID AS org_unit_cd,
  sap_dim_org_unit_site.TPARTY_ID AS org_unit_nm,
  sap_dim_org_unit_site.cregion_code AS st_prov_cd,
  sap_dim_org_unit_site.cst_name AS street_nm
FROM sap_dim_org_unit_site
WHERE sap_dim_org_unit_site.src_sys_cd IS NOT NULL
  AND sap_dim_org_unit_site.org_unit_cd IS NOT NULL
  AND sap_dim_org_unit_site.org_unit_type IS NOT NULL
  ),
  _source_d_org_unit_1 AS (
SELECT
  'AUD' AS co_curncy_cd,
  'Australia Dollar' AS co_curncy_nm,
  CAST(NULL AS string) AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS org_unit_cat_nm,
  'manufacturing plant' AS org_unit_type,
  CAST(NULL AS string) AS parent_org_unit_cd,
  CAST(NULL AS string) AS parent_org_unit_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS st_prov_nm
FROM sap_dim_org_unit_site
WHERE src_sys_cd IS NOT NULL AND org_unit_cd IS NOT NULL AND org_unit_type IS NOT NULL
  ),
  _transformed AS (
  SELECT
    city_nm AS city_nm,
    cntry_cd AS cntry_cd,
    cntry_nm AS cntry_nm,
    co_cd AS co_cd,
    co_nm AS co_nm,
    org_unit_cd AS org_unit_cd,
    org_unit_nm AS org_unit_nm,
    st_prov_cd AS st_prov_cd,
    street_nm AS street_nm,
    co_curncy_cd AS co_curncy_cd,
    co_curncy_nm AS co_curncy_nm,
    curncy_cd AS curncy_cd,
    curncy_nm AS curncy_nm,
    gbl_rgn_cd AS gbl_rgn_cd,
    gbl_rgn_nm AS gbl_rgn_nm,
    lang_cd AS lang_cd,
    lang_iso_cd AS lang_iso_cd,
    lang_nm AS lang_nm,
    org_unit_cat_nm AS org_unit_cat_nm,
    org_unit_type AS org_unit_type,
    parent_org_unit_cd AS parent_org_unit_cd,
    parent_org_unit_nm AS parent_org_unit_nm,
    rgn_cd AS rgn_cd,
    rgn_nm AS rgn_nm,
    src_sys_cd AS src_sys_cd,
    st_prov_nm AS st_prov_nm
  FROM _source_d_org_unit_1
  )
SELECT * FROM _transformed;