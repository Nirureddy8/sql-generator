-- Databricks notebook source
-- Generated for: SCRUM-54
-- Universal Plan Schema generation
--
-- Query 1: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 2: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 3: d_product_cost_transformation
--   Pattern: dimension_flat
-- Query 4: d_org_unit_transformation
--   Pattern: dimension_flat
-- Query 5: d_branch_transformation
--   Pattern: dimension_flat
-- Query 6: d_supplier_transformation
--   Pattern: dimension_flat

-- =============================
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_gl_acct SQL
Description  :- Generate SQL for the d_gl_acct dimension table
**************************************************************************/

-- Query: d_gl_acct_transformation
-- Pattern: dimension_flat
-- Coverage: 15 rows

SELECT
  source.gl_acct_id AS gl_acct_id,
  source.gl_acct_nm AS gl_acct_nm,
  source.object_acct_cd AS object_acct_cd,
  source.subsdry_cd AS subsdry_cd,
  source.object_acct_subsdry_nm AS object_acct_subsdry_nm,
  source.co_cd AS co_cd,
  source.co_nm AS co_nm,
  source.cost_center_branch_cd AS cost_center_branch_cd,
  source.cost_center_branch_nm AS cost_center_branch_nm,
  source.dtl_lvl_nbr AS dtl_lvl_nbr,
  source.curncy_cd AS curncy_cd,
  source.curncy_nm AS curncy_nm,
  source.object_acct_type_cd AS object_acct_type_cd,
  source.object_acct_cost_type_cd AS object_acct_cost_type_cd,
  source.coa_id AS coa_id
FROM e1lsg.d_gl_acct source

-- =============================
-- d_buyer_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_buyer SQL
Description  :- Generate SQL for the d_buyer dimension table
**************************************************************************/

-- Query: d_buyer_transformation
-- Pattern: dimension_flat
-- Coverage: 2 rows

SELECT
  source.buyer_cd AS buyer_cd,
  source.buyer_nm AS buyer_nm
FROM e1lsg.d_buyer source

-- =============================
-- d_product_cost_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_product_cost SQL
Description  :- Generate SQL for the d_product_cost dimension table
**************************************************************************/

-- Query: d_product_cost_transformation
-- Pattern: dimension_flat
-- Coverage: 23 rows

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
  F30026.IEMMCU AS plant_cd,
  CAST(NULL AS string) AS revision,
  CAST(NULL AS decimal(19,8)) AS setup_labour_cost_amt,
  CAST(NULL AS string) AS sim_env,
  F30026.IELITM AS sku,
  'Fixed Value' AS src_sys_cd,
  F30026.IESTDC AS std_cost_amt,
  CAST(NULL AS decimal(19,8)) AS std_cost_pmar_amt,
  CAST(NULL AS decimal(28,8)) AS unit_cost_amt,
  F30026.IECOST AS val_class_cd,
  CAST(NULL AS string) AS val_class_nm
FROM F30026

-- =============================
-- d_org_unit_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_org_unit SQL
Description  :- Generate a flat dimension table for organizational units
**************************************************************************/

-- Query: d_org_unit_transformation
-- Pattern: dimension_flat
-- Coverage: 25 rows

SELECT
  d_org_unit.org_unit_cd AS org_unit_cd,
  d_org_unit.org_unit_type AS org_unit_type,
  d_org_unit.org_unit_nm AS org_unit_nm,
  d_org_unit.parent_org_unit_cd AS parent_org_unit_cd,
  d_org_unit.parent_org_unit_nm AS parent_org_unit_nm,
  d_org_unit.lang_cd AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  d_org_unit.co_cd AS co_cd,
  d_org_unit.co_nm AS co_nm,
  d_org_unit.curncy_cd AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  d_org_unit.co_curncy_cd AS co_curncy_cd,
  CAST(NULL AS string) AS co_curncy_nm,
  d_org_unit.street_nm AS street_nm,
  d_org_unit.city_nm AS city_nm,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  d_org_unit.cntry_cd AS cntry_cd,
  d_org_unit.cntry_nm AS cntry_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CAST(NULL AS string) AS org_unit_cat_nm
FROM e1lsg.d_org_unit d_org_unit

-- =============================
-- d_branch_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_branch SQL
Description  :- Generate a flat dimension table for branch details
**************************************************************************/

-- Query: d_branch_transformation
-- Pattern: dimension_flat
-- Coverage: 26 rows

SELECT
  t11.c11 AS cntry_cd,
  t12.c12 AS cntry_nm,
  t7.c7 AS curncy_cd,
  t8.c8 AS curncy_nm,
  t2.c2 AS org_unit_cd,
  t3.c3 AS org_unit_nm,
  t4.c4 AS org_unit_type,
  t5.c5 AS parent_org_unit_cd,
  t6.c6 AS parent_org_unit_nm,
  'E1' AS src_sys_cd,
  t9.c9 AS st_prov_cd,
  t10.c10 AS st_prov_nm,
  t13.c13 AS rec_crt_ts,
  t14.c14 AS rec_updt_ts
