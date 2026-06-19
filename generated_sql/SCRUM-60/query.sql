-- Databricks notebook source
-- Generated for: SCRUM-60
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 3: d_company_transformation
--   Pattern: dimension_flat
-- Query 4: d_org_unit_transformation
--   Pattern: dimension_flat
-- Query 5: d_supplier_transformation
--   Pattern: dimension_flat
-- Query 6: d_product_cost_transformation
--   Pattern: dimension_flat
-- Query 7: d_branch_transformation
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

SELECT
  e1lsg.d_buyer.buyer_cd AS buyer_cd,
  e1lsg.d_buyer.buyer_nm AS buyer_nm
FROM e1lsg.d_buyer.buyer_cd buyer_cd

-- =============================
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
This plan generates a flat dimension table for d_gl_acct.
All fields are directly mapped from the source table e1lsg.d_gl_acct.
**************************************************************************/

-- Query: d_gl_acct_transformation
-- Pattern: dimension_flat
-- Coverage: 15 rows

SELECT
  dga.gl_acct_id AS gl_acct_id,
  dga.gl_acct_nm AS gl_acct_nm,
  dga.object_acct_cd AS object_acct_cd,
  dga.subsdry_cd AS subsdry_cd,
  dga.object_acct_subsdry_nm AS object_acct_subsdry_nm,
  dga.co_cd AS co_cd,
  dga.co_nm AS co_nm,
  dga.cost_center_branch_cd AS cost_center_branch_cd,
  dga.cost_center_branch_nm AS cost_center_branch_nm,
  dga.dtl_lvl_nbr AS dtl_lvl_nbr,
  dga.curncy_cd AS curncy_cd,
  dga.curncy_nm AS curncy_nm,
  dga.object_acct_type_cd AS object_acct_type_cd,
  dga.object_acct_cost_type_cd AS object_acct_cost_type_cd,
  dga.coa_id AS coa_id
FROM e1lsg.d_gl_acct.gl_acct_id dga

-- =============================
-- d_company_transformation
-- =============================
/**************************************************************************
Generated plan for d_company dimension table.
**************************************************************************/

-- Query: d_company_transformation
-- Pattern: dimension_flat
-- Coverage: 24 rows
-- WARNING: unresolved items: No source_table or source_field provided for any field in FIELD MAPPINGS.; No logic, default_val, or extracted_sql_use_verbatim provided for any field.

SELECT
  CAST(NULL AS string) AS src_sys_cd,
  CAST(NULL AS string) AS co_key,
  CAST(NULL AS string) AS co_cd,
  CAST(NULL AS string) AS co_nm,
  CAST(NULL AS string) AS co_curncy_cd,
  CAST(NULL AS string) AS co_curncy_nm,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  CAST(NULL AS string) AS cntry_cd,
  CAST(NULL AS string) AS cntry_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CAST(NULL AS string) AS hfm_entity_cd,
  CAST(NULL AS string) AS hfm_entity_key,
  CAST(NULL AS string) AS dw_src_key,
  CAST(NULL AS string) AS city_nm,
  CAST(NULL AS string) AS group_nm,
  CAST(NULL AS string) AS rec_crt_ts,
  CAST(NULL AS string) AS rec_updt_ts
FROM <source> t

-- =============================
-- d_org_unit_transformation
-- =============================
/**************************************************************************
Universal Plan for d_org_unit dimension table
Flat dimension pattern with direct mappings
**************************************************************************/

-- Query: d_org_unit_transformation
-- Pattern: dimension_flat
-- Coverage: 25 rows

SELECT
  d.org_unit_cd AS org_unit_cd,
  d.org_unit_type AS org_unit_type,
  d.org_unit_nm AS org_unit_nm,
  d.parent_org_unit_cd AS parent_org_unit_cd,
  d.parent_org_unit_nm AS parent_org_unit_nm,
  d.lang_cd AS lang_cd,
  d.lang_iso_cd AS lang_iso_cd,
  d.lang_nm AS lang_nm,
  d.co_cd AS co_cd,
  d.co_nm AS co_nm,
  d.curncy_cd AS curncy_cd,
  d.curncy_nm AS curncy_nm,
  d.co_curncy_cd AS co_curncy_cd,
  d.co_curncy_nm AS co_curncy_nm,
  d.street_nm AS street_nm,
  d.city_nm AS city_nm,
  d.st_prov_cd AS st_prov_cd,
  d.st_prov_nm AS st_prov_nm,
  d.rgn_cd AS rgn_cd,
  d.rgn_nm AS rgn_nm,
  d.cntry_cd AS cntry_cd,
  d.cntry_nm AS cntry_nm,
  d.gbl_rgn_cd AS gbl_rgn_cd,
  d.gbl_rgn_nm AS gbl_rgn_nm,
  d.org_unit_cat_nm AS org_unit_cat_nm
FROM e1lsg.d_org_unit.org_unit_cd d

-- =============================
-- d_supplier_transformation
-- =============================
/**************************************************************************
Universal Plan for d_supplier dimension table
Flat dimension pattern with direct mappings
**************************************************************************/

-- Query: d_supplier_transformation
-- Pattern: dimension_flat
-- Coverage: 57 rows

