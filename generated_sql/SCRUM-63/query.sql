-- Databricks notebook source
-- Generated for: SCRUM-63
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_branch_transformation
--   Pattern: dimension_flat

-- =============================
-- d_buyer_transformation
-- =============================
/**************************************************************************
Generated plan for d_buyer dimension table.
**************************************************************************/

-- Query: d_buyer_transformation
-- Pattern: dimension_flat
-- Coverage: 3 rows

SELECT
  'Fixed Value' AS src_sys_cd,
  f4102.ibbuyr AS buyer_cd,
  f0101.abalph AS buyer_nm
FROM fixed value f4102
LEFT JOIN f0101 f0101 ON f0101.aban8 = f4102.ibbuyr
WHERE f4102.ibbuyr IS NOT NULL

-- =============================
-- d_branch_transformation
-- =============================
/**************************************************************************
Generated plan for d_branch dimension table.
**************************************************************************/

-- Query: d_branch_transformation
-- Pattern: dimension_flat
-- Coverage: 26 rows
-- WARNING: unresolved items: No source_field or logic provided for cntry_cd, cntry_nm, curncy_cd, curncy_nm, org_unit_type, st_prov_cd, st_prov_nm in d_branch1 rows.

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
  t1.c1 AS src_sys_cd,
  t9.c9 AS st_prov_cd,
  t10.c10 AS st_prov_nm,
  t13.c13 AS rec_crt_ts,
  t14.c14 AS rec_updt_ts
FROM E1 e1
LEFT JOIN (SELECT ABAN8, ABALPH FROM F0101) AS f0101 f0101 ON f0101.ABAN8 = F41001.CIAN8
LEFT JOIN F41001 f41001 ON e1.CIMCU = f41001.CIMCU
