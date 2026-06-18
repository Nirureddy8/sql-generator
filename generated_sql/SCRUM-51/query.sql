-- ============================================================
-- Query     : 2.4_transformation
-- Table Type: UNKNOWN
-- Purpose   : Transform and load data into '2.4'
-- ============================================================
WITH
  _source AS (
    SELECT
      'Site use' AS org_unit_type
  ),
  _transformed AS (
    SELECT
      CAST(NULL AS STRING) AS d_branch
    FROM   _source
  )
SELECT * FROM _transformed;