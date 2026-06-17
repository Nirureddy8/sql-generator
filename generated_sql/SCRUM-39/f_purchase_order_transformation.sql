-- Query: f_purchase_order_transformation
-- Purpose: Transform and load data into f_purchase_order
-- Query Type: SELECT

-- Query: f_purchase_order_transformation
-- Purpose: Transform and load data into 'f_purchase_order'
-- Query Type: SELECT

WITH
  _source_f_purchase_order_0 AS (
SELECT
  CAST(NULL AS STRING) AS acct_seq_nbr,
  CAST(NULL AS STRING) AS blkt_cd,
  CAST(NULL AS STRING) AS coi,
  CAST(NULL AS STRING) AS contract_end_date,
  CAST(NULL AS STRING) AS contract_flag,
  CAST(NULL AS STRING) AS contract_start_date,
  CAST(NULL AS STRING) AS contract_type,
  CAST(NULL AS STRING) AS coo,
  CAST(NULL AS STRING) AS dept_cd,
  CAST(NULL AS DOUBLE) AS dock_qty,
  CAST(NULL AS STRING) AS good_receipt_ind,
  CAST(NULL AS STRING) AS inv_flg_text,
  CAST(NULL AS STRING) AS job_no,
  CAST(NULL AS STRING) AS last_recpt_dt,
  CAST(NULL AS STRING) AS lcr_flag,
  CAST(NULL AS STRING) AS lcr_region,
  CAST(NULL AS DECIMAL(3,0)) AS line_seq,
  CAST(NULL AS STRING) AS nature,
  CAST(NULL AS STRING) AS nature_nm,
  CAST(NULL AS DOUBLE) AS open_txn_amt,
  CAST(NULL AS DOUBLE) AS open_txn_pmar_amt,
  CAST(NULL AS STRING) AS part_rev_no,
  CAST(NULL AS STRING) AS pass_through_field,
  CAST(NULL AS STRING) AS pass_through_line,
  CAST(NULL AS STRING) AS payment_compliance_flg,
  CAST(NULL AS STRING) AS planner_cd,
  CAST(NULL AS STRING) AS planner_name,
  CAST(NULL AS STRING) AS complt_dt_key,
  CAST(NULL AS STRING) AS po_hdr_desc,
  CAST(NULL AS STRING) AS po_line_sq,
  CAST(NULL AS STRING) AS purch_org_id,
  CAST(NULL AS STRING) AS ref_no,
  CAST(NULL AS STRING) AS reporting_site,
  CAST(NULL AS STRING) AS sec_supp_cd,
  CAST(NULL AS STRING) AS spend_typ_cd,
  CAST(NULL AS STRING) AS src_crt_by,
  CAST(NULL AS STRING) AS src_crt_ts,
  CAST(NULL AS STRING) AS src_sys_cd,
  CAST(NULL AS DOUBLE) AS stock_qty,
  CAST(NULL AS STRING) AS suplr_cat_no,
  CAST(NULL AS DOUBLE) AS txn_co_exch_rt,
  CAST(NULL AS STRING) AS unit,
  CAST(NULL AS STRING) AS unit_nm,
  CAST(NULL AS DOUBLE) AS unit_prc_co_pmar_amt,
  CAST(NULL AS DOUBLE) AS unit_prc_txn_pmar_amt,
  CAST(NULL AS DOUBLE) AS uom_conv_factor,
  CAST(NULL AS STRING) AS warehouse,
  CAST(NULL AS STRING) AS warehouse_nm
FROM sap_fct_purchase_order
WHERE src_sys_cd IS NOT NULL AND po_nbr IS NOT NULL AND po_line_nbr IS NOT NULL AND po_type_cd IS NOT NULL AND acct_seq_nbr IS NOT NULL AND co_cd IS NOT NULL
  ),
  _source_f_purchase_order_1 AS (
SELECT
  sap_fct_purchase_order.KCBU_QUANTITY - sap_fct_purchase_order.KCBU_DLVD_QTY AS base_open_qty,
  sap_fct_purchase_order.KCBU_QUANTITY AS base_qty,
  sap_fct_purchase_order.CBU_QNT_UNIT AS base_uom,
  sap_fct_purchase_order.TBU_QNT_UNIT AS base_uom_text,
  sap_fct_purchase_order.CBUYER AS business_unit,
  sap_fct_purchase_order.CEMPL_RESP AS buyer_cd,
  sap_fct_purchase_order.TEMPL_RESP AS buyer_name,
  sap_fct_purchase_order.CBUYER AS co_cd,
  sap_fct_purchase_order.CRC_NPRC_AMT_CUR AS co_curncy_cd,
  sap_fct_purchase_order.TBUYER AS co_name,
  sap_fct_purchase_order.CCOST_CENTRE AS cost_centre_cd,
  sap_fct_purchase_order.TCOST_CENTRE AS cost_centre_nm,
  CASE
    WHEN sap_fct_purchase_order.CITM_DLV_ST_01 IN ('1', '2') THEN 'N'
    WHEN sap_fct_purchase_order.CITM_DLV_ST_01 = '3' THEN 'Y'
    ELSE NULL
  END AS delvr_cmplt_flg,
  sap_fct_purchase_order.CITM_DLV_EDDT AS due_dt,
  sap_fct_purchase_order.KCRC_NET_PRC_AMT * sap_fct_purchase_order.KCQUANTITY AS ext_prc_co_amt,
  sap_fct_purchase_order.KCNET_PRC_AMT * sap_fct_purchase_order.KCQUANTITY AS ext_prc_txn_amt,
  sap_fct_purchase_order.CGL_ACC_ALIAS_CD AS gl_account,
  sap_fct_purchase_order.CGL_ACC_ALIAS_CD AS gl_acct_id,
  sap_fct_purchase_order.TGL_ACC_ALIAS_CD AS gl_acct_nm,
  sap_fct_purchase_order.CLFCYCLE_ST AS header_status_cd,
  CASE
    WHEN sap_fct_purchase_order.CLFCYCLE_ST = '10' THEN 'Closed'
    WHEN sap_fct_purchase_order.CLFCYCLE_ST = '8' THEN 'Canceled'
    ELSE 'Open'
  END AS header_status_nm,
  sap_fct_purchase_order.CINC_CLASS_CD AS inco_terms_cd,
  sap_fct_purchase_order.TINC_CLASS_CD AS inco_terms_nm,
  CASE
    WHEN TRIM(UPPER(sap_fct_purchase_order.citm_type)) = '18' THEN 'Y'
    ELSE 'N'
  END AS inv_flg,
  sap_fct_purchase_order.CITM_DESCRIPTION AS item_desc,
  sap_fct_purchase_order.CPRD_UUID AS item_nbr,
  sap_fct_purchase_order.CITM_LFCYCLE_ST AS item_status_cd,
  sap_fct_purchase_order.TITM_LFCYCLE_ST AS item_status_nm,
  sap_fct_purchase_order.KCQUANTITY - sap_fct_purchase_order.KCDLVD_QTY AS open_qty,
  sap_fct_purchase_order.KCQUANTITY AS orig_po_qty,
  sap_fct_purchase_order.CCASHDIS_TERMSCD AS paymt_terms_cd,
  sap_fct_purchase_order.TCASHDIS_TERMSCD AS paymt_terms_desc,
  sap_fct_purchase_order.CITM_DLV_EDDT AS plan_delvry_dt,
  sap_fct_purchase_order.CORDERED_DATE AS approval_dt_key,
  sap_fct_purchase_order.CITM_CREAT_DATE AS po_crt_dt,
  CAST(DATE_FORMAT(sap_fct_purchase_order.CITM_CREAT_DATE, 'yyyyMM') AS STRING) AS po_crt_period,
  sap_fct_purchase_order.RCNET_PRC_AMT AS po_curncy_cd,
  CASE
    WHEN TRIM(UPPER(sap_fct_purchase_order.citm_oqtycan_st)) = '4' THEN 'Y'
    ELSE 'N'
  END AS po_line_del_flg,
  sap_fct_purchase_order.CITM_ID AS po_line_nbr,
  sap_fct_purchase_order.CITM_TYPE AS po_line_type_cd,
  sap_fct_purchase_order.TITM_TYPE AS po_line_type_nm,
  sap_fct_purchase_order.CPO_ID AS po_nbr,
  sap_fct_purchase_order.KCQUANTITY AS po_qty,
  sap_fct_purchase_order.CBUYER AS ship_to_entity_type_nm,
  sap_fct_purchase_order.TBUYER AS po_ship_to_name,
  sap_fct_purchase_order.CPROCESS_TYPE AS po_type_cd,
  sap_fct_purchase_order.TPROCESS_TYPE AS po_type_nm,
  sap_fct_purchase_order.cquantity_unit AS po_uom,
  sap_fct_purchase_order.tquantity_unit AS po_uom_text,
  sap_fct_purchase_order.CBUYER AS profit_cntr,
  sap_fct_purchase_order.CQUANTITY_UNIT AS purch_uom,
  sap_fct_purchase_order.TQUANTITY_UNIT AS purch_uom_text,
  sap_fct_purchase_order.CORDERED_DATE AS release_dt,
  CAST(NULL AS DOUBLE) AS returned_qty,
  COALESCE(sap_fct_purchase_order.CRECEIVING_SITE, 'NONE') AS site_id,
  sap_fct_purchase_order.CITM_DLV_EDDT AS suplr_confrm_dt,
  sap_fct_purchase_order.CITM_DLV_EDDT AS suplr_promise_delv_dt,
  sap_fct_purchase_order.CSELLER AS supplier_cd,
  sap_fct_purchase_order.TSELLER AS supplier_name,
  sap_fct_purchase_order.KCDLVD_QTY AS ttl_recpt_qty,
  sap_fct_purchase_order.KCRC_NET_PRC_AMT AS unit_prc_co_amt,
  sap_fct_purchase_order.KCNET_PRC_AMT AS unit_prc_txn_amt,
  CASE
    WHEN sap_fct_purchase_order.cprocess_type = 'THPA' THEN 'Y'
    ELSE 'N'
  END AS vomi_flag
FROM sap_fct_purchase_order
WHERE sap_fct_purchase_order.src_sys_cd IS NOT NULL
  AND sap_fct_purchase_order.po_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_line_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_type_cd IS NOT NULL
  AND sap_fct_purchase_order.acct_seq_nbr IS NOT NULL
  AND sap_fct_purchase_order.co_cd IS NOT NULL
UNION ALL
SELECT
  fct_purchase_order_history.KCBU_QUANTITY - fct_purchase_order_history.KCBU_DLVD_QTY AS base_open_qty,
  fct_purchase_order_history.KCBU_QUANTITY AS base_qty,
  fct_purchase_order_history.CBU_QNT_UNIT AS base_uom,
  fct_purchase_order_history.TBU_QNT_UNIT AS base_uom_text,
  fct_purchase_order_history.CBUYER AS business_unit,
  fct_purchase_order_history.CEMPL_RESP AS buyer_cd,
  fct_purchase_order_history.TEMPL_RESP AS buyer_name,
  fct_purchase_order_history.CBUYER AS co_cd,
  fct_purchase_order_history.CRC_NPRC_AMT_CUR AS co_curncy_cd,
  fct_purchase_order_history.TBUYER AS co_name,
  fct_purchase_order_history.CCOST_CENTRE AS cost_centre_cd,
  fct_purchase_order_history.TCOST_CENTRE AS cost_centre_nm,
  CASE
    WHEN fct_purchase_order_history.CITM_DLV_ST_01 IN ('1', '2') THEN 'N'
    WHEN fct_purchase_order_history.CITM_DLV_ST_01 = '3' THEN 'Y'
    ELSE NULL
  END AS delvr_cmplt_flg,
  fct_purchase_order_history.CITM_DLV_EDDT AS due_dt,
  fct_purchase_order_history.KCRC_NET_PRC_AMT * fct_purchase_order_history.KCQUANTITY AS ext_prc_co_amt,
  fct_purchase_order_history.KCNET_PRC_AMT * fct_purchase_order_history.KCQUANTITY AS ext_prc_txn_amt,
  fct_purchase_order_history.CGL_ACC_ALIAS_CD AS gl_account,
  fct_purchase_order_history.CGL_ACC_ALIAS_CD AS gl_acct_id,
  fct_purchase_order_history.TGL_ACC_ALIAS_CD AS gl_acct_nm,
  fct_purchase_order_history.CLFCYCLE_ST AS header_status_cd,
  CASE
    WHEN fct_purchase_order_history.CLFCYCLE_ST = '10' THEN 'Closed'
    WHEN fct_purchase_order_history.CLFCYCLE_ST = '8' THEN 'Canceled'
    ELSE 'Open'
  END AS header_status_nm,
  fct_purchase_order_history.CINC_CLASS_CD AS inco_terms_cd,
  fct_purchase_order_history.TINC_CLASS_CD AS inco_terms_nm,
  CASE
    WHEN TRIM(UPPER(fct_purchase_order_history.citm_type)) = '18' THEN 'Y'
    ELSE 'N'
  END AS inv_flg,
  fct_purchase_order_history.CITM_DESCRIPTION AS item_desc,
  fct_purchase_order_history.CPRD_UUID AS item_nbr,
  fct_purchase_order_history.CITM_LFCYCLE_ST AS item_status_cd,
  fct_purchase_order_history.TITM_LFCYCLE_ST AS item_status_nm,
  fct_purchase_order_history.KCQUANTITY - fct_purchase_order_history.KCDLVD_QTY AS open_qty,
  fct_purchase_order_history.KCQUANTITY AS orig_po_qty,
  fct_purchase_order_history.CCASHDIS_TERMSCD AS paymt_terms_cd,
  fct_purchase_order_history.TCASHDIS_TERMSCD AS paymt_terms_desc,
  fct_purchase_order_history.CITM_DLV_EDDT AS plan_delvry_dt,
  fct_purchase_order_history.CORDERED_DATE AS approval_dt_key,
  fct_purchase_order_history.CITM_CREAT_DATE AS po_crt_dt,
  CAST(DATE_FORMAT(fct_purchase_order_history.CITM_CREAT_DATE, 'yyyyMM') AS STRING) AS po_crt_period,
  fct_purchase_order_history.RCNET_PRC_AMT AS po_curncy_cd,
  CASE
    WHEN TRIM(UPPER(fct_purchase_order_history.citm_oqtycan_st)) = '4' THEN 'Y'
    ELSE 'N'
  END AS po_line_del_flg,
  fct_purchase_order_history.CITM_ID AS po_line_nbr,
  fct_purchase_order_history.CITM_TYPE AS po_line_type_cd,
  fct_purchase_order_history.TITM_TYPE AS po_line_type_nm,
  fct_purchase_order_history.CPO_ID AS po_nbr,
  fct_purchase_order_history.KCQUANTITY AS po_qty,
  fct_purchase_order_history.CBUYER AS ship_to_entity_type_nm,
  fct_purchase_order_history.TBUYER AS po_ship_to_name,
  fct_purchase_order_history.CPROCESS_TYPE AS po_type_cd,
  fct_purchase_order_history.TPROCESS_TYPE AS po_type_nm,
  fct_purchase_order_history.cquantity_unit AS po_uom,
  fct_purchase_order_history.tquantity_unit AS po_uom_text,
  fct_purchase_order_history.CBUYER AS profit_cntr,
  fct_purchase_order_history.CQUANTITY_UNIT AS purch_uom,
  fct_purchase_order_history.TQUANTITY_UNIT AS purch_uom_text,
  fct_purchase_order_history.CORDERED_DATE AS release_dt,
  CAST(NULL AS DOUBLE) AS returned_qty,
  COALESCE(fct_purchase_order_history.CRECEIVING_SITE, 'NONE') AS site_id,
  fct_purchase_order_history.CITM_DLV_EDDT AS suplr_confrm_dt,
  fct_purchase_order_history.CITM_DLV_EDDT AS suplr_promise_delv_dt,
  fct_purchase_order_history.CSELLER AS supplier_cd,
  fct_purchase_order_history.TSELLER AS supplier_name,
  fct_purchase_order_history.KCDLVD_QTY AS ttl_recpt_qty,
  fct_purchase_order_history.KCRC_NET_PRC_AMT AS unit_prc_co_amt,
  fct_purchase_order_history.KCNET_PRC_AMT AS unit_prc_txn_amt,
  CASE
    WHEN fct_purchase_order_history.cprocess_type = 'THPA' THEN 'Y'
    ELSE 'N'
  END AS vomi_flag
FROM fct_purchase_order_history
WHERE fct_purchase_order_history.src_sys_cd IS NOT NULL
  AND fct_purchase_order_history.po_nbr IS NOT NULL
  AND fct_purchase_order_history.po_line_nbr IS NOT NULL
  AND fct_purchase_order_history.po_type_cd IS NOT NULL
  AND fct_purchase_order_history.acct_seq_nbr IS NOT NULL
  AND fct_purchase_order_history.co_cd IS NOT NULL
  ),
  _source_f_purchase_order_2 AS (
SELECT
  "DSD" AS div_cd,
  "PSBIOLC" AS hfm_entity
FROM sap_fct_purchase_order
WHERE src_sys_cd IS NOT NULL
  AND po_nbr IS NOT NULL
  AND po_line_nbr IS NOT NULL
  AND po_type_cd IS NOT NULL
  AND acct_seq_nbr IS NOT NULL
  AND co_cd IS NOT NULL
  ),
  _source_f_purchase_order_3 AS (
SELECT
  sap_fct_purchase_order.CPROD_CATG_UUID_01 AS erp_commondity_cd,
  sap_fct_purchase_order.TPROD_CATG_UUID_01 AS erp_commondity_nm
FROM sap_fct_purchase_order
LEFT JOIN sap_dim_product1 ON sap_fct_purchase_order.CPRD_UUID = sap_dim_product1.CMATR_INT_ID
WHERE sap_fct_purchase_order.src_sys_cd IS NOT NULL
  AND sap_fct_purchase_order.po_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_line_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_type_cd IS NOT NULL
  AND sap_fct_purchase_order.acct_seq_nbr IS NOT NULL
  AND sap_fct_purchase_order.co_cd IS NOT NULL
  ),
  _source_f_purchase_order_4 AS (
SELECT
  CAST(NULL AS STRING) AS floor_stock_cd
FROM sap_fct_purchase_order
WHERE src_sys_cd IS NOT NULL
  AND po_nbr IS NOT NULL
  AND po_line_nbr IS NOT NULL
  AND po_type_cd IS NOT NULL
  AND acct_seq_nbr IS NOT NULL
  AND co_cd IS NOT NULL
  ),
  _source_f_purchase_order_5 AS (
SELECT
  sap_dim_org_unit_site.CCITY_NAME AS ship_to_city_nm,
  sap_dim_org_unit_site.CCNTRY_CODE AS ship_to_cntry_cd
FROM sap_fct_purchase_order
LEFT JOIN sap_dim_org_unit_site
  ON sap_fct_purchase_order.CRECEIVING_SITE = sap_dim_org_unit_site.CPARTY_ID
WHERE sap_fct_purchase_order.src_sys_cd IS NOT NULL
  AND sap_fct_purchase_order.po_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_line_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_type_cd IS NOT NULL
  AND sap_fct_purchase_order.acct_seq_nbr IS NOT NULL
  AND sap_fct_purchase_order.co_cd IS NOT NULL
  ),
  _source_f_purchase_order_6 AS (
SELECT
  dim_master.kcvalpcomp AS stk_unit_price
FROM sap_fct_purchase_order
LEFT JOIN (
  SELECT
    kcvalpcomp,
    cmatr_int_id,
    ROW_NUMBER() OVER (PARTITION BY cmatr_int_id ORDER BY csupplier_id ASC) AS rank
  FROM dim_master
  WHERE TRIM(UPPER(dim_master.csupply_planning_area)) != '5192'
) dim_master
ON TRIM(UPPER(dim_product_plant.cproduct_id)) = TRIM(UPPER(dim_master.cmatr_int_id))
AND dim_master.rank = 1
WHERE sap_fct_purchase_order.src_sys_cd IS NOT NULL
  AND sap_fct_purchase_order.po_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_line_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_type_cd IS NOT NULL
  AND sap_fct_purchase_order.acct_seq_nbr IS NOT NULL
  AND sap_fct_purchase_order.co_cd IS NOT NULL
  ),
  _source_f_purchase_order_7 AS (
SELECT
  CASE
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Domestic, third party' THEN '3rd party supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Foreign, third party' THEN '3rd party supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE IN ('Inside/Outside BG, affiliated', 'Inside BG, affiliated', 'Employees') THEN 'IC supplier'
    ELSE NULL
  END AS supplier_type_cd
FROM sap_fct_purchase_order
LEFT JOIN sap_dim_Supplier_Payment_Data
  ON sap_dim_Supplier_Payment_Data.CBP_UUID = sap_fct_purchase_order.CSELLER
WHERE sap_fct_purchase_order.src_sys_cd IS NOT NULL
  AND sap_fct_purchase_order.po_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_line_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_type_cd IS NOT NULL
  AND sap_fct_purchase_order.acct_seq_nbr IS NOT NULL
  AND sap_fct_purchase_order.co_cd IS NOT NULL
  ),
  _source_f_purchase_order_8 AS (
SELECT
  sap_dim_product_1.Cs1ANsD0A4BBEA40DDD66 AS vendor_mat_no
FROM sap_fct_purchase_order
LEFT JOIN sap_dim_product_1
  ON sap_fct_purchase_order.CPRD_UUID = sap_dim_product_1.CMATR_INT_ID
WHERE sap_fct_purchase_order.src_sys_cd IS NOT NULL
  AND sap_fct_purchase_order.po_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_line_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_type_cd IS NOT NULL
  AND sap_fct_purchase_order.acct_seq_nbr IS NOT NULL
  AND sap_fct_purchase_order.co_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    acct_seq_nbr AS acct_seq_nbr,
    blkt_cd AS blkt_cd,
    coi AS coi,
    contract_end_date AS contract_end_date,
    contract_flag AS contract_flag,
    contract_start_date AS contract_start_date,
    contract_type AS contract_type,
    coo AS coo,
    dept_cd AS dept_cd,
    dock_qty AS dock_qty,
    good_receipt_ind AS good_receipt_ind,
    inv_flg_text AS inv_flg_text,
    job_no AS job_no,
    last_recpt_dt AS last_recpt_dt,
    lcr_flag AS lcr_flag,
    lcr_region AS lcr_region,
    line_seq AS line_seq,
    nature AS nature,
    nature_nm AS nature_nm,
    open_txn_amt AS open_txn_amt,
    open_txn_pmar_amt AS open_txn_pmar_amt,
    part_rev_no AS part_rev_no,
    pass_through_field AS pass_through_field,
    pass_through_line AS pass_through_line,
    payment_compliance_flg AS payment_compliance_flg,
    planner_cd AS planner_cd,
    planner_name AS planner_name,
    complt_dt_key AS complt_dt_key,
    po_hdr_desc AS po_hdr_desc,
    po_line_sq AS po_line_sq,
    purch_org_id AS purch_org_id,
    ref_no AS ref_no,
    reporting_site AS reporting_site,
    sec_supp_cd AS sec_supp_cd,
    spend_typ_cd AS spend_typ_cd,
    src_crt_by AS src_crt_by,
    src_crt_ts AS src_crt_ts,
    src_sys_cd AS src_sys_cd,
    stock_qty AS stock_qty,
    suplr_cat_no AS suplr_cat_no,
    txn_co_exch_rt AS txn_co_exch_rt,
    unit AS unit,
    unit_nm AS unit_nm,
    unit_prc_co_pmar_amt AS unit_prc_co_pmar_amt,
    unit_prc_txn_pmar_amt AS unit_prc_txn_pmar_amt,
    uom_conv_factor AS uom_conv_factor,
    warehouse AS warehouse,
    warehouse_nm AS warehouse_nm,
    base_open_qty AS base_open_qty,
    base_qty AS base_qty,
    base_uom AS base_uom,
    base_uom_text AS base_uom_text,
    business_unit AS business_unit,
    buyer_cd AS buyer_cd,
    buyer_name AS buyer_name,
    co_cd AS co_cd,
    co_curncy_cd AS co_curncy_cd,
    co_name AS co_name,
    cost_centre_cd AS cost_centre_cd,
    cost_centre_nm AS cost_centre_nm,
    delvr_cmplt_flg AS delvr_cmplt_flg,
    due_dt AS due_dt,
    ext_prc_co_amt AS ext_prc_co_amt,
    ext_prc_txn_amt AS ext_prc_txn_amt,
    gl_account AS gl_account,
    gl_acct_id AS gl_acct_id,
    gl_acct_nm AS gl_acct_nm,
    header_status_cd AS header_status_cd,
    header_status_nm AS header_status_nm,
    inco_terms_cd AS inco_terms_cd,
    inco_terms_nm AS inco_terms_nm,
    inv_flg AS inv_flg,
    item_desc AS item_desc,
    item_nbr AS item_nbr,
    item_status_cd AS item_status_cd,
    item_status_nm AS item_status_nm,
    open_qty AS open_qty,
    orig_po_qty AS orig_po_qty,
    paymt_terms_cd AS paymt_terms_cd,
    paymt_terms_desc AS paymt_terms_desc,
    plan_delvry_dt AS plan_delvry_dt,
    approval_dt_key AS approval_dt_key,
    po_crt_dt AS po_crt_dt,
    po_crt_period AS po_crt_period,
    po_curncy_cd AS po_curncy_cd,
    po_line_del_flg AS po_line_del_flg,
    po_line_nbr AS po_line_nbr,
    po_line_type_cd AS po_line_type_cd,
    po_line_type_nm AS po_line_type_nm,
    po_nbr AS po_nbr,
    po_qty AS po_qty,
    ship_to_entity_type_nm AS ship_to_entity_type_nm,
    po_ship_to_name AS po_ship_to_name,
    po_type_cd AS po_type_cd,
    po_type_nm AS po_type_nm,
    po_uom AS po_uom,
    po_uom_text AS po_uom_text,
    profit_cntr AS profit_cntr,
    purch_uom AS purch_uom,
    purch_uom_text AS purch_uom_text,
    release_dt AS release_dt,
    returned_qty AS returned_qty,
    site_id AS site_id,
    suplr_confrm_dt AS suplr_confrm_dt,
    suplr_promise_delv_dt AS suplr_promise_delv_dt,
    supplier_cd AS supplier_cd,
    supplier_name AS supplier_name,
    ttl_recpt_qty AS ttl_recpt_qty,
    unit_prc_co_amt AS unit_prc_co_amt,
    unit_prc_txn_amt AS unit_prc_txn_amt,
    vomi_flag AS vomi_flag,
    div_cd AS div_cd,
    hfm_entity AS hfm_entity,
    erp_commondity_cd AS erp_commondity_cd,
    erp_commondity_nm AS erp_commondity_nm,
    floor_stock_cd AS floor_stock_cd,
    ship_to_city_nm AS ship_to_city_nm,
    ship_to_cntry_cd AS ship_to_cntry_cd,
    stk_unit_price AS stk_unit_price,
    supplier_type_cd AS supplier_type_cd,
    vendor_mat_no AS vendor_mat_no
  FROM _source_f_purchase_order_8
  )
SELECT * FROM _transformed;