-- Databricks notebook source
-- Generated for: SCRUM-60
-- Universal Plan Schema generation
--
-- Query 1: d_branch_transformation
--   Pattern: dimension_flat
-- Query 2: d_supplier_transformation
--   Pattern: dimension_flat

-- =============================
-- d_branch_transformation
-- =============================
/**************************************************************************
Generated plan for d_branch dimension table.
**************************************************************************/

-- Query: d_branch_transformation
-- Pattern: dimension_flat
-- Coverage: 26 rows
-- WARNING: unresolved items: No source tables provided for cntry_cd, cntry_nm, curncy_cd, curncy_nm, st_prov_cd, st_prov_nm, rec_crt_ts, rec_updt_ts.; No join conditions provided for F0101.ABALPH where F0101.ABAN8=F41001.CIAN8.

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
FROM source t

-- =============================
-- d_supplier_transformation
-- =============================
/**************************************************************************
Generated plan for d_supplier dimension table.
**************************************************************************/

-- Query: d_supplier_transformation
-- Pattern: dimension_flat
-- Coverage: 57 rows

SELECT
  ds.src_sys_cd AS src_sys_cd,
  ds.suplr_id AS suplr_id,
  ds.alt_suplr_id AS alt_suplr_id,
  ds.suplr_nm AS suplr_nm,
  ds.lgl_suplr_nm AS lgl_suplr_nm,
  ds.parent_suplr_nm AS parent_suplr_nm,
  ds.prim_branch_cd AS prim_branch_cd,
  ds.prim_branch_nm AS prim_branch_nm,
  ds.dnb_co_nbr AS dnb_co_nbr,
  ds.addr_crt_dt AS addr_crt_dt,
  ds.suplr_addr_line_1 AS suplr_addr_line_1,
  ds.suplr_addr_line_2 AS suplr_addr_line_2,
  ds.suplr_addr_line_3 AS suplr_addr_line_3,
  ds.suplr_addr_line_4 AS suplr_addr_line_4,
  ds.suplr_pstl_cd AS suplr_pstl_cd,
  ds.suplr_city_nm AS suplr_city_nm,
  ds.suplr_st_cd AS suplr_st_cd,
  ds.suplr_st_nm AS suplr_st_nm,
  ds.suplr_rgn_cd AS suplr_rgn_cd,
  ds.suplr_rgn_nm AS suplr_rgn_nm,
  ds.suplr_cntry_cd AS suplr_cntry_cd,
  ds.suplr_cntry_nm AS suplr_cntry_nm,
  ds.addr_eff_dt AS addr_eff_dt,
  ds.suplr_phn_area_cd AS suplr_phn_area_cd,
  ds.suplr_phn_nbr AS suplr_phn_nbr,
  ds.suplr_email_addr AS suplr_email_addr,
  ds.suplr_dvrsty_cd AS suplr_dvrsty_cd,
  ds.suplr_dvrsty_nm AS suplr_dvrsty_nm,
  ds.suplr_class_cd AS suplr_class_cd,
  ds.suplr_class_nm AS suplr_class_nm,
  ds.suplr_indy_cd AS suplr_indy_cd,
  ds.suplr_indy_nm AS suplr_indy_nm,
  ds.suplr_type_cd AS suplr_type_cd,
  ds.suplr_type_nm AS suplr_type_nm,
  ds.paymt_terms_cd AS paymt_terms_cd,
  ds.paymt_terms_nm AS paymt_terms_nm,
  ds.suplr_rel_cd AS suplr_rel_cd,
  ds.suplr_lang_cd AS suplr_lang_cd,
  ds.suplr_lang_nm AS suplr_lang_nm,
  ds.contract_id AS contract_id,
  ds.contract_type_nm AS contract_type_nm,
  ds.contract_stat_cd AS contract_stat_cd,
  ds.contract_begin_dt AS contract_begin_dt,
  ds.contract_end_dt AS contract_end_dt,
  ds.cmdty_mgr_nm AS cmdty_mgr_nm,
  ds.mthly_projctd_spend_amt AS mthly_projctd_spend_amt,
  ds.mthly_projctd_saving_amt AS mthly_projctd_saving_amt,
  ds.contract_comment_txt AS contract_comment_txt,
  ds.frt_terms_cd AS frt_terms_cd,
  ds.frt_terms_nm AS frt_terms_nm,
  ds.inco_terms_cd AS inco_terms_cd,
  ds.inco_terms_nm AS inco_terms_nm,
  ds.suplr_assgn_grp_cd AS suplr_assgn_grp_cd,
  ds.suplr_assgn_grp_nm AS suplr_assgn_grp_nm,
  ds.suplr_active_flg AS suplr_active_flg,
  ds.status_cd AS status_cd,
  ds.norm_supplier_type AS norm_supplier_type
FROM e1lsg.d_supplier ds
