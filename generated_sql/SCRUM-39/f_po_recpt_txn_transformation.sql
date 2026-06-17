-- Query: f_po_recpt_txn_transformation
-- Purpose: Transform and load data into f_po_recpt_txn
-- Query Type: SELECT

-- Query: f_po_recpt_txn_transformation
-- Purpose: Transform and load data into 'f_po_recpt_txn'
-- Query Type: SELECT

WITH
  _source_f_po_recpt_txn_0 AS (
SELECT
  CONCAT(src_sys_cd, txn_nbr, txn_line_nbr, dw_src_key) AS po_recpt_txn_key,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS STRING) AS txn_nbr,
  CAST(NULL AS STRING) AS txn_line_nbr,
  CAST(NULL AS STRING) AS dw_src_key,
  CAST(NULL AS STRING) AS div_cd,
  CAST(NULL AS STRING) AS po_recpt_key,
  CAST(NULL AS STRING) AS recpt_nbr,
  CAST(NULL AS STRING) AS recpt_line_seq_nbr,
  CAST(NULL AS STRING) AS po_nbr,
  CAST(NULL AS STRING) AS po_line_nbr,
  CAST(NULL AS STRING) AS po_line_type_cd,
  CAST(NULL AS STRING) AS acct_seq_nbr,
  CAST(NULL AS STRING) AS match_type_cd,
  CAST(NULL AS STRING) AS recpt_yr_nbr,
  CAST(NULL AS STRING) AS co_key,
  CAST(NULL AS STRING) AS co_cd,
  CAST(NULL AS STRING) AS prod_key,
  CAST(NULL AS STRING) AS sku,
  CAST(NULL AS STRING) AS plant_cd,
  CAST(NULL AS STRING) AS plant_key,
  CAST(NULL AS STRING) AS prod_plant_key,
  CAST(NULL AS STRING) AS suplr_key,
  CAST(NULL AS STRING) AS suplr_cd,
  CAST(NULL AS STRING) AS suplr_lot_nbr,
  CAST(NULL AS STRING) AS erp_lot_nbr,
  CAST(NULL AS STRING) AS coo_cd,
  CAST(NULL AS STRING) AS coo_nm,
  CAST(NULL AS STRING) AS txn_uom_cd,
  CAST(NULL AS STRING) AS txn_uom_nm,
  CAST(NULL AS DOUBLE) AS txn_qty,
  CAST(NULL AS STRING) AS txn_type_cd,
  CAST(NULL AS STRING) AS src_crt_by,
  CAST(NULL AS TIMESTAMP) AS src_crt_ts,
  CAST(NULL AS STRING) AS src_updt_by,
  CAST(NULL AS TIMESTAMP) AS src_updt_ts,
  CAST(NULL AS TIMESTAMP) AS rec_crt_ts,
  CAST(NULL AS TIMESTAMP) AS rec_updt_ts
FROM (SELECT 1) dummy_source
WHERE CONCAT(src_sys_cd, txn_nbr, txn_line_nbr, dw_src_key) IS NOT NULL
  ),
  _transformed AS (
  SELECT
    po_recpt_txn_key AS po_recpt_txn_key,
    src_sys_cd AS src_sys_cd,
    txn_nbr AS txn_nbr,
    txn_line_nbr AS txn_line_nbr,
    dw_src_key AS dw_src_key,
    div_cd AS div_cd,
    po_recpt_key AS po_recpt_key,
    recpt_nbr AS recpt_nbr,
    recpt_line_seq_nbr AS recpt_line_seq_nbr,
    po_nbr AS po_nbr,
    po_line_nbr AS po_line_nbr,
    po_line_type_cd AS po_line_type_cd,
    acct_seq_nbr AS acct_seq_nbr,
    match_type_cd AS match_type_cd,
    recpt_yr_nbr AS recpt_yr_nbr,
    co_key AS co_key,
    co_cd AS co_cd,
    prod_key AS prod_key,
    sku AS sku,
    plant_cd AS plant_cd,
    plant_key AS plant_key,
    prod_plant_key AS prod_plant_key,
    suplr_key AS suplr_key,
    suplr_cd AS suplr_cd,
    suplr_lot_nbr AS suplr_lot_nbr,
    erp_lot_nbr AS erp_lot_nbr,
    coo_cd AS coo_cd,
    coo_nm AS coo_nm,
    txn_uom_cd AS txn_uom_cd,
    txn_uom_nm AS txn_uom_nm,
    txn_qty AS txn_qty,
    txn_type_cd AS txn_type_cd,
    src_crt_by AS src_crt_by,
    src_crt_ts AS src_crt_ts,
    src_updt_by AS src_updt_by,
    src_updt_ts AS src_updt_ts,
    rec_crt_ts AS rec_crt_ts,
    rec_updt_ts AS rec_updt_ts
  FROM _source_f_po_recpt_txn_0
  )
SELECT * FROM _transformed;