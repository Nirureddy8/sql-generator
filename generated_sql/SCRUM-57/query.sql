-- Databricks notebook source
-- Generated for: SCRUM-57
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 3: d_branch_transformation
--   Pattern: dimension_flat

-- =============================
-- d_buyer_transformation
-- =============================
/**************************************************************************
Generated plan for d_buyer dimension table
**************************************************************************/

-- Query: d_buyer_transformation
-- Pattern: dimension_flat
-- Coverage: 2 rows
-- WARNING: unresolved items: Row d_buyer::2: No source_field or logic provided for buyer_nm. Defaulting to CAST(NULL AS string).

SELECT
  YES AS buyer_cd,
  CAST(NULL AS string) AS buyer_nm
FROM e1lsg.d_buyer.buyer_cd t

-- =============================
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
Transformation plan for d_gl_acct dimension table.
**************************************************************************/

-- Query: d_gl_acct_transformation
-- Pattern: dimension_flat
-- Coverage: 15 rows

SELECT
  e1lsg.d_gl_acct.gl_acct_id AS gl_acct_id,
  e1lsg.d_gl_acct.gl_acct_nm AS gl_acct_nm,
  e1lsg.d_gl_acct.object_acct_cd AS object_acct_cd,
  e1lsg.d_gl_acct.subsdry_cd AS subsdry_cd,
  e1lsg.d_gl_acct.object_acct_subsdry_nm AS object_acct_subsdry_nm,
  e1lsg.d_gl_acct.co_cd AS co_cd,
  e1lsg.d_gl_acct.co_nm AS co_nm,
  e1lsg.d_gl_acct.cost_center_branch_cd AS cost_center_branch_cd,
  e1lsg.d_gl_acct.cost_center_branch_nm AS cost_center_branch_nm,
  e1lsg.d_gl_acct.dtl_lvl_nbr AS dtl_lvl_nbr,
  e1lsg.d_gl_acct.curncy_cd AS curncy_cd,
  e1lsg.d_gl_acct.curncy_nm AS curncy_nm,
  e1lsg.d_gl_acct.object_acct_type_cd AS object_acct_type_cd,
  e1lsg.d_gl_acct.object_acct_cost_type_cd AS object_acct_cost_type_cd,
  e1lsg.d_gl_acct.coa_id AS coa_id
FROM e1lsg.d_gl_acct.gl_acct_id gl_acct

-- =============================
-- d_branch_transformation
-- =============================
/**************************************************************************
Generated plan for d_branch dimension table.
**************************************************************************/

-- Query: d_branch_transformation
-- Pattern: dimension_flat
-- Coverage: 26 rows

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
  CAST(NULL AS string) AS src_sys_cd,
  CAST(NULL AS string) AS org_unit_cd,
  CAST(NULL AS string) AS org_unit_nm,
  CAST(NULL AS string) AS org_unit_type,
  CAST(NULL AS string) AS parent_org_unit_cd,
  CAST(NULL AS string) AS parent_org_unit_nm,
  CAST(NULL AS string) AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm,
  CAST(NULL AS string) AS cntry_cd,
  CAST(NULL AS string) AS cntry_nm,
  CAST(NULL AS string) AS rec_crt_ts,
  CAST(NULL AS string) AS rec_updt_ts
FROM CAST(NULL AS string) t
