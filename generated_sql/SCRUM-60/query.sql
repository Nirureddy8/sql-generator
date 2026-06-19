-- Databricks notebook source
-- Generated for: SCRUM-60
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 3: d_branch_transformation
--   Pattern: dimension_flat
-- Query 4: d_supplier_transformation
--   Pattern: dimension_flat

-- =============================
-- d_buyer_transformation
-- =============================
/**************************************************************************
Generated plan for d_buyer dimension table.
**************************************************************************/

-- Query: d_buyer_transformation
-- Pattern: dimension_flat
-- Coverage: 2 rows
-- WARNING: unresolved items: Row d_buyer::2: No source_field or logic provided for buyer_nm. Defaulting to CAST(NULL AS string).

SELECT
  buyer_cd AS buyer_cd,
  CAST(NULL AS string) AS buyer_nm
FROM e1lsg.d_buyer.buyer_cd buyer_cd

-- =============================
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
This plan generates a flat dimension table for d_gl_acct.
All fields are directly sourced from e1lsg.d_gl_acct.
**************************************************************************/

-- Query: d_gl_acct_transformation
-- Pattern: dimension_flat
-- Coverage: 15 rows

SELECT
  gl.gl_acct_id AS gl_acct_id,
  gl.gl_acct_nm AS gl_acct_nm,
  gl.object_acct_cd AS object_acct_cd,
  gl.subsdry_cd AS subsdry_cd,
  gl.object_acct_subsdry_nm AS object_acct_subsdry_nm,
  gl.co_cd AS co_cd,
  gl.co_nm AS co_nm,
  gl.cost_center_branch_cd AS cost_center_branch_cd,
  gl.cost_center_branch_nm AS cost_center_branch_nm,
  gl.dtl_lvl_nbr AS dtl_lvl_nbr,
  gl.curncy_cd AS curncy_cd,
  gl.curncy_nm AS curncy_nm,
  gl.object_acct_type_cd AS object_acct_type_cd,
  gl.object_acct_cost_type_cd AS object_acct_cost_type_cd,
  gl.coa_id AS coa_id
FROM e1lsg.d_gl_acct.gl_acct_id gl

-- =============================
-- d_branch_transformation
-- =============================
/**************************************************************************
Generated plan for d_branch dimension table.
**************************************************************************/

-- Query: d_branch_transformation
-- Pattern: dimension_flat
-- Coverage: 26 rows
-- WARNING: unresolved items: No source table or logic provided for cntry_cd, cntry_nm, curncy_cd, curncy_nm, org_unit_type, st_prov_cd, st_prov_nm, rec_crt_ts, rec_updt_ts.

SELECT
  CAST(NULL AS string) AS cntry_cd,
  CAST(NULL AS string) AS cntry_nm,
  CAST(NULL AS string) AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS org_unit_cd,
  CAST(NULL AS string) AS org_unit_nm,
  CAST(NULL AS string) AS org_unit_type,
  CAST(NULL AS string) AS parent_org_unit_cd,
  CAST(NULL AS string) AS parent_org_unit_nm,
  CAST(NULL AS string) AS src_sys_cd,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm,
  CAST(NULL AS string) AS rec_crt_ts,
  CAST(NULL AS string) AS rec_updt_ts
FROM yes f41
LEFT JOIN (SELECT ABAN8, ABALPH FROM F0101) AS f01 f01 ON f41.CIAN8 = f01.ABAN8

-- =============================
-- d_supplier_transformation
-- =============================
/**************************************************************************
This plan generates the d_supplier dimension table.
It includes joins to multiple source tables and applies transformations as specified.
**************************************************************************/

-- Query: d_supplier_transformation
-- Pattern: dimension_flat
-- Coverage: 57 rows

