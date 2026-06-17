-- Query: f_supplier_invoice_transformation
-- Purpose: Transform and load data into f_supplier_invoice
-- Query Type: SELECT

-- Query: f_supplier_invoice_transformation
-- Purpose: Transform and load data into 'f_supplier_invoice'
-- Query Type: SELECT

WITH
  _source_f_supplier_invoice_0 AS (
SELECT
  sap_fct_supplier_invoice.CTRANSACT_DATE AS actual_payment_dt,
  sap_fct_supplier_invoice.CCASHDIS_TERMSCD AS ap_payment_term_cd,
  sap_fct_supplier_invoice.TCASHDIS_TERMSCD AS ap_payment_term_desc,
  sap_fct_supplier_invoice.CTRANSACT_DATE AS aprval_dt,
  sap_fct_supplier_invoice.KCBU_QUANTITY AS base_qty,
  sap_fct_supplier_invoice.CBUYER AS co_cd,
  sap_fct_supplier_invoice.CRC_NET_AMT_CUR_ON_POS AS co_curncy_cd,
  sap_fct_supplier_invoice.TBUYER AS co_name,
  sap_fct_supplier_invoice.CCOST_CENTER AS cost_centre_cd,
  sap_fct_supplier_invoice.TCOST_CENTER AS cost_centre_nm,
  sap_fct_supplier_invoice.CINVOICE_TYCD AS document_type,
  COALESCE(d_dt.fscl_yr_nbr, DATE_FORMAT(sap_fct_supplier_invoice.CTRANSACT_DATE, 'yyyy')) AS fscl_yr_nbr,
  sap_fct_supplier_invoice.CGL_ACC_ALIAS_CD AS gl_acct_id,
  sap_fct_supplier_invoice.TGL_ACC_ALIAS_CD AS gl_acct_nm,
  CAST(NULL AS string) AS hfm_entity,
  sap_fct_supplier_invoice.CITEM_DESCR AS inv_line_desc,
  sap_fct_supplier_invoice.kcrc_net_amount AS invc_co_amt,
  sap_fct_supplier_invoice.CINVOICE_DATE AS invc_entry_dt,
  COALESCE(d_dt_entry.fscl_yr_prd_nbr, DATE_FORMAT(sap_fct_supplier_invoice.CINVOICE_DATE, 'yyyymm')) AS invc_entry_period,
  sap_fct_supplier_invoice.CTRANSACT_DATE AS invc_post_dt,
  sap_fct_supplier_invoice.KCQUANTITY AS invc_qty,
  sap_fct_supplier_invoice.CRECEIPT_DATE AS invc_receipt_dt,
  sap_fct_supplier_invoice.KCNET_AMOUNT AS invc_txn_amt,
  sap_fct_supplier_invoice.UCQUANTITY AS invc_uom_cd,
  sap_fct_supplier_invoice.cproduct AS item_nbr,
  sap_fct_supplier_invoice.CPRD_CATEGORY AS erp_cat_cd,
  sap_fct_supplier_invoice.TPRD_CATEGORY AS erp_cat_nm,
  sap_fct_supplier_invoice.CFULL_PAY_EDATE AS paymt_due_dt,
  sap_fct_supplier_invoice.CNET_PRC_AMT_CUR AS po_curncy_cd,
  sap_fct_supplier_invoice.CREF_PO_ITEM AS po_line_nbr,
  sap_fct_supplier_invoice.CREF_PO AS po_nbr,
  COALESCE(d_dt_pstng.fscl_yr_prd_nbr, DATE_FORMAT(sap_fct_supplier_invoice.CTRANSACT_DATE, 'yyyyMM')) AS post_yr_mth_nbr,
  sap_fct_supplier_invoice.CBUYER AS profit_cntr,
  CAST(NULL AS string) AS remit_to_addr_line_1,
  CAST(NULL AS string) AS remit_to_addr_line_2,
  CAST(NULL AS string) AS remit_to_addr_line_3,
  CAST(NULL AS string) AS remit_to_addr_line_4,
  sap_fct_supplier_invoice.CCITY_NAME AS remit_to_city_nm,
  sap_fct_supplier_invoice.CCOUNTRY_CODE AS remit_to_cntry_cd,
  sap_fct_supplier_invoice.TCOUNTRY_CODE AS remit_to_cntry_nm,
  sap_fct_supplier_invoice.CREGION_CODE AS remit_to_st_cd,
  COALESCE(sap_fct_supplier_invoice.CRECEIVING_SITE, 'NONE') AS site_cd,
  sap_fct_supplier_invoice.TRECEIVING_SITE AS site_name,
  sap_fct_supplier_invoice.CINVOICE_DATE AS suplr_invc_dt,
  sap_fct_supplier_invoice.CREF_CIV AS suplr_invc_nbr,
  sap_fct_supplier_invoice.CSELLER AS supplier_cd,
  sap_fct_supplier_invoice.TSELLER AS supplier_name,
  CASE WHEN sap_fct_supplier_invoice.kcnet_prc_qty = 0 THEN NULL ELSE sap_fct_supplier_invoice.KCNET_PRC_AMT / sap_fct_supplier_invoice.kcnet_prc_qty END AS unit_prc,
  sap_fct_supplier_invoice.CITEM_ID AS vchr_line_nbr,
  sap_fct_supplier_invoice.CINVOICE_UUID AS vchr_nbr,
  sap_fct_supplier_invoice.CITEM_TYPE AS vchr_type_cd,
  sap_fct_supplier_invoice.TITEM_TYPE AS vchr_type_desc,
  sap_fct_supplier_invoice.TINVOICE_TYCD AS document_desc
FROM sap_fct_supplier_invoice
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
  AND sap_fct_supplier_invoice.CSELLER IS NOT NULL
  ),
  _source_f_supplier_invoice_1 AS (
SELECT
  sap_dim_product_1.cbase_measure_unit_code AS base_uom_cd,
  sap_dim_product_1.TMATR_INT_ID AS item_desc,
  sap_dim_product_1.Cs1ANsD0A4BBEA40DDD66 AS vendor_mat_no
FROM sap_fct_supplier_invoice
LEFT JOIN sap_dim_product_1
  ON TRIM(UPPER(sap_fct_supplier_invoice.cprd_uuid)) = TRIM(UPPER(sap_dim_product_1.cmatr_int_id))
  AND TRIM(UPPER(sap_fct_supplier_invoice.creceiving_site)) = TRIM(UPPER(sap_dim_product_1.csite_id))
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_2 AS (
SELECT
  edp_lkup.lkup_val_02 AS business_unit
FROM sap_fct_supplier_invoice fct_supplier_invoice
LEFT OUTER JOIN edp_lkup
  ON edp_lkup.lkup_key_02 = fct_supplier_invoice.cbuyer
  AND upper(edp_lkup.lkup_typ_nm) = 'TFS_CO_CD_TO_DIV_CD_BU'
  AND lower(edp_lkup.lkup_key_01) = 'byd_brsbn'
WHERE fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND fct_supplier_invoice.po_nbr IS NOT NULL
  AND fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_3 AS (
SELECT
  CAST(NULL AS STRING) AS buyer_cd,
  CAST(NULL AS STRING) AS buyer_name,
  CAST(NULL AS STRING) AS contract_end_date,
  CAST(NULL AS STRING) AS contract_flag,
  CAST(NULL AS STRING) AS contract_start_date,
  CAST(NULL AS STRING) AS contract_type,
  CAST(NULL AS BIGINT) AS fk_orig,
  CAST(NULL AS STRING) AS inv_flg,
  CAST(NULL AS STRING) AS invc_apprv_id,
  CAST(NULL AS STRING) AS invc_txn_type,
  CAST(NULL AS STRING) AS lcr_flag,
  CAST(NULL AS STRING) AS lcr_region,
  CAST(NULL AS STRING) AS nature,
  CAST(NULL AS STRING) AS part_rev_no,
  CAST(NULL AS STRING) AS pass_through_field,
  CAST(NULL AS STRING) AS pass_through_line,
  CAST(NULL AS STRING) AS payment_compliance_flg,
  CAST(NULL AS STRING) AS remit_to_rgn_cd,
  CAST(NULL AS STRING) AS remit_to_rgn_nm,
  CAST(NULL AS STRING) AS reporting_site,
  CAST(NULL AS STRING) AS rpt_flex1,
  CAST(NULL AS STRING) AS sec_supp_cd,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS STRING) AS thermo_item_nbr,
  CAST(NULL AS STRING) AS txn_orig_id,
  CAST(NULL AS STRING) AS txn_ref_nbr,
  CAST(NULL AS STRING) AS unit,
  CAST(NULL AS STRING) AS vchr_status,
  'N' AS vomi_flag,
  CAST(NULL AS STRING) AS warehouse,
  CAST(NULL AS STRING) AS warehouse_nm
FROM sap_fct_supplier_invoice
WHERE src_sys_cd IS NOT NULL
  AND vchr_nbr IS NOT NULL
  AND vchr_line_nbr IS NOT NULL
  AND po_nbr IS NOT NULL
  AND po_line_nbr IS NOT NULL
  AND fscl_yr_nbr IS NOT NULL
  AND co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_4 AS (
SELECT
  CAST(co_curr_mth.co_pmar_rt AS double) AS co_curncy_mth_rt,
  (Gross_Amount_in_Company_Currency * COALESCE(co_curr_mth.co_pmar_rt, 0)) AS invc_co_pmar_amt,
  (KCNET_AMOUNT * COALESCE(po_curr_mth.po_pmar_rt, 0)) AS invc_txn_pmar_amt,
  CAST(po_curr_mth.po_pmar_rt AS double) AS txn_curncy_mth_rt,
  (f_supplier_invoice.unit_prc * COALESCE(po_curr_mth.po_pmar_rt, 0)) AS unit_prc_pmar_amt,
  (fct_supplier_invoice.kcbu_quantity / fct_supplier_invoice.kcquantity) AS uom_conv_factor
FROM sap_fct_supplier_invoice
LEFT JOIN co_curr_mth ON sap_fct_supplier_invoice.some_key = co_curr_mth.some_key
LEFT JOIN po_curr_mth ON sap_fct_supplier_invoice.some_key = po_curr_mth.some_key
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_5 AS (
SELECT
  fct_supplier_invoice.src_sys_cd AS src_sys_cd,
  fct_supplier_invoice.vchr_nbr AS vchr_nbr,
  fct_supplier_invoice.vchr_line_nbr AS vchr_line_nbr,
  fct_supplier_invoice.po_nbr AS po_nbr,
  fct_supplier_invoice.po_line_nbr AS po_line_nbr,
  fct_supplier_invoice.fscl_yr_nbr AS fscl_yr_nbr,
  fct_supplier_invoice.co_cd AS co_cd,
  'DSD' AS div_cd
FROM sap_fct_supplier_invoice fct_supplier_invoice
LEFT OUTER JOIN edp_lkup
  ON edp_lkup.lkup_key_02 = fct_supplier_invoice.cbuyer
  AND upper(edp_lkup.lkup_typ_nm) = 'TFS_CO_CD_TO_DIV_CD_BU'
  AND lower(edp_lkup.lkup_key_01) = 'byd_brsbn'
WHERE fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND fct_supplier_invoice.po_nbr IS NOT NULL
  AND fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_6 AS (
SELECT
  dim_product_1.cprod_catg_uuid_01 AS erp_commondity_cd,
  dim_product_1.tprod_catg_uuid_01 AS erp_commondity_nm
FROM sap_fct_supplier_invoice fct_supplier_invoice
LEFT JOIN dim_product_1
  ON TRIM(UPPER(fct_supplier_invoice.cprd_uuid)) = TRIM(UPPER(dim_product_1.cmatr_int_id))
  AND TRIM(UPPER(fct_supplier_invoice.creceiving_site)) = TRIM(UPPER(dim_product_1.csite_id))
WHERE fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND fct_supplier_invoice.po_nbr IS NOT NULL
  AND fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_7 AS (
SELECT
  CAST(NULL AS STRING) AS floor_stock_cd
FROM sap_fct_supplier_invoice
WHERE src_sys_cd IS NOT NULL
  AND vchr_nbr IS NOT NULL
  AND vchr_line_nbr IS NOT NULL
  AND po_nbr IS NOT NULL
  AND po_line_nbr IS NOT NULL
  AND fscl_yr_nbr IS NOT NULL
  AND co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_8 AS (
SELECT
  sap_fct_supplier_invoice.src_sys_cd AS src_sys_cd,
  sap_fct_supplier_invoice.vchr_nbr AS vchr_nbr,
  sap_fct_supplier_invoice.vchr_line_nbr AS vchr_line_nbr,
  sap_fct_supplier_invoice.po_nbr AS po_nbr,
  sap_fct_supplier_invoice.po_line_nbr AS po_line_nbr,
  sap_fct_supplier_invoice.fscl_yr_nbr AS fscl_yr_nbr,
  sap_fct_supplier_invoice.co_cd AS co_cd,
  sap_fct_purchase_order.CCASHDIS_TERMSCD AS po_paymt_terms_cd,
  sap_fct_purchase_order.TCASHDIS_TERMSCD AS po_paymt_terms_desc,
  CASE
    WHEN sap_fct_purchase_order.CITM_TYPE = '18' THEN 'Direct'
    ELSE 'Indirect'
  END AS spend_type_cd
FROM sap_fct_supplier_invoice
LEFT JOIN sap_fct_purchase_order
  ON sap_fct_supplier_invoice.CREF_PO = sap_fct_purchase_order.CPO_ID
  AND sap_fct_supplier_invoice.CREF_PO_ITEM = sap_fct_purchase_order.CITM_ID
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
UNION ALL
SELECT
  fct_purchase_order_history.src_sys_cd AS src_sys_cd,
  fct_purchase_order_history.vchr_nbr AS vchr_nbr,
  fct_purchase_order_history.vchr_line_nbr AS vchr_line_nbr,
  fct_purchase_order_history.po_nbr AS po_nbr,
  fct_purchase_order_history.po_line_nbr AS po_line_nbr,
  fct_purchase_order_history.fscl_yr_nbr AS fscl_yr_nbr,
  fct_purchase_order_history.co_cd AS co_cd,
  fct_purchase_order_history.CCASHDIS_TERMSCD AS po_paymt_terms_cd,
  fct_purchase_order_history.TCASHDIS_TERMSCD AS po_paymt_terms_desc,
  CASE
    WHEN fct_purchase_order_history.CITM_TYPE = '18' THEN 'Direct'
    ELSE 'Indirect'
  END AS spend_type_cd
FROM sap_fct_supplier_invoice
LEFT JOIN fct_purchase_order_history
  ON sap_fct_supplier_invoice.CREF_PO = fct_purchase_order_history.CPO_ID
  AND sap_fct_supplier_invoice.CREF_PO_ITEM = fct_purchase_order_history.CITM_ID
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_9 AS (
SELECT
  CASE
    WHEN 'Invoice' IS NOT NULL THEN 'Invoice'
    ELSE 'PO'
  END AS suplr_nm_src
FROM sap_fct_supplier_invoice
WHERE src_sys_cd IS NOT NULL
  AND vchr_nbr IS NOT NULL
  AND vchr_line_nbr IS NOT NULL
  AND po_nbr IS NOT NULL
  AND po_line_nbr IS NOT NULL
  AND fscl_yr_nbr IS NOT NULL
  AND co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_10 AS (
SELECT
  sap_fct_supplier_invoice.src_sys_cd AS src_sys_cd,
  sap_fct_supplier_invoice.vchr_nbr AS vchr_nbr,
  sap_fct_supplier_invoice.vchr_line_nbr AS vchr_line_nbr,
  sap_fct_supplier_invoice.po_nbr AS po_nbr,
  sap_fct_supplier_invoice.po_line_nbr AS po_line_nbr,
  sap_fct_supplier_invoice.fscl_yr_nbr AS fscl_yr_nbr,
  sap_fct_supplier_invoice.co_cd AS co_cd,
  dim_supplier.CCSH_DSCNT_TRM AS suplr_paymt_terms_cd,
  dim_supplier.TCSH_DSCNT_TRM AS suplr_paymt_terms_desc
FROM sap_fct_supplier_invoice
LEFT JOIN dim_supplier
  ON sap_fct_supplier_invoice.CSELLER = dim_supplier.CBP_UUID
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _source_f_supplier_invoice_11 AS (
SELECT
  CASE
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Domestic, third party' THEN '3rdParty supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Foreign, third party' THEN '3rdParty supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Inside/Outside BG, affiliated' THEN 'IC supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Inside BG, affiliated' THEN 'IC supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Employees' THEN 'IC supplier'
    ELSE NULL
  END AS supplier_type_cd
FROM sap_fct_supplier_invoice
LEFT JOIN sap_dim_Supplier_Payment_Data
  ON sap_dim_Supplier_Payment_Data.CBP_UUID = sap_fct_supplier_invoice.CSELLER
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    actual_payment_dt AS actual_payment_dt,
    ap_payment_term_cd AS ap_payment_term_cd,
    ap_payment_term_desc AS ap_payment_term_desc,
    aprval_dt AS aprval_dt,
    base_qty AS base_qty,
    co_cd AS co_cd,
    co_curncy_cd AS co_curncy_cd,
    co_name AS co_name,
    cost_centre_cd AS cost_centre_cd,
    cost_centre_nm AS cost_centre_nm,
    document_type AS document_type,
    fscl_yr_nbr AS fscl_yr_nbr,
    gl_acct_id AS gl_acct_id,
    gl_acct_nm AS gl_acct_nm,
    hfm_entity AS hfm_entity,
    inv_line_desc AS inv_line_desc,
    invc_co_amt AS invc_co_amt,
    invc_entry_dt AS invc_entry_dt,
    invc_entry_period AS invc_entry_period,
    invc_post_dt AS invc_post_dt,
    invc_qty AS invc_qty,
    invc_receipt_dt AS invc_receipt_dt,
    invc_txn_amt AS invc_txn_amt,
    invc_uom_cd AS invc_uom_cd,
    item_nbr AS item_nbr,
    erp_cat_cd AS erp_cat_cd,
    erp_cat_nm AS erp_cat_nm,
    paymt_due_dt AS paymt_due_dt,
    po_curncy_cd AS po_curncy_cd,
    po_line_nbr AS po_line_nbr,
    po_nbr AS po_nbr,
    post_yr_mth_nbr AS post_yr_mth_nbr,
    profit_cntr AS profit_cntr,
    remit_to_addr_line_1 AS remit_to_addr_line_1,
    remit_to_addr_line_2 AS remit_to_addr_line_2,
    remit_to_addr_line_3 AS remit_to_addr_line_3,
    remit_to_addr_line_4 AS remit_to_addr_line_4,
    remit_to_city_nm AS remit_to_city_nm,
    remit_to_cntry_cd AS remit_to_cntry_cd,
    remit_to_cntry_nm AS remit_to_cntry_nm,
    remit_to_st_cd AS remit_to_st_cd,
    site_cd AS site_cd,
    site_name AS site_name,
    suplr_invc_dt AS suplr_invc_dt,
    suplr_invc_nbr AS suplr_invc_nbr,
    supplier_cd AS supplier_cd,
    supplier_name AS supplier_name,
    unit_prc AS unit_prc,
    vchr_line_nbr AS vchr_line_nbr,
    vchr_nbr AS vchr_nbr,
    vchr_type_cd AS vchr_type_cd,
    vchr_type_desc AS vchr_type_desc,
    document_desc AS document_desc,
    base_uom_cd AS base_uom_cd,
    item_desc AS item_desc,
    vendor_mat_no AS vendor_mat_no,
    business_unit AS business_unit,
    buyer_cd AS buyer_cd,
    buyer_name AS buyer_name,
    contract_end_date AS contract_end_date,
    contract_flag AS contract_flag,
    contract_start_date AS contract_start_date,
    contract_type AS contract_type,
    fk_orig AS fk_orig,
    inv_flg AS inv_flg,
    invc_apprv_id AS invc_apprv_id,
    invc_txn_type AS invc_txn_type,
    lcr_flag AS lcr_flag,
    lcr_region AS lcr_region,
    nature AS nature,
    part_rev_no AS part_rev_no,
    pass_through_field AS pass_through_field,
    pass_through_line AS pass_through_line,
    payment_compliance_flg AS payment_compliance_flg,
    remit_to_rgn_cd AS remit_to_rgn_cd,
    remit_to_rgn_nm AS remit_to_rgn_nm,
    reporting_site AS reporting_site,
    rpt_flex1 AS rpt_flex1,
    sec_supp_cd AS sec_supp_cd,
    src_sys_cd AS src_sys_cd,
    thermo_item_nbr AS thermo_item_nbr,
    txn_orig_id AS txn_orig_id,
    txn_ref_nbr AS txn_ref_nbr,
    unit AS unit,
    vchr_status AS vchr_status,
    vomi_flag AS vomi_flag,
    warehouse AS warehouse,
    warehouse_nm AS warehouse_nm,
    co_curncy_mth_rt AS co_curncy_mth_rt,
    invc_co_pmar_amt AS invc_co_pmar_amt,
    invc_txn_pmar_amt AS invc_txn_pmar_amt,
    txn_curncy_mth_rt AS txn_curncy_mth_rt,
    unit_prc_pmar_amt AS unit_prc_pmar_amt,
    uom_conv_factor AS uom_conv_factor,
    div_cd AS div_cd,
    erp_commondity_cd AS erp_commondity_cd,
    erp_commondity_nm AS erp_commondity_nm,
    floor_stock_cd AS floor_stock_cd,
    po_paymt_terms_cd AS po_paymt_terms_cd,
    po_paymt_terms_desc AS po_paymt_terms_desc,
    spend_type_cd AS spend_type_cd,
    suplr_nm_src AS suplr_nm_src,
    suplr_paymt_terms_cd AS suplr_paymt_terms_cd,
    suplr_paymt_terms_desc AS suplr_paymt_terms_desc,
    supplier_type_cd AS supplier_type_cd
  FROM _source_f_supplier_invoice_11
  )
SELECT * FROM _transformed;