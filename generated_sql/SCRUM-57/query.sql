-- Databricks notebook source
-- Generated for: SCRUM-57
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 3: d_product_cost_transformation
--   Pattern: dimension_flat
-- Query 4: d_branch_transformation
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
-- WARNING: unresolved items: Row d_buyer::2: No source_field or logic provided for buyer_nm. Defaulted to CAST(NULL AS string).

SELECT
  e1lsg.d_buyer.buyer_cd AS buyer_cd,
  CAST(NULL AS string) AS buyer_nm
FROM e1lsg.d_buyer.buyer_cd buyer_cd

-- =============================
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
Generated plan for d_gl_acct dimension table.
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
-- d_product_cost_transformation
-- =============================
/**************************************************************************
Generated plan for d_product_cost dimension table.
**************************************************************************/

-- Query: d_product_cost_transformation
-- Pattern: dimension_flat
-- Coverage: 23 rows
-- WARNING: unresolved items: Join conditions for F30026.IEMMCU to F30026.IECOST, F30026.IELITM, and F30026.IESTDC are unclear.; Source fields for many columns are not provided.

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
LEFT JOIN F30026.IECOST iecost ON iemmcu.some_column = iecost.some_column
LEFT JOIN F30026.IELITM ielitm ON iemmcu.some_column = ielitm.some_column
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
-- WARNING: unresolved items: org_unit_type source is 'Not Available', unable to map.; cntry_cd and cntry_nm have no source or logic provided.; curncy_cd and curncy_nm have no source or logic provided.

SELECT
  t11 AS cntry_cd,
  t12 AS cntry_nm,
  t7 AS curncy_cd,
  t8 AS curncy_nm,
  t2 AS org_unit_cd,
  t3 AS org_unit_nm,
  t4 AS org_unit_type,
  t5 AS parent_org_unit_cd,
  t6 AS parent_org_unit_nm,
  t1 AS src_sys_cd,
  t9 AS st_prov_cd,
  t10 AS st_prov_nm,
  t1 AS src_sys_cd,
  t2 AS org_unit_cd,
  t3 AS org_unit_nm,
  t4 AS org_unit_type,
  t5 AS parent_org_unit_cd,
  t6 AS parent_org_unit_nm,
  t7 AS curncy_cd,
  t8 AS curncy_nm,
  t9 AS st_prov_cd,
  t10 AS st_prov_nm,
  t11 AS cntry_cd,
  t12 AS cntry_nm,
  t13 AS rec_crt_ts,
  t14 AS rec_updt_ts
FROM E1 e1
LEFT JOIN F41001 f41001 ON e1.cimcu = f41001.cimcu
LEFT JOIN F0101 f0101 ON f0101.aban8 = f41001.cian8