FROM t1 t1
LEFT JOIN t2 t2 ON t1.c1 = t2.c2
LEFT JOIN t3 t3 ON t1.c1 = t3.c3
LEFT JOIN t4 t4 ON t1.c1 = t4.c4
LEFT JOIN t5 t5 ON t1.c1 = t5.c5
LEFT JOIN t6 t6 ON t1.c1 = t6.c6
LEFT JOIN t7 t7 ON t1.c1 = t7.c7
LEFT JOIN t8 t8 ON t1.c1 = t8.c8
LEFT JOIN t9 t9 ON t1.c1 = t9.c9
LEFT JOIN t10 t10 ON t1.c1 = t10.c10
LEFT JOIN t11 t11 ON t1.c1 = t11.c11
LEFT JOIN t12 t12 ON t1.c1 = t12.c12
LEFT JOIN t13 t13 ON t1.c1 = t13.c13
LEFT JOIN t14 t14 ON t1.c1 = t14.c14

-- =============================
-- d_supplier_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_supplier SQL
Description  :- Generate SQL for the d_supplier dimension table
**************************************************************************/

-- Query: d_supplier_transformation
-- Pattern: dimension_flat
-- Coverage: 57 rows

SELECT
  d_supplier.src_sys_cd AS src_sys_cd,
  d_supplier.suplr_id AS suplr_id,
  d_supplier.alt_suplr_id AS alt_suplr_id,
  d_supplier.suplr_nm AS suplr_nm,
  d_supplier.lgl_suplr_nm AS lgl_suplr_nm,
  d_supplier.parent_suplr_nm AS parent_suplr_nm,
  d_supplier.prim_branch_cd AS prim_branch_cd,
  d_supplier.prim_branch_nm AS prim_branch_nm,
  d_supplier.dnb_co_nbr AS dnb_co_nbr,
  d_supplier.addr_crt_dt AS addr_crt_dt,
  d_supplier.suplr_addr_line_1 AS suplr_addr_line_1,
  d_supplier.suplr_addr_line_2 AS suplr_addr_line_2,
  d_supplier.suplr_addr_line_3 AS suplr_addr_line_3,
  d_supplier.suplr_addr_line_4 AS suplr_addr_line_4,
  d_supplier.suplr_pstl_cd AS suplr_pstl_cd,
  d_supplier.suplr_city_nm AS suplr_city_nm,
  d_supplier.suplr_st_cd AS suplr_st_cd,
  d_supplier.suplr_st_nm AS suplr_st_nm,
  d_supplier.suplr_rgn_cd AS suplr_rgn_cd,
  d_supplier.suplr_rgn_nm AS suplr_rgn_nm,
  d_supplier.suplr_cntry_cd AS suplr_cntry_cd,
  d_supplier.suplr_cntry_nm AS suplr_cntry_nm,
  d_supplier.addr_eff_dt AS addr_eff_dt,
  d_supplier.suplr_phn_area_cd AS suplr_phn_area_cd,
  d_supplier.suplr_phn_nbr AS suplr_phn_nbr,
  d_supplier.suplr_email_addr AS suplr_email_addr,
  d_supplier.suplr_dvrsty_cd AS suplr_dvrsty_cd,
  d_supplier.suplr_dvrsty_nm AS suplr_dvrsty_nm,
  d_supplier.suplr_class_cd AS suplr_class_cd,
  d_supplier.suplr_class_nm AS suplr_class_nm,
  d_supplier.suplr_indy_cd AS suplr_indy_cd,
  d_supplier.suplr_indy_nm AS suplr_indy_nm,
  d_supplier.suplr_type_cd AS suplr_type_cd,
  d_supplier.suplr_type_nm AS suplr_type_nm,
  d_supplier.paymt_terms_cd AS paymt_terms_cd,
  d_supplier.paymt_terms_nm AS paymt_terms_nm,
  d_supplier.suplr_rel_cd AS suplr_rel_cd,
  d_supplier.suplr_lang_cd AS suplr_lang_cd,
  d_supplier.suplr_lang_nm AS suplr_lang_nm,
  d_supplier.contract_id AS contract_id,
  d_supplier.contract_type_nm AS contract_type_nm,
  d_supplier.contract_stat_cd AS contract_stat_cd,
  d_supplier.contract_begin_dt AS contract_begin_dt,
  d_supplier.contract_end_dt AS contract_end_dt,
  d_supplier.cmdty_mgr_nm AS cmdty_mgr_nm,
  d_supplier.mthly_projctd_spend_amt AS mthly_projctd_spend_amt,
  d_supplier.mthly_projctd_saving_amt AS mthly_projctd_saving_amt,
  d_supplier.contract_comment_txt AS contract_comment_txt,
  d_supplier.frt_terms_cd AS frt_terms_cd,
  d_supplier.frt_terms_nm AS frt_terms_nm,
  d_supplier.inco_terms_cd AS inco_terms_cd,
  d_supplier.inco_terms_nm AS inco_terms_nm,
  d_supplier.suplr_assgn_grp_cd AS suplr_assgn_grp_cd,
  d_supplier.suplr_assgn_grp_nm AS suplr_assgn_grp_nm,
  d_supplier.suplr_active_flg AS suplr_active_flg,
  d_supplier.status_cd AS status_cd,
  d_supplier.norm_supplier_type AS norm_supplier_type
FROM e1lsg.d_supplier d_supplier
