-- Databricks notebook source
-- Generated for: SCRUM-50
-- Merged from multiple query sources
--
-- Query 1: d_branch_transformation
--   Purpose: Transform and load data into d_branch
-- Query 2: d_buyer_transformation
--   Purpose: Transform and load data into d_buyer
-- Query 3: d_gl_acct_transformation
--   Purpose: Transform and load data into d_gl_acct
--

WITH d_branch_transformation as (
-- Query: d_branch_transformation
-- Purpose: Transform and load data into 'd_branch'
-- Query Type: SELECT

WITH
  _source_d_branch_0 AS (
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
  CAST(NULL AS string) AS st_prov_nm
FROM t1
  ),
  _source_d_branch_1 AS (
SELECT
  t1.c1 AS src_sys_cd
FROM t1
  ),
  _source_d_branch_2 AS (
SELECT
  t2.c2 AS org_unit_cd
FROM t2
  ),
  _source_d_branch_3 AS (
SELECT
  t3.c3 AS org_unit_nm
FROM t3
  ),
  _source_d_branch_4 AS (
SELECT
  t4.c4 AS org_unit_type
FROM t4
  ),
  _source_d_branch_5 AS (
SELECT
  t5.c5 AS parent_org_unit_cd
FROM t5
  ),
  _source_d_branch_6 AS (
SELECT
  t6.c6 AS parent_org_unit_nm
FROM t6
  ),
  _source_d_branch_7 AS (
SELECT
  t7.c7 AS curncy_cd
FROM t7
  ),
  _source_d_branch_8 AS (
SELECT
  t8.c8 AS curncy_nm
FROM t8
  ),
  _source_d_branch_9 AS (
SELECT
  t9.c9 AS st_prov_cd
FROM t9
  ),
  _source_d_branch_10 AS (
SELECT
  t10.c10 AS st_prov_nm
FROM t10
  ),
  _source_d_branch_11 AS (
SELECT
  t11.c11 AS cntry_cd
FROM t11
  ),
  _source_d_branch_12 AS (
SELECT
  t12.c12 AS cntry_nm
FROM t12
  ),
  _source_d_branch_13 AS (
SELECT
  t13.c13 AS rec_crt_ts
FROM t13
  ),
  _source_d_branch_14 AS (
SELECT
  t14.c14 AS rec_updt_ts
FROM t14
  ),
  _transformed AS (
  SELECT
    cntry_cd AS cntry_cd,
    cntry_nm AS cntry_nm,
    curncy_cd AS curncy_cd,
    curncy_nm AS curncy_nm,
    org_unit_cd AS org_unit_cd,
    org_unit_nm AS org_unit_nm,
    org_unit_type AS org_unit_type,
    parent_org_unit_cd AS parent_org_unit_cd,
    parent_org_unit_nm AS parent_org_unit_nm,
    src_sys_cd AS src_sys_cd,
    st_prov_cd AS st_prov_cd,
    st_prov_nm AS st_prov_nm,
    rec_crt_ts AS rec_crt_ts,
    rec_updt_ts AS rec_updt_ts
  FROM _source_d_branch_14
  )
SELECT * FROM _transformed
),
d_buyer_transformation as (
-- Query: d_buyer_transformation
-- Purpose: Transform and load data into 'd_buyer'
-- Query Type: SELECT

WITH
  _source_d_buyer_0 AS (
SELECT
  'Fixed Value' AS src_sys_cd,
  F4102.IBBUYR AS buyer_cd,
  F0101.ABALPH AS buyer_nm
FROM F4102
LEFT JOIN F0101 ON F0101.ABAN8 = F4102.IBBUYR
  ),
  _transformed AS (
  SELECT
    src_sys_cd AS src_sys_cd,
    buyer_cd AS buyer_cd,
    buyer_nm AS buyer_nm
  FROM _source_d_buyer_0
  )
SELECT * FROM _transformed
),
d_gl_acct_transformation as (
-- Query: d_gl_acct_transformation
-- Purpose: Transform and load data into 'd_gl_acct'
-- Query Type: SELECT

WITH
  _source_d_gl_acct_0 AS (
SELECT
  'Fixed Value' AS src_sys_cd,
  F0901.GMAID AS gl_acct_id,
  F0901.GMDL01 AS gl_acct_nm,
  F0901.GMOBJ AS object_acct_cd,
  F0901.GMSUB AS subsdry_cd,
  CAST(NULL AS string) AS object_acct_subsdry_nm,
  F0901.GMCO AS co_cd,
  F0010.CCNAME AS co_nm,
  CAST(NULL AS string) AS cost_center_branch_cd,
  CAST(NULL AS string) AS cost_center_branch_nm,
  CAST(NULL AS string) AS dtl_lvl_nbr,
  F0901.GMCRCD AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS object_acct_type_cd,
  CAST(NULL AS string) AS object_acct_cost_type_cd,
  CAST(NULL AS string) AS coa_id
FROM F0901
LEFT JOIN F0010 ON F0901.GMCO = F0010.CO
  ),
  _transformed AS (
  SELECT
    src_sys_cd AS src_sys_cd,
    gl_acct_id AS gl_acct_id,
    gl_acct_nm AS gl_acct_nm,
    object_acct_cd AS object_acct_cd,
    subsdry_cd AS subsdry_cd,
    object_acct_subsdry_nm AS object_acct_subsdry_nm,
    co_cd AS co_cd,
    co_nm AS co_nm,
    cost_center_branch_cd AS cost_center_branch_cd,
    cost_center_branch_nm AS cost_center_branch_nm,
    dtl_lvl_nbr AS dtl_lvl_nbr,
    curncy_cd AS curncy_cd,
    curncy_nm AS curncy_nm,
    object_acct_type_cd AS object_acct_type_cd,
    object_acct_cost_type_cd AS object_acct_cost_type_cd,
    coa_id AS coa_id
  FROM _source_d_gl_acct_0
  )
SELECT * FROM _transformed
)
SELECT * FROM d_branch_transformation UNION ALL
SELECT * FROM d_buyer_transformation UNION ALL
SELECT * FROM d_gl_acct_transformation