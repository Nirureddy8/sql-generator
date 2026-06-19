-- Databricks notebook source
-- Generated for: SCRUM-63
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_branch_transformation
--   Pattern: dimension_flat
-- Query 3: f_po_receipt_transformation
--   Pattern: fact_union_dedup

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
Generated plan for d_branch dimension table
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
  t1.c1 AS src_sys_cd,
  t9.c9 AS st_prov_cd,
  t10.c10 AS st_prov_nm,
  t13.c13 AS rec_crt_ts,
  t14.c14 AS rec_updt_ts
FROM E1 e1
LEFT JOIN (SELECT ABALPH FROM F0101 WHERE ABAN8 = F41001.CIAN8) f0101 ON f0101.ABAN8 = f41001.CIAN8
LEFT JOIN F41001 f41001 ON f41001.CIMCU = e1.CIMCU

-- =============================
-- f_po_receipt_transformation
-- =============================
/**************************************************************************
This plan generates the f_po_receipt fact table.
It includes deduplication logic using ROW_NUMBER and joins for enrichment.
**************************************************************************/

-- Query: f_po_receipt_transformation
-- Pattern: fact_union_dedup
-- Coverage: 68 rows
-- WARNING: unresolved items: Some fields like warehouse_nm, buyer_id, and buyer_name lack clear source mappings.; prod_cost logic is missing and needs clarification.

WITH
po_receipt_unified AS (
  SELECT
    *,
    1 as src_priority
  FROM f43121 curr
  UNION ALL
  SELECT
    *,
    2 as src_priority
  FROM f43121_history hist
),
po_receipt_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY PRDOCO, PRLNID ORDER BY src_priority) AS rn FROM po_receipt_unified) x WHERE rn = 1
)

SELECT
  'Fixed Value' AS src_sys_cd,
  if(f43121.PRRCDJ > 0,substr(replace(cast(date_add(to_date(concat((cast(cast((cast(f43121.PRRCDJ as integer)/1000) as integer) +1900 as string)),'/01/01'),'yyyy/mm/dd'),((cast(f43121.PRRCDJ as integer)% 1000)-1)) as string),'-',''),1,6),'0') as recpt_date_period,
  cast(cast(fct.prdoco as integer) as string) AS po_nbr,
  cast(cast(fct.prlnid/1000 as integer) as string) AS po_line_nbr,
  cast(cast(fct.prdoc as integer) as string) AS recpt_nbr,
  cast(cast(fct.prlnid as integer) as string) AS recpt_line_seq_nbr,
  if(f43121.PRDGL > 0,substr(cast(date_add(to_date(concat((cast(cast((cast(f43121.PRDGL as integer)/1000) as integer) +1900 as string)),'/01/01'),'yyyy/mm/dd'),((cast(f43121.PRDGL as integer)% 1000)-1)) as string),1,4),'0') as recpt_yr_nbr,
  cast(fct.prkcoo as string) AS co_cd,
  cast(div.drky as string) AS co_name,
  cast(fct.prmcu as string) AS warehouse,
  CAST(NULL AS string) AS warehouse_nm,
  cast(trim(f43121.PRMCU) as string) as  site_cd,
  cast(trim(f43121.PRLITM) as string) as item_nbr,
  case when trim(f4101.IMDSC2)='' then f4101.IMDSC1 else f4101.IMDSC1||','||f4101.IMDSC2 end as item_desc,
  cast(cast(fct.pran8 as integer) as string) AS supplier_id,
  cast(sup.abalph as string) AS supplier_name,
  CAST(NULL AS string) AS buyer_id,
  CAST(NULL AS string) AS buyer_name,
  cast(fct.prbcrc as string) AS recpt_curncy_cd,
  CAST(NULL AS double) AS prod_cost,
  CAST(NULL AS STRING) AS po_curncy_cd,
  CAST(NULL AS STRING) AS co_curncy_cd,
  CAST(NULL AS STRING) AS recpt_date,
  CAST(NULL AS STRING) AS txn_date,
  CAST(NULL AS STRING) AS inv_loc,
  CAST(NULL AS STRING) AS div_cd,
  CAST(NULL AS STRING) AS profit_cntr,
  CAST(NULL AS DOUBLE) AS recpt_txn_qty,
  CAST(NULL AS DOUBLE) AS recpt_base_qty,
  CAST(NULL AS DOUBLE) AS ext_recpt_txn_amt,
  CAST(NULL AS DOUBLE) AS recpt_pmar_amt,
  CAST(NULL AS DOUBLE) AS ext_recpt_co_amt,
  CAST(NULL AS DOUBLE) AS recpt_co_pmar_amt,
  CAST(NULL AS STRING) AS recpt_type_cd,
  CAST(NULL AS STRING) AS txn_uom,
  CAST(NULL AS STRING) AS txn_uom_text,
  CAST(NULL AS STRING) AS base_uom,
  CAST(NULL AS STRING) AS base_uom_text,
  CAST(NULL AS STRING) AS purch_uom,
  CAST(NULL AS STRING) AS purch_uom_text,
  CAST(NULL AS STRING) AS po_line_type_cd,
  CAST(NULL AS STRING) AS promise_dt,
  CAST(NULL AS STRING) AS due_dt,
  CAST(NULL AS STRING) AS dock_dt,
  CAST(NULL AS STRING) AS match_typ_cd,
  CAST(NULL AS STRING) AS match_typ_desc,
  CAST(NULL AS STRING) AS delvr_cmplt_flg,
  CAST(NULL AS STRING) AS fk_orig,
  CAST(NULL AS STRING) AS rec_crt_ts,
  CAST(NULL AS STRING) AS rec_updt_ts,
  CAST(NULL AS STRING) AS hfm_entity,
  CAST(NULL AS STRING) AS business_unit,
  CAST(NULL AS INT) AS po_delivry_line_nbr,
  CAST(NULL AS STRING) AS ref_recpt_nbr,
  CAST(NULL AS STRING) AS ref_recpt_yr_nbr,
  CAST(NULL AS STRING) AS ref_recpt_line_seq_nbr,
  CAST(NULL AS STRING) AS floor_stock_cd,
  CAST(NULL AS STRING) AS suplr_paymt_terms_cd,
  CAST(NULL AS STRING) AS suplr_paymt_terms_desc,
  CAST(NULL AS STRING) AS contract_flag,
  CAST(NULL AS STRING) AS contract_type,
  CAST(NULL AS STRING) AS contract_start_date,
  CAST(NULL AS STRING) AS contract_end_date,
  CAST(NULL AS STRING) AS lcr_flag,
  CAST(NULL AS STRING) AS lcr_region,
  CAST(NULL AS STRING) AS spend_type_cd,
  CAST(NULL AS STRING) AS po_paymt_terms_cd,
  CAST(NULL AS STRING) AS vomi_flag
FROM po_receipt_dedup fct
LEFT JOIN f4101 itm ON fct.itm = itm.itm
LEFT JOIN f0101 sup ON fct.an8 = sup.an8
LEFT JOIN f0005 div ON trim(fct.mcu) = trim(div.drky)
WHERE fct.prdoco IS NOT NULL AND fct.prlnid IS NOT NULL
