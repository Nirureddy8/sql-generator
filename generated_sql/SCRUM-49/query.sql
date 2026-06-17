-- Databricks notebook source
-- Generated for: SCRUM-49
-- Merged from multiple query sources
--
-- Query 1: 2.2_transformation
--   Purpose: Transform and load data into 2.2
-- Query 2: 2.6_transformation
--   Purpose: Transform and load data into 2.6
-- Query 3: 2.7_transformation
--   Purpose: Transform and load data into 2.7
-- Query 4: 2.3_transformation
--   Purpose: Transform and load data into 2.3
-- Query 5: 2.5_transformation
--   Purpose: Transform and load data into 2.5
-- Query 6: 2.4_transformation
--   Purpose: Transform and load data into 2.4
-- Query 7: 2.12_transformation
--   Purpose: Transform and load data into 2.12
-- Query 8: 2.8_transformation
--   Purpose: Transform and load data into 2.8
-- Query 9: 2.9_transformation
--   Purpose: Transform and load data into 2.9
-- Query 10: 2.11_transformation
--   Purpose: Transform and load data into 2.11
-- Query 11: 2.10_transformation
--   Purpose: Transform and load data into 2.10
-- Query 12: Table_name_transformation
--   Purpose: Transform and load data into Table_name
-- Query 13: d_product_transformation
--   Purpose: Transform and load data into d_product
-- Query 14: table_name_transformation
--   Purpose: Transform and load data into table_name
-- Query 15: d_branch_transformation
--   Purpose: Transform and load data into d_branch
-- Query 16: d_buyer_transformation
--   Purpose: Transform and load data into d_buyer
-- Query 17: d_gl_acct_transformation
--   Purpose: Transform and load data into d_gl_acct
-- Query 18: d_company_transformation
--   Purpose: Transform and load data into d_company
-- Query 19: d_product_cost_transformation
--   Purpose: Transform and load data into d_product_cost
-- Query 20: d_product_plant_transformation
--   Purpose: Transform and load data into d_product_plant
-- Query 21: f_purchase_order_transformation
--   Purpose: Transform and load data into f_purchase_order
-- Query 22: d_suppplier_transformation
--   Purpose: Transform and load data into d_suppplier
-- Query 23: f_po_receipt_transformation
--   Purpose: Transform and load data into f_po_receipt
-- Query 24: f_supplier_invoice_transformation
--   Purpose: Transform and load data into f_supplier_invoice
--

