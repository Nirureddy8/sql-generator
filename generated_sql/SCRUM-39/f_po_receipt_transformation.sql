-- Query: f_po_receipt_transformation
-- Purpose: Transform and load data into f_po_receipt
-- Query Type: SELECT

-- Query: f_po_receipt_transformation
-- Purpose: Transform and load data into 'f_po_receipt'
-- Query Type: SELECT

WITH
  _source_f_po_receipt_0 AS (
SELECT
  sap_fct_po_receipt.CBU_QNT_UNIT AS base_uom,
  sap_fct_po_receipt.TBU_QNT_UNIT AS base_uom_text,
  sap_fct_po_receipt.CBUYER AS business_unit,
  sap_fct_po_receipt.CEMPL_RESP AS buyer_id,
  sap_fct_po_receipt.TEMPL_RESP AS buyer_name,
  sap_fct_po_receipt.CBUYER AS co_cd,
  sap_fct_po_receipt.CRC_NPRC_AMT_CUR AS co_curncy_cd,
  sap_fct_po_receipt.TBUYER AS co_name,
  date_format(date_add(to_date('1899-12-30'), cast(sap_fct_po_receipt.KCDEL_ST_DT as int)), 'yyyyMMdd') AS dock_dt,
  sap_fct_po_receipt.CITM_DLV_EDDT AS due_dt,
  sap_fct_po_receipt.KCRC_DLVD_AMT AS ext_recpt_co_amt,
  sap_fct_po_receipt.KCDLVD_AMT AS ext_recpt_txn_amt,
  sap_fct_po_receipt.TPRD_UUID AS item_desc,
  sap_fct_po_receipt.CITEM_ID AS item_nbr,
  sap_fct_po_receipt.CNET_PRC_AMT_CUR AS po_curncy_cd,
  sap_fct_po_receipt.CITEM_ID AS po_delivry_line_nbr,
  sap_fct_po_receipt.CREF_PO_ITEM_UUID AS po_line_nbr,
  sap_fct_po_receipt.CITM_TYPE AS po_line_type_cd,
  sap_fct_po_receipt.CREF_PO_UUID AS po_nbr,
  sap_fct_po_receipt.CCASHDIS_TERMSCD AS po_paymt_terms_cd,
  sap_fct_po_receipt.CBUYER AS profit_cntr,
  sap_fct_po_receipt.CITM_DLV_EDDT AS promise_dt,
  sap_fct_po_receipt.CNET_PRC_QTY_UNT AS purch_uom,
  sap_fct_po_receipt.TNET_PRC_QTY_UNT AS purch_uom_text,
  sap_fct_po_receipt.KCDLVD_QTY AS recpt_base_qty,
  sap_fct_po_receipt.RCRC_DLVD_AMT AS recpt_curncy_cd,
  sap_fct_po_receipt.CITM_DLV_EDDT AS recpt_date,
  sap_fct_po_receipt.CDELIVERY_YEAR_MONTH AS recpt_date_period,
  sap_fct_po_receipt.CITEM_ID AS recpt_line_seq_nbr,
  sap_fct_po_receipt.CDELIVERY_UUID AS recpt_nbr,
  "NONE" AS site_cd,
  CASE WHEN sap_fct_po_receipt.CITM_TYPE = 18 THEN 'Direct' ELSE 'Indirect' END AS spend_type_cd,
  sap_fct_po_receipt.CCSH_DSCNT_TRM AS suplr_paymt_terms_cd,
  sap_fct_po_receipt.TCSH_DSCNT_TRM AS suplr_paymt_terms_desc,
  sap_fct_po_receipt.CSELLER_UUID AS supplier_id,
  sap_fct_po_receipt.TSELLER_UUID AS supplier_name,
  sap_fct_po_receipt.CDELIVERY_DATE AS txn_date,
  sap_fct_po_receipt.CQUANTITY_UNIT AS txn_uom,
  sap_fct_po_receipt.TQUANTITY_UNIT AS txn_uom_text,
  CASE WHEN sap_fct_po_receipt.CITM_TYPE = 18 THEN 'Y' ELSE 'N' END AS vomi_flag
FROM sap_fct_po_receipt
WHERE sap_fct_po_receipt.CREF_PO_UUID IS NOT NULL
  ),
  _source_f_po_receipt_1 AS (
SELECT
  CAST(NULL AS STRING) AS contract_end_date,
  CAST(NULL AS STRING) AS contract_flag,
  CAST(NULL AS STRING) AS contract_start_date,
  CAST(NULL AS STRING) AS contract_type,
  CAST(NULL AS STRING) AS delvr_cmplt_flg,
  "DSD" AS div_cd,
  CAST(NULL AS STRING) AS fk_orig,
  CAST(NULL AS STRING) AS floor_stock_cd,
  "PSBIOLC" AS hfm_entity,
  CAST(NULL AS STRING) AS inv_loc,
  CAST(NULL AS STRING) AS lcr_flag,
  CAST(NULL AS STRING) AS lcr_region,
  CAST(NULL AS STRING) AS match_typ_cd,
  CAST(NULL AS STRING) AS match_typ_desc,
  CAST(NULL AS DOUBLE) AS prod_cost,
  CAST(NULL AS STRING) AS recpt_type_cd,
  CAST(NULL AS STRING) AS ref_recpt_line_seq_nbr,
  CAST(NULL AS STRING) AS ref_recpt_nbr,
  CAST(NULL AS STRING) AS ref_recpt_yr_nbr,
  "byd_brsbn" AS src_sys_cd,
  CAST(NULL AS STRING) AS warehouse,
  CAST(NULL AS STRING) AS warehouse_nm
FROM sap_fct_po_receipt
WHERE 1 = 1
  ),
  _source_f_po_receipt_2 AS (
SELECT
  sap_fct_po_receipt.KCRC_DLVD_AMT * CAST(COALESCE(co_curr_mth.co_pmar_rt, 1) AS DOUBLE) AS recpt_co_pmar_amt,
  sap_fct_po_receipt.KCRC_DLVD_AMT * pmar_rt AS recpt_pmar_amt
FROM sap_fct_po_receipt
LEFT OUTER JOIN (
  SELECT
    curr_mnth.pmar_rt AS co_pmar_rt,
    curr_mnth.yr_mth_nbr,
    curr_mnth.from_curncy_cd
  FROM d_curncy_mth_rt curr_mnth
  WHERE UPPER(to_curncy_cd) = 'USD'
) co_curr_mth
  ON co_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr
  AND co_curr_mth.from_curncy_cd = '?'
LEFT OUTER JOIN (
  SELECT
    curr_mnth.pmar_rt AS txn_pmar_rt,
    curr_mnth.yr_mth_nbr,
    curr_mnth.from_curncy_cd,
    curr_mnth.to_curncy_cd
  FROM d_curncy_mth_rt curr_mnth
  WHERE TRIM(UPPER(to_curncy_cd)) = 'USD'
) txn_curr_mth
  ON txn_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr
  AND TRIM(UPPER(txn_curr_mth.from_curncy_cd)) = '?'
  ),
  _source_f_po_receipt_3 AS (
SELECT
  fct_po_receipt.KCDLVD_QTY AS recpt_txn_qty,
  fct_po_receipt.CDELIVERY_YEAR AS recpt_yr_nbr,
  CAST(NULL AS STRING) AS base_uom,
  CAST(NULL AS STRING) AS base_uom_text,
  CAST(NULL AS STRING) AS business_unit,
  CAST(NULL AS STRING) AS buyer_id,
  CAST(NULL AS STRING) AS buyer_name,
  CAST(NULL AS STRING) AS co_cd,
  CAST(NULL AS STRING) AS co_curncy_cd,
  CAST(NULL AS STRING) AS co_name,
  CAST(NULL AS STRING) AS contract_end_date,
  CAST(NULL AS STRING) AS contract_flag,
  CAST(NULL AS STRING) AS contract_start_date,
  CAST(NULL AS STRING) AS contract_type,
  CAST(NULL AS STRING) AS delvr_cmplt_flg,
  CAST(NULL AS STRING) AS div_cd,
  CAST(NULL AS STRING) AS dock_dt,
  CAST(NULL AS STRING) AS due_dt,
  CAST(NULL AS DOUBLE) AS ext_recpt_co_amt,
  CAST(NULL AS DOUBLE) AS ext_recpt_txn_amt,
  CAST(NULL AS STRING) AS fk_orig,
  CAST(NULL AS STRING) AS floor_stock_cd,
  CAST(NULL AS STRING) AS hfm_entity,
  CAST(NULL AS STRING) AS inv_loc,
  CAST(NULL AS STRING) AS item_desc,
  CAST(NULL AS STRING) AS item_nbr,
  CAST(NULL AS STRING) AS lcr_flag,
  CAST(NULL AS STRING) AS lcr_region,
  CAST(NULL AS STRING) AS match_typ_cd,
  CAST(NULL AS STRING) AS match_typ_desc,
  CAST(NULL AS STRING) AS po_curncy_cd,
  CAST(NULL AS INT) AS po_delivry_line_nbr,
  CAST(NULL AS STRING) AS po_line_nbr,
  CAST(NULL AS STRING) AS po_line_type_cd,
  CAST(NULL AS STRING) AS po_nbr,
  CAST(NULL AS STRING) AS po_paymt_terms_cd,
  CAST(NULL AS DOUBLE) AS prod_cost,
  CAST(NULL AS STRING) AS profit_cntr,
  CAST(NULL AS STRING) AS promise_dt,
  CAST(NULL AS STRING) AS purch_uom,
  CAST(NULL AS STRING) AS purch_uom_text,
  CAST(NULL AS DOUBLE) AS recpt_base_qty,
  CAST(NULL AS DOUBLE) AS recpt_co_pmar_amt,
  CAST(NULL AS STRING) AS recpt_curncy_cd,
  CAST(NULL AS STRING) AS recpt_date,
  CAST(NULL AS STRING) AS recpt_date_period,
  CAST(NULL AS STRING) AS recpt_line_seq_nbr,
  CAST(NULL AS STRING) AS recpt_nbr,
  CAST(NULL AS DOUBLE) AS recpt_pmar_amt,
  CAST(NULL AS STRING) AS recpt_type_cd,
  CAST(NULL AS STRING) AS ref_recpt_line_seq_nbr,
  CAST(NULL AS STRING) AS ref_recpt_nbr,
  CAST(NULL AS STRING) AS ref_recpt_yr_nbr,
  CAST(NULL AS STRING) AS site_cd,
  CAST(NULL AS STRING) AS spend_type_cd,
  CAST(NULL AS STRING) AS src_sys_cd,
  CAST(NULL AS STRING) AS suplr_paymt_terms_cd,
  CAST(NULL AS STRING) AS suplr_paymt_terms_desc,
  CAST(NULL AS STRING) AS supplier_id,
  CAST(NULL AS STRING) AS supplier_name,
  CAST(NULL AS STRING) AS txn_date,
  CAST(NULL AS STRING) AS txn_uom,
  CAST(NULL AS STRING) AS txn_uom_text,
  CAST(NULL AS STRING) AS vomi_flag,
  CAST(NULL AS STRING) AS warehouse,
  CAST(NULL AS STRING) AS warehouse_nm
FROM sap_fct_po_receipt fct_po_receipt
WHERE fct_po_receipt.KCDLVD_QTY IS NOT NULL AND fct_po_receipt.CDELIVERY_YEAR IS NOT NULL
  ),
  _transformed AS (
  SELECT
    base_uom AS base_uom,
    base_uom_text AS base_uom_text,
    business_unit AS business_unit,
    buyer_id AS buyer_id,
    buyer_name AS buyer_name,
    co_cd AS co_cd,
    co_curncy_cd AS co_curncy_cd,
    co_name AS co_name,
    dock_dt AS dock_dt,
    due_dt AS due_dt,
    ext_recpt_co_amt AS ext_recpt_co_amt,
    ext_recpt_txn_amt AS ext_recpt_txn_amt,
    item_desc AS item_desc,
    item_nbr AS item_nbr,
    po_curncy_cd AS po_curncy_cd,
    po_delivry_line_nbr AS po_delivry_line_nbr,
    po_line_nbr AS po_line_nbr,
    po_line_type_cd AS po_line_type_cd,
    po_nbr AS po_nbr,
    po_paymt_terms_cd AS po_paymt_terms_cd,
    profit_cntr AS profit_cntr,
    promise_dt AS promise_dt,
    purch_uom AS purch_uom,
    purch_uom_text AS purch_uom_text,
    recpt_base_qty AS recpt_base_qty,
    recpt_curncy_cd AS recpt_curncy_cd,
    recpt_date AS recpt_date,
    recpt_date_period AS recpt_date_period,
    recpt_line_seq_nbr AS recpt_line_seq_nbr,
    recpt_nbr AS recpt_nbr,
    site_cd AS site_cd,
    spend_type_cd AS spend_type_cd,
    suplr_paymt_terms_cd AS suplr_paymt_terms_cd,
    suplr_paymt_terms_desc AS suplr_paymt_terms_desc,
    supplier_id AS supplier_id,
    supplier_name AS supplier_name,
    txn_date AS txn_date,
    txn_uom AS txn_uom,
    txn_uom_text AS txn_uom_text,
    vomi_flag AS vomi_flag,
    contract_end_date AS contract_end_date,
    contract_flag AS contract_flag,
    contract_start_date AS contract_start_date,
    contract_type AS contract_type,
    delvr_cmplt_flg AS delvr_cmplt_flg,
    div_cd AS div_cd,
    fk_orig AS fk_orig,
    floor_stock_cd AS floor_stock_cd,
    hfm_entity AS hfm_entity,
    inv_loc AS inv_loc,
    lcr_flag AS lcr_flag,
    lcr_region AS lcr_region,
    match_typ_cd AS match_typ_cd,
    match_typ_desc AS match_typ_desc,
    prod_cost AS prod_cost,
    recpt_type_cd AS recpt_type_cd,
    ref_recpt_line_seq_nbr AS ref_recpt_line_seq_nbr,
    ref_recpt_nbr AS ref_recpt_nbr,
    ref_recpt_yr_nbr AS ref_recpt_yr_nbr,
    src_sys_cd AS src_sys_cd,
    warehouse AS warehouse,
    warehouse_nm AS warehouse_nm,
    recpt_co_pmar_amt AS recpt_co_pmar_amt,
    recpt_pmar_amt AS recpt_pmar_amt,
    recpt_txn_qty AS recpt_txn_qty,
    recpt_yr_nbr AS recpt_yr_nbr
  FROM _source_f_po_receipt_3
  )
SELECT * FROM _transformed;