-- Query: d_company_transformation
-- Purpose: Transform and load data into d_company
-- Query Type: SELECT

-- Query: d_company_transformation
-- Purpose: Transform and load data into 'd_company'
-- Query Type: SELECT

WITH
  _source_d_company_0 AS (
SELECT
  sap_dim_org_unit_site.ccity_name AS city_nm
FROM sap_dim_company
LEFT JOIN sap_dim_org_unit_site
  ON sap_dim_org_unit_site.cparty_id = 4192
WHERE sap_dim_company.src_sys_cd IS NOT NULL
  AND sap_dim_company.co_cd IS NOT NULL
  ),
  _source_d_company_1 AS (
SELECT
  sap_dim_company.ccntry_code AS cntry_cd,
  sap_dim_company.tcntry_code AS cntry_nm,
  sap_dim_company.cco_id AS co_cd,
  sap_dim_company.tco_id AS co_nm
FROM sap_dim_company
WHERE sap_dim_company.cco_id IS NOT NULL AND sap_dim_company.src_sys_cd IS NOT NULL
  ),
  _source_d_company_2 AS (
SELECT
  'AUD' AS co_curncy_cd,
  'Australian Dollar' AS co_curncy_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CAST(NULL AS string) AS group_nm,
  'PSBIOLC' AS hfm_entity_cd,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm
FROM sap_dim_company
WHERE sap_dim_company.src_sys_cd IS NOT NULL AND sap_dim_company.co_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    city_nm AS city_nm,
    cntry_cd AS cntry_cd,
    cntry_nm AS cntry_nm,
    co_cd AS co_cd,
    co_nm AS co_nm,
    co_curncy_cd AS co_curncy_cd,
    co_curncy_nm AS co_curncy_nm,
    gbl_rgn_cd AS gbl_rgn_cd,
    gbl_rgn_nm AS gbl_rgn_nm,
    group_nm AS group_nm,
    hfm_entity_cd AS hfm_entity_cd,
    lang_cd AS lang_cd,
    lang_iso_cd AS lang_iso_cd,
    lang_nm AS lang_nm,
    rgn_cd AS rgn_cd,
    rgn_nm AS rgn_nm,
    src_sys_cd AS src_sys_cd,
    st_prov_cd AS st_prov_cd,
    st_prov_nm AS st_prov_nm
  FROM _source_d_company_2
  )
SELECT * FROM _transformed;