WITH 2_2_transformation as (
-- Query: 2.2_transformation
-- Purpose: Transform and load data into '2.2'
-- Query Type: SELECT

WITH
  _source_2_2_0 AS (
SELECT
  d_branch.org_unit_cd AS org_unit_cd
FROM d_branch
  ),
  _transformed AS (
  SELECT
    org_unit_cd AS org_unit_cd
  FROM _source_2_2_0
  )
SELECT * FROM _transformed
),
2_6_transformation as (
-- Query: 2.6_transformation
-- Purpose: Transform and load data into '2.6'
-- Query Type: SELECT

WITH
  _source_2_6_0 AS (
SELECT
  d_branch.parent_org_unit_nm AS parent_org_unit_nm
FROM d_branch
  ),
  _transformed AS (
  SELECT
    parent_org_unit_nm AS parent_org_unit_nm
  FROM _source_2_6_0
  )
SELECT * FROM _transformed
),
2_7_transformation as (
-- Query: 2.7_transformation
-- Purpose: Transform and load data into '2.7'
-- Query Type: SELECT

WITH
  _source_2_7_0 AS (
SELECT
  d_branch.curncy_cd AS curncy_cd
FROM d_branch
  ),
  _transformed AS (
  SELECT
    curncy_cd AS curncy_cd
  FROM _source_2_7_0
  )
SELECT * FROM _transformed
),
2_3_transformation as (
-- Query: 2.3_transformation
-- Purpose: Transform and load data into '2.3'
-- Query Type: SELECT

WITH
  _source_2_3_0 AS (
SELECT
  d_branch.org_unit_nm AS org_unit_nm
FROM d_branch
  ),
  _transformed AS (
  SELECT
    org_unit_nm AS org_unit_nm
  FROM _source_2_3_0
  )
SELECT * FROM _transformed
),
2_5_transformation as (
-- Query: 2.5_transformation
-- Purpose: Transform and load data into '2.5'
-- Query Type: SELECT

WITH
  _source_2_5_0 AS (
SELECT
  d_branch.parent_org_unit_cd AS parent_org_unit_cd
FROM d_branch
  ),
  _transformed AS (
  SELECT
    parent_org_unit_cd AS parent_org_unit_cd
  FROM _source_2_5_0
  )
SELECT * FROM _transformed
),
2_4_transformation as (
-- Query: 2.4_transformation
-- Purpose: Transform and load data into '2.4'
-- Query Type: SELECT

WITH
  _source_2_4_0 AS (
SELECT
  d_branch.org_unit_type AS org_unit_type
FROM d_branch
  ),
  _transformed AS (
  SELECT
    org_unit_type AS org_unit_type
  FROM _source_2_4_0
  )
SELECT * FROM _transformed
),
2_12_transformation as (
-- Query: 2.12_transformation
-- Purpose: Transform and load data into '2.12'
-- Query Type: SELECT

WITH
  _source_2_12_0 AS (
SELECT
  d_branch.cntry_nm AS cntry_nm
FROM d_branch
  ),
  _transformed AS (
  SELECT
    cntry_nm AS cntry_nm
  FROM _source_2_12_0
  )
SELECT * FROM _transformed
),
2_8_transformation as (
-- Query: 2.8_transformation
-- Purpose: Transform and load data into '2.8'
-- Query Type: SELECT

WITH
  _source_2_8_0 AS (
SELECT
  d_branch.curncy_nm AS curncy_nm
FROM d_branch
  ),
  _transformed AS (
  SELECT
    curncy_nm AS curncy_nm
  FROM _source_2_8_0
  )
SELECT * FROM _transformed
),
2_9_transformation as (
-- Query: 2.9_transformation
-- Purpose: Transform and load data into '2.9'
-- Query Type: SELECT

WITH
  _source_2_9_0 AS (
SELECT
  d_branch.st_prov_cd AS st_prov_cd
FROM d_branch
  ),
  _transformed AS (
  SELECT
    st_prov_cd AS st_prov_cd
  FROM _source_2_9_0
  )
SELECT * FROM _transformed
),
2_11_transformation as (
-- Query: 2.11_transformation
-- Purpose: Transform and load data into '2.11'
-- Query Type: SELECT

WITH
  _source_2_11_0 AS (
SELECT
  d_branch.cntry_cd AS cntry_cd
FROM d_branch
  ),
  _transformed AS (
  SELECT
    cntry_cd AS cntry_cd
  FROM _source_2_11_0
  )
SELECT * FROM _transformed
),
2_10_transformation as (
-- Query: 2.10_transformation
-- Purpose: Transform and load data into '2.10'
-- Query Type: SELECT

WITH
  _source_2_10_0 AS (
SELECT
  d_branch.st_prov_nm AS st_prov_nm
FROM d_branch
  ),
  _transformed AS (
  SELECT
    st_prov_nm AS st_prov_nm
  FROM _source_2_10_0
  )
SELECT * FROM _transformed
),
table_name_transformation as (
-- Query: Table_name_transformation
-- Purpose: Transform and load data into 'Table_name'
-- Query Type: SELECT

WITH
  _source_table_name_0 AS (
SELECT
  buyer_cd AS buyer_cd,
  gl_acct_id AS gl_acct_id,
  po_type_cd AS po_type_cd,
  po_line_nbr AS po_line_nbr
FROM <source>
  ),
  _transformed AS (
  SELECT
    buyer_cd AS buyer_cd,
    gl_acct_id AS gl_acct_id,
    po_type_cd AS po_type_cd,
    po_line_nbr AS po_line_nbr
  FROM _source_table_name_0
  )
SELECT * FROM _transformed
),
d_product_transformation as (
-- Query: d_product_transformation
-- Purpose: Transform and load data into 'd_product'
-- Query Type: SELECT

WITH
  _source_d_product_1 AS (
-- UNMAPPED TABLE: d_product
-- All rows in this chunk are unmapped. No valid target_field or transformation logic provided.
  )
SELECT * FROM _transformed
),
table_name_transformation as (
-- Query: table_name_transformation
-- Purpose: Transform and load data into 'table_name'
-- Query Type: SELECT

WITH
  _source_table_name_0 AS (
SELECT
  org_unit_nm AS org_unit_nm,
  co_cd AS co_cd,
  plant_key AS plant_key,
  plant_cd AS plant_cd,
  suplr_id AS suplr_id,
  po_line_nbr AS po_line_nbr
FROM <source>
  ),
  _transformed AS (
  SELECT
    org_unit_nm AS org_unit_nm,
    co_cd AS co_cd,
    plant_key AS plant_key,
    plant_cd AS plant_cd,
    suplr_id AS suplr_id,
    po_line_nbr AS po_line_nbr
  FROM _source_table_name_0
  )
SELECT * FROM _transformed
),
d_branch_transformation as (
-- Query: d_branch_transformation
-- Purpose: Transform and load data into 'd_branch'
-- Query Type: SELECT

WITH
  _source_d_branch_1 AS (
-- UNMAPPED TABLE: d_branch
-- All rows in this chunk are unmapped. No valid target_field or logic provided.
  )
SELECT * FROM _transformed
),
d_buyer_transformation as (
-- Query: d_buyer_transformation
-- Purpose: Transform and load data into 'd_buyer'
-- Query Type: SELECT

WITH
  _source_d_buyer_0 AS (
-- UNMAPPED TABLE: d_buyer
-- All fields in this chunk are unmapped or invalid.
SELECT
  CAST(NULL AS STRING) AS src_sys_cd,
  CAST(NULL AS STRING) AS buyer_cd
WHERE 1 = 0
  ),
  _transformed AS (
  SELECT
    src_sys_cd AS src_sys_cd,
    buyer_cd AS buyer_cd
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
  CAST(NULL AS STRING) AS src_sys_cd,
  CAST(NULL AS STRING) AS gl_acct_id
WHERE 1 = 0
  ),
  _transformed AS (
  SELECT
    src_sys_cd AS src_sys_cd,
    gl_acct_id AS gl_acct_id
  FROM _source_d_gl_acct_0
  )
SELECT * FROM _transformed
),
d_company_transformation as (
-- Query: d_company_transformation
-- Purpose: Transform and load data into 'd_company'
-- Query Type: SELECT

WITH
  _source_d_company_1 AS (
SELECT
  ZGB1 AS ZGB1,
  NL20 AS NL20,
  AU30 AS AU30,
  COPY AS COPY,
  DE30 AS DE30,
  DK10 AS DK10,
  IT20 AS IT20,
  ZBR1 AS ZBR1,
  TH10 AS TH10,
  ZHK1 AS ZHK1,
  FR10 AS FR10,
  NL30 AS NL30,
  SG10 AS SG10,
  USF5 AS USF5
FROM <source>
WHERE src_sys_cd IS NOT NULL AND co_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    ZGB1 AS ZGB1,
    NL20 AS NL20,
    AU30 AS AU30,
    COPY AS COPY,
    DE30 AS DE30,
    DK10 AS DK10,
    IT20 AS IT20,
    ZBR1 AS ZBR1,
    TH10 AS TH10,
    ZHK1 AS ZHK1,
    FR10 AS FR10,
    NL30 AS NL30,
    SG10 AS SG10,
    USF5 AS USF5
  FROM _source_d_company_1
  )
SELECT * FROM _transformed
),
d_product_cost_transformation as (
-- Query: d_product_cost_transformation
-- Purpose: Transform and load data into 'd_product_cost'
-- Query Type: SELECT

WITH
  _source_d_product_cost_1 AS (
SELECT
  CAST(NULL AS STRING) AS gb11,
  CAST(NULL AS STRING) AS kr21,
  CAST(NULL AS STRING) AS kr21_duplicate,
  CAST(NULL AS STRING) AS us21,
  CAST(NULL AS STRING) AS pt11,
  CAST(NULL AS STRING) AS em11,
  CAST(NULL AS STRING) AS gb21,
  CAST(NULL AS STRING) AS se11,
  CAST(NULL AS STRING) AS sk11,
  CAST(NULL AS STRING) AS au31,
  CAST(NULL AS STRING) AS nl71,
  CAST(NULL AS STRING) AS us21_duplicate,
  CAST(NULL AS STRING) AS is11,
  CAST(NULL AS STRING) AS es11,
  CAST(NULL AS STRING) AS gb1,
  CAST(NULL AS STRING) AS us27,
  CAST(NULL AS STRING) AS be11,
  CAST(NULL AS STRING) AS us21_triplicate,
  CAST(NULL AS STRING) AS tw21,
  CAST(NULL AS STRING) AS dk11
FROM (SELECT 1) AS dummy_source
  ),
  _transformed AS (
  SELECT
    gb11 AS gb11,
    kr21 AS kr21,
    kr21_duplicate AS kr21_duplicate,
    us21 AS us21,
    pt11 AS pt11,
    em11 AS em11,
    gb21 AS gb21,
    se11 AS se11,
    sk11 AS sk11,
    au31 AS au31,
    nl71 AS nl71,
    us21_duplicate AS us21_duplicate,
    is11 AS is11,
    es11 AS es11,
    gb1 AS gb1,
    us27 AS us27,
    be11 AS be11,
    us21_triplicate AS us21_triplicate,
    tw21 AS tw21,
    dk11 AS dk11
  FROM _source_d_product_cost_1
  )
SELECT * FROM _transformed
),
d_product_plant_transformation as (
-- Query: d_product_plant_transformation
-- Purpose: Transform and load data into 'd_product_plant'
-- Query Type: SELECT

WITH
  _source_d_product_plant_1 AS (
SELECT
  saplsg.CA41 AS plant,
  saplsg.AT11 AS plant,
  saplsg.NL21 AS plant,
  saplsg.1EU1 AS plant,
  saplsg.IS11 AS plant,
  saplsg.US22 AS plant,
  saplsg.NL71 AS plant,
  saplsg.1GB1 AS plant,
  saplsg.TH11 AS plant,
  saplsg.SE11 AS plant,
  saplsg.PT11 AS plant,
  saplsg.CH61 AS plant,
  saplsg.ES11 AS plant,
  saplsg.FR11 AS plant,
  saplsg.FI11 AS plant,
  saplsg.BE11 AS plant,
  saplsg.SG31 AS plant,
  saplsg.BR11 AS plant,
  saplsg.1NL1 AS plant,
  saplsg.SG31 AS plant
FROM saplsg
WHERE saplsg.CA41 IS NOT NULL AND saplsg.AT11 IS NOT NULL AND saplsg.NL21 IS NOT NULL AND saplsg.1EU1 IS NOT NULL AND saplsg.IS11 IS NOT NULL AND saplsg.US22 IS NOT NULL AND saplsg.NL71 IS NOT NULL AND saplsg.1GB1 IS NOT NULL AND saplsg.TH11 IS NOT NULL AND saplsg.SE11 IS NOT NULL AND saplsg.PT11 IS NOT NULL AND saplsg.CH61 IS NOT NULL AND saplsg.ES11 IS NOT NULL AND saplsg.FR11 IS NOT NULL AND saplsg.FI11 IS NOT NULL AND saplsg.BE11 IS NOT NULL AND saplsg.SG31 IS NOT NULL AND saplsg.BR11 IS NOT NULL AND saplsg.1NL1 IS NOT NULL AND saplsg.SG31 IS NOT NULL
  ),
  _transformed AS (
  SELECT
    plant AS plant
  FROM _source_d_product_plant_1
  )
SELECT * FROM _transformed
),
f_purchase_order_transformation as (
-- Query: f_purchase_order_transformation
-- Purpose: Transform and load data into 'f_purchase_order'
-- Query Type: SELECT

WITH
  _source_f_purchase_order_1 AS (
-- UNMAPPED TABLE: f_purchase_order
-- All rows in this chunk are missing target_field_name or valid source_field references.
  )
SELECT * FROM _transformed
),
d_suppplier_transformation as (
-- Query: d_suppplier_transformation
-- Purpose: Transform and load data into 'd_suppplier'
-- Query Type: SELECT

WITH
  _source_d_suppplier_0 AS (
-- UNMAPPED TABLE: d_suppplier
-- All rows in this chunk are unmapped or invalid.
SELECT
  CAST(NULL AS STRING) AS unmapped_field
WHERE FALSE
  )
SELECT * FROM _transformed
),
f_po_receipt_transformation as (
-- Query: f_po_receipt_transformation
-- Purpose: Transform and load data into 'f_po_receipt'
-- Query Type: SELECT

WITH
  _source_f_po_receipt_0 AS (
-- UNMAPPED TABLE: f_po_receipt
-- All rows in this chunk are missing target_field_name or valid source_field references.
  )
SELECT * FROM _transformed
),
f_supplier_invoice_transformation as (
-- Query: f_supplier_invoice_transformation
-- Purpose: Transform and load data into 'f_supplier_invoice'
-- Query Type: SELECT

WITH
  _source_f_supplier_invoice_0 AS (
-- TODO: PARSER ERROR: All fields in this chunk are unmapped or invalid
SELECT
  CAST(NULL AS STRING) AS unmapped_field
WHERE FALSE
  )
SELECT * FROM _transformed
)
SELECT * FROM 2_2_transformation UNION ALL
SELECT * FROM 2_6_transformation UNION ALL
SELECT * FROM 2_7_transformation UNION ALL
SELECT * FROM 2_3_transformation UNION ALL
SELECT * FROM 2_5_transformation UNION ALL
SELECT * FROM 2_4_transformation UNION ALL
SELECT * FROM 2_12_transformation UNION ALL
SELECT * FROM 2_8_transformation UNION ALL
SELECT * FROM 2_9_transformation UNION ALL
SELECT * FROM 2_11_transformation UNION ALL
SELECT * FROM 2_10_transformation UNION ALL
SELECT * FROM table_name_transformation UNION ALL
SELECT * FROM d_product_transformation UNION ALL
SELECT * FROM table_name_transformation UNION ALL
SELECT * FROM d_branch_transformation UNION ALL
SELECT * FROM d_buyer_transformation UNION ALL
SELECT * FROM d_gl_acct_transformation UNION ALL
SELECT * FROM d_company_transformation UNION ALL
SELECT * FROM d_product_cost_transformation UNION ALL
SELECT * FROM d_product_plant_transformation UNION ALL
SELECT * FROM f_purchase_order_transformation UNION ALL
SELECT * FROM d_suppplier_transformation UNION ALL
SELECT * FROM f_po_receipt_transformation UNION ALL
SELECT * FROM f_supplier_invoice_transformation