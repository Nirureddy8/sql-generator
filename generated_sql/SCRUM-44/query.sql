-- ============================================================
-- Query     : d_branch_transformation
-- Table Type: DIMENSION
-- Purpose   : Transform and load data into 'd_branch'
-- ============================================================
WITH
  _source AS (
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
      t14.c14 AS rec_updt_ts,
      CAST(NULL AS STRING) AS id -- TODO: review column assignment
    FROM t1
    LEFT JOIN t2 ON ... -- TODO: confirm join conditions
    LEFT JOIN t3 ON ...
    LEFT JOIN t4 ON ...
    LEFT JOIN t5 ON ...
    LEFT JOIN t6 ON ...
    LEFT JOIN t7 ON ...
    LEFT JOIN t8 ON ...
    LEFT JOIN t9 ON ...
    LEFT JOIN t10 ON ...
    LEFT JOIN t11 ON ...
    LEFT JOIN t12 ON ...
    LEFT JOIN t13 ON ...
    LEFT JOIN t14 ON ...
  ),
  _scd AS (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM _source
  ),
  _transformed AS (
    SELECT
      cntry_cd,
      cntry_nm,
      curncy_cd,
      curncy_nm,
      org_unit_cd,
      org_unit_nm,
      org_unit_type,
      parent_org_unit_cd,
      parent_org_unit_nm,
      src_sys_cd,
      st_prov_cd,
      st_prov_nm,
      rec_crt_ts,
      rec_updt_ts,
      id
    FROM _scd
    WHERE _rn = 1
  )
SELECT * FROM _transformed;