SELECT
  'src_sys_cd' AS src_sys_cd,
  f0401.A6AN8 AS suplr_id,
  'NA' AS alt_suplr_id,
  f0101.ABALPH AS suplr_nm,
  f0101.ABALPH AS lgl_suplr_nm,
  f0101.ABALPH AS parent_suplr_nm,
  f0101.ABALPH AS prim_branch_cd,
  f0101.ABALPH AS prim_branch_nm,
  f0101.ABALPH AS dnb_co_nbr,
  CAST(NULL AS timestamp) AS addr_crt_dt,
  f0116.ALADD1 AS suplr_addr_line_1,
  f0116.ALADD2 AS suplr_addr_line_2,
  f0116.ALADD3 AS suplr_addr_line_3,
  f0116.ALADD4 AS suplr_addr_line_4,
  f0116.ALADDZ AS suplr_pstl_cd,
  f0116.ALCTY1 AS suplr_city_nm,
  f0116.ALADDS AS suplr_st_cd,
  f0005_s.DL01 AS suplr_st_nm,
  f0005_s.DL01 AS suplr_rgn_cd,
  f0005_s.DL01 AS suplr_rgn_nm,
  f0116.ALCTR AS suplr_cntry_cd,
  f0005_cn.DL01 AS suplr_cntry_nm,
  CAST(NULL AS timestamp) AS addr_eff_dt,
  f0115.WPAR1 AS suplr_phn_area_cd,
  f0115.WPPH1 AS suplr_phn_nbr,
  f0115.WPPH1 AS suplr_email_addr,
  CAST(NULL AS string) AS suplr_dvrsty_cd,
  CAST(NULL AS string) AS suplr_dvrsty_nm,
  CAST(NULL AS string) AS suplr_class_cd,
  CAST(NULL AS string) AS suplr_class_nm,
  CAST(NULL AS string) AS suplr_indy_cd,
  CAST(NULL AS string) AS suplr_indy_nm,
  CAST(NULL AS string) AS suplr_type_cd,
  CAST(NULL AS string) AS suplr_type_nm,
  f0401.A6TRAP AS paymt_terms_cd,
  f0014.PNPTD AS paymt_terms_nm,
  CAST(NULL AS string) AS suplr_rel_cd,
  CAST(NULL AS string) AS suplr_lang_cd,
  CAST(NULL AS string) AS suplr_lang_nm,
  CAST(NULL AS string) AS contract_id,
  CAST(NULL AS string) AS contract_type_nm,
  CAST(NULL AS string) AS contract_stat_cd,
  CAST(NULL AS timestamp) AS contract_begin_dt,
  CAST(NULL AS timestamp) AS contract_end_dt,
  CAST(NULL AS string) AS cmdty_mgr_nm,
  CAST(NULL AS decimal(38,6)) AS mthly_projctd_spend_amt,
  CAST(NULL AS decimal(38,6)) AS mthly_projctd_saving_amt,
  CAST(NULL AS string) AS contract_comment_txt,
  CAST(NULL AS string) AS frt_terms_cd,
  CAST(NULL AS string) AS frt_terms_nm,
  CAST(NULL AS string) AS inco_terms_cd,
  CAST(NULL AS string) AS inco_terms_nm,
  CAST(NULL AS string) AS suplr_assgn_grp_cd,
  CAST(NULL AS string) AS suplr_assgn_grp_nm,
  CASE WHEN f0101.AT1 = 'V' THEN 'Y' ELSE 'N' END AS suplr_active_flg,
  CAST(NULL AS string) AS status_cd,
  'NA' AS norm_supplier_type
FROM f0014.pnptd where f0014.pnptc=f0401.a6trap f0401
LEFT JOIN F0014 f0014 ON f0014.PNPTC = f0401.A6TRAP
LEFT JOIN F0101 f0101 ON f0101.AN8 = f0401.A6AN8
LEFT JOIN F0115 f0115 ON f0115.WPAN8 = f0401.A6AN8
LEFT JOIN F0116 f0116 ON f0116.ALAN8 = f0401.A6AN8
LEFT JOIN (SELECT DL01 FROM F0005 WHERE SY = '00' AND RT = 'CN') f0005_cn ON f0005_cn.KY = f0116.ALCTR
LEFT JOIN (SELECT DL01 FROM F0005 WHERE SY = '00' AND RT = 'S') f0005_s ON f0005_s.KY = f0116.ALADDS
WHERE f0401.A6AN8 IS NOT NULL