SELECT
  src_sys_cd AS src_sys_cd,
  suplr_id AS suplr_id,
  alt_suplr_id AS alt_suplr_id,
  suplr_nm AS suplr_nm,
  lgl_suplr_nm AS lgl_suplr_nm,
  parent_suplr_nm AS parent_suplr_nm,
  prim_branch_cd AS prim_branch_cd,
  prim_branch_nm AS prim_branch_nm,
  dnb_co_nbr AS dnb_co_nbr,
  addr_crt_dt AS addr_crt_dt,
  suplr_addr_line_1 AS suplr_addr_line_1,
  suplr_addr_line_2 AS suplr_addr_line_2,
  suplr_addr_line_3 AS suplr_addr_line_3,
  suplr_addr_line_4 AS suplr_addr_line_4,
  suplr_pstl_cd AS suplr_pstl_cd,
  suplr_city_nm AS suplr_city_nm,
  suplr_st_cd AS suplr_st_cd,
  suplr_st_nm AS suplr_st_nm,
  suplr_rgn_cd AS suplr_rgn_cd,
  suplr_rgn_nm AS suplr_rgn_nm,
  suplr_cntry_cd AS suplr_cntry_cd,
  suplr_cntry_nm AS suplr_cntry_nm,
  addr_eff_dt AS addr_eff_dt,
  suplr_phn_area_cd AS suplr_phn_area_cd,
  suplr_phn_nbr AS suplr_phn_nbr,
  suplr_email_addr AS suplr_email_addr,
  suplr_dvrsty_cd AS suplr_dvrsty_cd,
  suplr_dvrsty_nm AS suplr_dvrsty_nm,
  suplr_class_cd AS suplr_class_cd,
  suplr_class_nm AS suplr_class_nm,
  suplr_indy_cd AS suplr_indy_cd,
  suplr_indy_nm AS suplr_indy_nm,
  suplr_type_cd AS suplr_type_cd,
  suplr_type_nm AS suplr_type_nm,
  paymt_terms_cd AS paymt_terms_cd,
  paymt_terms_nm AS paymt_terms_nm,
  suplr_rel_cd AS suplr_rel_cd,
  suplr_lang_cd AS suplr_lang_cd,
  suplr_lang_nm AS suplr_lang_nm,
  contract_id AS contract_id,
  contract_type_nm AS contract_type_nm,
  contract_stat_cd AS contract_stat_cd,
  contract_begin_dt AS contract_begin_dt,
  contract_end_dt AS contract_end_dt,
  cmdty_mgr_nm AS cmdty_mgr_nm,
  mthly_projctd_spend_amt AS mthly_projctd_spend_amt,
  mthly_projctd_saving_amt AS mthly_projctd_saving_amt,
  contract_comment_txt AS contract_comment_txt,
  frt_terms_cd AS frt_terms_cd,
  frt_terms_nm AS frt_terms_nm,
  inco_terms_cd AS inco_terms_cd,
  inco_terms_nm AS inco_terms_nm,
  suplr_assgn_grp_cd AS suplr_assgn_grp_cd,
  suplr_assgn_grp_nm AS suplr_assgn_grp_nm,
  suplr_active_flg AS suplr_active_flg,
  status_cd AS status_cd,
  norm_supplier_type AS norm_supplier_type
FROM src_sys_cd src

-- =============================
-- d_product_cost_transformation
-- =============================
/**************************************************************************
Generated plan for d_product_cost dimension table.
**************************************************************************/

-- Query: d_product_cost_transformation
-- Pattern: dimension_flat
-- Coverage: 23 rows
-- WARNING: unresolved items: Join conditions for F30026.IELITM, F30026.IECOST, and F30026.IESTDC are unclear. Placeholder 'some_column' used.

SELECT
  CAST(NULL AS string) AS co_curncy_cd,
  CAST(NULL AS string) AS cost_cntrl_ind,
  CAST(NULL AS decimal(10,3)) AS cost_unit_qty,
  CAST(NULL AS string) AS current_rec_flg,
  CAST(NULL AS decimal(19,8)) AS dir_labour_cost_amt,
  CAST(NULL AS decimal(12,0)) AS eff_end_yr_prd_nbr,
  CAST(NULL AS decimal(11,0)) AS eff_start_yr_prd_nbr,
  CAST(NULL AS decimal(19,8)) AS fix_oh_cost_amt,
  CAST(NULL AS decimal(11,0)) AS latest_cost_chng_dt,
  CAST(NULL AS decimal(26,6)) AS ma_cost_amt,
  CAST(NULL AS decimal(19,8)) AS mtl_cost_amt,
  CAST(NULL AS decimal(19,8)) AS other_svc_cost_amt,
  iemmcu.some_column AS plant_cd,
  iemmcu.some_column AS revision,
  iemmcu.some_column AS setup_labour_cost_amt,
  iemmcu.some_column AS sim_env,
  ielitm.some_column AS sku,
  'Fixed Value' AS src_sys_cd,
  iestdc.some_column AS std_cost_amt,
  iestdc.some_column AS std_cost_pmar_amt,
  iestdc.some_column AS unit_cost_amt,
  iecost.some_column AS val_class_cd,
  iecost.some_column AS val_class_nm
FROM F30026.IEMMCU iemmcu
LEFT JOIN F30026.IELITM ielitm ON iemmcu.some_column = ielitm.some_column
LEFT JOIN F30026.IECOST iecost ON iemmcu.some_column = iecost.some_column
LEFT JOIN F30026.IESTDC iestdc ON iemmcu.some_column = iestdc.some_column

-- =============================
-- d_branch_transformation
-- =============================
/**************************************************************************
Generated plan for d_branch dimension table.
**************************************************************************/

-- Query: d_branch_transformation
-- Pattern: dimension_flat
-- Coverage: 26 rows
-- WARNING: unresolved items: org_unit_type: Source table 'Not Available' is not resolvable.; cntry_cd, cntry_nm, curncy_cd, curncy_nm, st_prov_cd, st_prov_nm: No source or logic provided.

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
FROM E1 e1
LEFT JOIN (SELECT ABALPH, ABAN8 FROM F0101 WHERE ABAN8 = F41001.CIAN8) f0101 ON f0101.ABAN8 = f41001.CIAN8
LEFT JOIN F41001 f41001 ON f41001.CIMCU IS NOT NULL
