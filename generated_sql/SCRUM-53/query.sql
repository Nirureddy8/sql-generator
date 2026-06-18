-- Databricks notebook source
-- Generated for: SCRUM-53
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_product_transformation
--   Pattern: dimension_flat
-- Query 3: d_org_unit_transformation
--   Pattern: dimension_flat
-- Query 4: d_company_transformation
--   Pattern: dimension_flat
-- Query 5: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 6: d_product_plant_transformation
--   Pattern: dimension_flat
-- Query 7: f_purchase_order_transformation
--   Pattern: fact_union_dedup
-- Query 8: f_po_recpt_txn_transformation
--   Pattern: fact_simple
-- Query 9: f_supplier_invoice_transformation
--   Pattern: fact_union_dedup
-- Query 10: d_supplier_transformation
--   Pattern: dimension_flat
-- Query 11: f_po_receipt_transformation
--   Pattern: fact_union_dedup

-- =============================
-- d_buyer_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_buyer SQL
Description  :- Generates the buyer dimension table from the SAP source
**************************************************************************/

-- Query: d_buyer_transformation
-- Pattern: dimension_flat
-- Coverage: 3 rows

SELECT
  sap_dim_buyer.cee_id AS buyer_cd,
  sap_dim_buyer.tee_id AS buyer_nm,
  'byd_brsbn' AS src_sys_cd
FROM sap_dim_buyer sap_dim_buyer

-- =============================
-- d_product_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_product SQL
Description  :- Generates the d_product dimension table with mappings from sap_dim_product_1 and sap_dim_org_unit_site.
Description  :- Generate SQL for the d_product dimension table
**************************************************************************/

-- Query: d_product_transformation
-- Pattern: dimension_flat
-- Coverage: 19 rows

SELECT
  'byd_brsbn' AS src_sys_cd,
  sap.CMATR_INT_ID AS sku,
  sap.TMATR_INT_ID AS sku_nm,
  sap.cbase_measure_unit_code AS base_uom_cd,
  sap.tbase_measure_unit_code AS base_uom_nm,
  sap.KCGROSS_WEIGHT AS gross_wgt,
  sap.KCNET_WEIGHT AS net_wgt,
  sap.KCHEIGHT AS height,
  sap.KCLENGTH AS length,
  sap.Cs1ANsD0A4BBEA40DDD66 AS mfr_part_nbr,
  CAST(NULL AS STRING) AS temp_cond_cd,
  CAST(NULL AS STRING) AS temp_cond_nm,
  CAST(NULL AS STRING) AS transp_grp_cd,
  CAST(NULL AS STRING) AS transp_grp_nm,
  CAST(MARA.MHDHB AS DECIMAL(20,0)) AS ttl_shelf_life_days,
  CAST(NULL AS STRING) AS unspsc,
  sap.KCGROSS_VOLUME AS vol,
  sap.CGROSS_VOLUME_UNIT_CODE AS vol_uom_cd,
  sap.TGROSS_VOLUME_UNIT_CODE AS vol_uom_nm,
  sap.CGROSS_WEIGHT_UNIT_CODE AS wgt_uom_cd,
  sap.TGROSS_WEIGHT_UNIT_CODE AS wgt_uom_nm,
  sap.KCWIDTH AS width,
  CAST(NULL AS STRING) AS x_distrb_chain_mtl_stat_cd,
  (CASE WHEN MARA.MSTDE = '00000000' THEN CAST(NULL AS TIMESTAMP) ELSE CAST(TO_DATE(MARA.MSTDE, 'yyyyMMdd') AS TIMESTAMP) END) AS x_distrb_chain_mtl_stat_dt,
  CAST(NULL AS STRING) AS x_distrb_chain_mtl_stat_nm,
  IF((MARA.SATNR) = '', 'N', 'Y') AS x_plant_config_flg,
  CAST(NULL AS STRING) AS x_plant_mtl_stat_cd,
  (CASE WHEN MARA.MSTDV = '00000000' THEN CAST(NULL AS TIMESTAMP) ELSE CAST(TO_DATE(MARA.MSTDV, 'yyyyMMdd') AS TIMESTAMP) END) AS x_plant_mtl_stat_dt,
  CAST(NULL AS STRING) AS x_plant_mtl_stat_nm
FROM sap_dim_product_1 sap
LEFT JOIN sap_dim_org_unit_site site ON sap.some_key = site.some_key
WHERE sap.CMATR_INT_ID IS NOT NULL AND sap.TMATR_INT_ID IS NOT NULL AND sap.src_sys_cd IS NOT NULL AND sap.sku IS NOT NULL

-- =============================
-- d_org_unit_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_org_unit SQL
Description  :- Generate a flat dimension table for organizational units
**************************************************************************/

-- Query: d_org_unit_transformation
-- Pattern: dimension_flat
-- Coverage: 26 rows

SELECT
  sap.ccity_name AS city_nm,
  sap.ccntry_code AS cntry_cd,
  sap.tcntry_code AS cntry_nm,
  sap.CBUYER AS co_cd,
  'AUD' AS co_curncy_cd,
  'Australia Dollar' AS co_curncy_nm,
  sap.TBUYER AS co_nm,
  CAST(NULL AS STRING) AS curncy_cd,
  CAST(NULL AS STRING) AS curncy_nm,
  CAST(NULL AS STRING) AS gbl_rgn_cd,
  CAST(NULL AS STRING) AS gbl_rgn_nm,
  CAST(NULL AS STRING) AS lang_cd,
  CAST(NULL AS STRING) AS lang_iso_cd,
  CAST(NULL AS STRING) AS lang_nm,
  CAST(NULL AS STRING) AS org_unit_cat_nm,
  sap.CPARTY_ID AS org_unit_cd,
  sap.TPARTY_ID AS org_unit_nm,
  'manufacturing plant' AS org_unit_type,
  CAST(NULL AS STRING) AS parent_org_unit_cd,
  CAST(NULL AS STRING) AS parent_org_unit_nm,
  CAST(NULL AS STRING) AS rgn_cd,
  CAST(NULL AS STRING) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  sap.cregion_code AS st_prov_cd,
  CAST(NULL AS STRING) AS st_prov_nm,
  sap.cst_name AS street_nm
FROM sap_dim_org_unit_site sap
WHERE sap.CPARTY_ID IS NOT NULL AND sap.TPARTY_ID IS NOT NULL AND 'byd_brsbn' IS NOT NULL

-- =============================
-- d_company_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_company SQL
Description  :- Dimension table for company details, mapped from ERP sources
**************************************************************************/

-- Query: d_company_transformation
-- Pattern: dimension_flat
-- Coverage: 19 rows

SELECT
  TRIM(UPPER('byd_brsbn')) AS src_sys_cd,
  sdc.cco_id AS co_cd,
  sdc.tco_id AS co_nm,
  'AUD' AS co_curncy_cd,
  'Australian Dollar' AS co_curncy_nm,
  sdc.ccntry_code AS cntry_cd,
  sdc.tcntry_code AS cntry_nm,
  sdos.ccity_name AS city_nm,
  CASE WHEN sdc.bukrs IN ('0070', '5000', '1800', '1220', '1000', '0040', '2070', '2000', '2010', '1900', '1530', '1287', '1310', '1030', '1200', '1600', '2030', '0020', '0010', '0110', '2930', '3000', '1520', '1710', '1120', '1150', '2010', '2080', '2040', '1170', '2900', '2090') OR sdc.bukrs BETWEEN '1400' AND '1480' THEN 'AIG' ELSE 'NON_AIG' END AS group_nm,
  'PSBIOLC' AS hfm_entity_cd,
  CAST(NULL AS STRING) AS gbl_rgn_cd,
  CAST(NULL AS STRING) AS gbl_rgn_nm,
  CAST(NULL AS STRING) AS lang_cd,
  CAST(NULL AS STRING) AS lang_iso_cd,
  CAST(NULL AS STRING) AS lang_nm,
  CAST(NULL AS STRING) AS rgn_cd,
  CAST(NULL AS STRING) AS rgn_nm,
  CAST(NULL AS STRING) AS st_prov_cd,
  CAST(NULL AS STRING) AS st_prov_nm
FROM sap_dim_company sdc
LEFT JOIN sap_dim_org_unit_site sdos ON sdos.cparty_id = 4192
WHERE sdc.cco_id IS NOT NULL AND TRIM(UPPER('byd_brsbn')) IS NOT NULL

-- =============================
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_gl_acct SQL
Description  :- Generates the General Ledger Account dimension table
**************************************************************************/

-- Query: d_gl_acct_transformation
-- Pattern: dimension_flat
-- Coverage: 16 rows

SELECT
  dga.ccompany_uuid AS co_cd,
  sga.tcompany_uuid AS co_nm,
  COALESCE(sga.ktopl, NULL) AS coa_id,
  sga.CCOST_CTR_UUID AS cost_center_branch_cd,
  sga.TCOST_CTR_UUID AS cost_center_branch_nm,
  CAST(NULL AS string) AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS dtl_lvl_nbr,
  dga.cglacct AS gl_acct_id,
  COALESCE(sga.TXT50, 'Unknown') AS gl_acct_nm,
  CAST(NULL AS string) AS object_acct_cd,
  CAST(NULL AS string) AS object_acct_cost_type_cd,
  CAST(NULL AS string) AS object_acct_subsdry_nm,
  CAST(NULL AS string) AS object_acct_type_cd,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS subsdry_cd
FROM dim_gl_acct dga
LEFT JOIN sap_dim_gl_acct sga ON dga.cglacct = sga.tglacct
WHERE dga.cglacct IS NOT NULL AND dga.ccompany_uuid IS NOT NULL

-- =============================
-- d_product_plant_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_product_plant SQL
Description  :- Generate SQL for the d_product_plant dimension table
**************************************************************************/

-- Query: d_product_plant_transformation
-- Pattern: dimension_flat
-- Coverage: 192 rows

SELECT
  plant.CSUPPLY_PLANNING_AREA AS plant_cd,
  plant.TSUPPLY_PLANNING_AREA AS plant_nm,
  CAST(NULL AS string) AS alt_bom_cd,
  CAST(NULL AS string) AS alt_bom_nm,
  CAST(NULL AS string) AS alt_bom_select_method,
  CAST(NULL AS string) AS animal_orig_cd,
  CAST(NULL AS string) AS animal_orig_nm,
  CAST(NULL AS string) AS apo_relevant_flg,
  CAST(NULL AS string) AS auto_purch_ord_flg,
  CAST(NULL AS string) AS avail_check_grp_cd,
  CAST(NULL AS string) AS avail_check_grp_nm,
  CAST(NULL AS string) AS backflush_ind,
  CAST(NULL AS decimal(38,6)) AS base_qty,
  (CASE WHEN plant.lvorm IS NULL OR plant.lvorm = '' THEN 'N' ELSE 'Y' END) AS plant_lvl_del_flg,
  (CASE WHEN plant.mmstd = '00000000' THEN NULL ELSE CAST(SUBSTRING(plant.mmstd, 1, 4) || '-' || SUBSTRING(plant.mmstd, 5, 2) || '-' || SUBSTRING(plant.mmstd, 7, 2) AS DATE) END) AS plant_mtl_stat_dt,
  plant.CSUPPLY_PLANNING_AREA AS sku,
  plant.TSUPPLY_PLANNING_AREA AS sku_nm,
  'byd_brsbn' AS src_sys_cd,
  sap_dim_product_plant.CSUPPLY_PLANNING_AREA AS site_cd,
  '2952' AS profit_center_cd,
  'Large Molecule BIO' AS profit_center_nm,
  sap_dim_master.KCVALPCOMP AS std_cost_amt,
  (CASE WHEN sap_dim_product_plant.insmk IS NULL OR sap_dim_product_plant.insmk = '' THEN 'N' ELSE 'Y' END) AS post_to_inspn_stk_flg,
  (CASE WHEN sap_dim_product_plant.kordb IS NULL OR sap_dim_product_plant.kordb = '' THEN 'N' ELSE 'Y' END) AS src_list_req_flg,
  (CASE WHEN sap_dim_product_plant.ueetk IS NULL OR sap_dim_product_plant.ueetk = '' THEN 'N' ELSE 'Y' END) AS unlmted_over_delvr_flg,
  (CASE WHEN sap_dim_product_plant.verkz IS NULL OR sap_dim_product_plant.verkz = '' THEN 'N' ELSE 'Y' END) AS ver_flg
FROM sap_dim_product_plant plant
LEFT JOIN sap_dim_master master ON plant.CPRODUCT_ID = master.CMATR_INT_ID
LEFT JOIN sap_dim_master sap_dim_master ON sap_dim_product_plant.CPRODUCT_ID = sap_dim_master.CMATR_INT_ID AND sap_dim_product_plant.CSUPPLY_PLANNING_AREA <> '5192'
WHERE plant.CSUPPLY_PLANNING_AREA <> '5192'

-- =============================
-- f_purchase_order_transformation
-- =============================
/**************************************************************************
Artefact Name :- f_purchase_order SQL
Description  :- Fact table for purchase orders, combining current and historical data with deduplication logic.
Description  :- Fact table for purchase orders with deduplication logic
**************************************************************************/

-- Query: f_purchase_order_transformation
-- Pattern: fact_union_dedup
-- Coverage: 120 rows

WITH
po_unified AS (
  SELECT
    *,
    1 as src_priority
  FROM sap_fct_purchase_order
  UNION ALL
  SELECT
    *,
    2 as src_priority
  FROM fct_purchase_order_history
),
po_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY CPO_ID, CITM_ID ORDER BY src_priority) AS rn FROM po_unified) x WHERE rn = 1
)

SELECT
  'byd_brsbn' AS src_sys_cd,
  fct_purchase_order.CPO_ID AS po_nbr,
  fct_purchase_order.CITM_ID AS po_line_nbr,
  fct_purchase_order.CPROCESS_TYPE AS po_type_cd,
  fct_purchase_order.CBUYER AS co_cd,
  fct_purchase_order.KCBU_QUANTITY - fct_purchase_order.KCBU_DLVD_QTY AS base_open_qty,
  CAST(COALESCE(eket.menge * (ekpo.umrez / IF(ekpo.umren = 0, 1, ekpo.umren)), 0) AS DOUBLE) AS base_qty,
  fct_purchase_order.CBU_QNT_UNIT AS base_uom,
  fct_purchase_order.TBU_QNT_UNIT AS base_uom_text,
  fct_purchase_order.CEMPL_RESP AS buyer_cd,
  fct_purchase_order.TEMPL_RESP AS buyer_name,
  CASE WHEN fct_purchase_order.cprocess_type = 'THPA' THEN 'Y' ELSE 'N' END AS vomi_flag,
  CAST(NULL AS string) AS warehouse,
  CAST(NULL AS string) AS warehouse_nm
FROM po_dedup fct_purchase_order
LEFT JOIN sap_dim_supplier_payment_data supplier_data ON TRIM(UPPER(fct_purchase_order.CSELLER)) = TRIM(UPPER(supplier_data.CBP_UUID))
LEFT JOIN sap_dim_org_unit_site org_unit_site ON fct_purchase_order.CRECEIVING_SITE = org_unit_site.CPARTY_ID
LEFT JOIN sap_dim_product_1 product ON fct_purchase_order.CPRD_UUID = product.CMATR_INT_ID
LEFT JOIN d_date d_dt ON CAST(DATE_FORMAT(fct_purchase_order.CITM_CREAT_DATE, 'yyyyMMdd') AS STRING) = CAST(d_dt.dt_key AS STRING)
WHERE fct_purchase_order.CPO_ID IS NOT NULL AND fct_purchase_order.CITM_ID IS NOT NULL AND fct_purchase_order.src_sys_cd IS NOT NULL AND fct_purchase_order.po_nbr IS NOT NULL AND fct_purchase_order.po_line_nbr IS NOT NULL AND fct_purchase_order.po_type_cd IS NOT NULL AND fct_purchase_order.acct_seq_nbr IS NOT NULL AND fct_purchase_order.co_cd IS NOT NULL

-- =============================
-- f_po_recpt_txn_transformation
-- =============================
/**************************************************************************
Artefact Name :- f_po_recpt_txn SQL
Description  :- Generate SQL for the f_po_recpt_txn table based on the provided mappings and schema.
**************************************************************************/

-- Query: f_po_recpt_txn_transformation
-- Pattern: fact_simple
-- Coverage: 38 rows

SELECT
  CONCAT('byd_brsbn', COALESCE(sap.txn_nbr, ''), COALESCE(sap.txn_line_nbr, ''), COALESCE(sap.dw_src_key, '')) AS po_recpt_txn_key,
  'byd_brsbn' AS src_sys_cd,
  sap.txn_nbr AS txn_nbr,
  sap.txn_line_nbr AS txn_line_nbr,
  sap.dw_src_key AS dw_src_key,
  CAST(NULL AS string) AS div_cd,
  CAST(NULL AS string) AS po_recpt_key,
  CAST(NULL AS string) AS recpt_nbr,
  CAST(NULL AS string) AS recpt_line_seq_nbr,
  CAST(NULL AS string) AS po_nbr,
  CAST(NULL AS string) AS po_line_nbr,
  CAST(NULL AS string) AS po_line_type_cd,
  CAST(NULL AS string) AS acct_seq_nbr,
  CAST(NULL AS string) AS match_type_cd,
  CAST(NULL AS string) AS recpt_yr_nbr,
  CAST(NULL AS string) AS co_key,
  CAST(NULL AS string) AS co_cd,
  CAST(NULL AS string) AS prod_key,
  CAST(NULL AS string) AS sku,
  CAST(NULL AS string) AS plant_cd,
  CAST(NULL AS string) AS plant_key,
  CAST(NULL AS string) AS prod_plant_key,
  CAST(NULL AS string) AS suplr_key,
  CAST(NULL AS string) AS suplr_cd,
  CAST(NULL AS string) AS suplr_lot_nbr,
  CAST(NULL AS string) AS erp_lot_nbr,
  CAST(NULL AS string) AS coo_cd,
  CAST(NULL AS string) AS coo_nm,
  CAST(NULL AS string) AS txn_uom_cd,
  CAST(NULL AS string) AS txn_uom_nm,
  CAST(NULL AS double) AS txn_qty,
  CAST(NULL AS string) AS txn_type_cd,
  CAST(NULL AS string) AS src_crt_by,
  CAST(NULL AS timestamp) AS src_crt_ts,
  CAST(NULL AS string) AS src_updt_by,
  CAST(NULL AS timestamp) AS src_updt_ts,
  CAST(NULL AS timestamp) AS rec_crt_ts,
  CAST(NULL AS timestamp) AS rec_updt_ts
FROM sap_fct_po_receipt sap

-- =============================
-- f_supplier_invoice_transformation
-- =============================
/**************************************************************************
Artefact Name :- f_supplier_invoice SQL
Description  :- Fact table for supplier invoices with deduplication logic for current and historical data
**************************************************************************/

-- Query: f_supplier_invoice_transformation
-- Pattern: fact_union_dedup
-- Coverage: 105 rows

WITH
supplier_invoice_unified AS (
  SELECT
    *
  FROM sap_fct_supplier_invoice
  UNION ALL
  SELECT
    *
  FROM fct_purchase_order_history
),
supplier_invoice_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY src_sys_cd, vchr_nbr, vchr_line_nbr, po_nbr, po_line_nbr, fscl_yr_nbr, co_cd ORDER BY src_priority) AS rn FROM supplier_invoice_unified) x WHERE rn = 1
)

SELECT
  'byd_brsbn' AS src_sys_cd,
  fct_supplier_invoice.CINVOICE_DATE AS suplr_invc_dt,
  fct_supplier_invoice.CINVOICE_UUID AS vchr_nbr,
  fct_supplier_invoice.CITEM_ID AS vchr_line_nbr,
  fct_supplier_invoice.CREF_PO AS po_nbr,
  fct_supplier_invoice.CREF_PO_ITEM AS po_line_nbr,
  fct_supplier_invoice.CBUYER AS co_cd,
  fct_supplier_invoice.CINVOICE_YEAR AS fscl_yr_nbr,
  fct_supplier_invoice.CCASHDIS_TERMSCD AS ap_payment_term_cd,
  fct_supplier_invoice.TCASHDIS_TERMSCD AS ap_payment_term_desc
FROM supplier_invoice_dedup fct_supplier_invoice
LEFT JOIN dim_product_1 ON trim(upper(fct_supplier_invoice.cprd_uuid)) = trim(upper(dim_product_1.cmatr_int_id)) AND trim(upper(fct_supplier_invoice.creceiving_site)) = trim(upper(dim_product_1.csite_id))
LEFT OUTER JOIN edp_lkup ON edp_lkup.lkup_key_02 = fct_supplier_invoice.cbuyer AND upper(edp_lkup.lkup_typ_nm) = 'TFS_CO_CD_TO_DIV_CD_BU' AND lower(edp_lkup.lkup_key_01) = 'byd_brsbn'
WHERE fct_supplier_invoice.CSELLER IS NOT NULL

-- =============================
-- d_supplier_transformation
-- =============================
/**************************************************************************
Artefact Name :- d_supplier SQL
Description  :- Dimension table for supplier data with mappings from SAP source tables
**************************************************************************/

-- Query: d_supplier_transformation
-- Pattern: dimension_flat
-- Coverage: 64 rows

SELECT
  (case when lfa1.erdat='00000000' then cast(null as timestamp) else CAST(to_date(lfa1.erdat, 'yyyyMMdd') as timestamp) end) AS addr_crt_dt,
  dim_supplier.CGLO_TRADE_NAME AS alt_suplr_id,
  CAST(NULL AS string) AS cmdty_mgr_nm,
  CAST(NULL AS timestamp) AS contract_begin_dt,
  CAST(NULL AS string) AS contract_comment_txt,
  CAST(NULL AS timestamp) AS contract_end_dt,
  CAST(NULL AS string) AS contract_id,
  CAST(NULL AS string) AS contract_stat_cd,
  CAST(NULL AS string) AS contract_type_nm,
  COALESCE(lfa1.KRAUS, NULL) AS dnb_co_nbr,
  CAST(NULL AS string) AS frt_terms_cd,
  CAST(NULL AS string) AS frt_terms_nm,
  dim_supplier.CINCTM_CODE AS inco_terms_cd,
  dim_supplier.TINCTM_CODE AS inco_terms_nm,
  dim_supplier.CLEI_ID AS lgl_suplr_nm,
  CAST(NULL AS decimal(38,6)) AS mthly_projctd_saving_amt,
  CAST(NULL AS decimal(38,6)) AS mthly_projctd_spend_amt,
  CAST(NULL AS string) AS norm_supplier_type,
  CAST(NULL AS string) AS parent_suplr_nm,
  dim_supplier.CCSH_DSCNT_TRM AS paymt_terms_cd,
  dim_supplier.TCSH_DSCNT_TRM AS paymt_terms_nm,
  CAST(NULL AS string) AS prim_branch_cd,
  CAST(NULL AS string) AS prim_branch_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS status_cd,
  if(lower(trim(dim_supplier.cpur_block_ind)) = 'active' ,'N','Y') AS suplr_active_flg,
  dim_supplier.CFRMTD_PSTL_ADDR AS suplr_addr_line_1,
  CAST(NULL AS string) AS suplr_addr_line_2,
  CAST(NULL AS string) AS suplr_addr_line_3,
  CAST(NULL AS string) AS suplr_addr_line_4,
  CAST(NULL AS string) AS suplr_assgn_grp_cd,
  CAST(NULL AS string) AS suplr_assgn_grp_nm,
  COALESCE(adrc.CITY1, 'Unknown') AS suplr_city_nm,
  CAST(NULL AS string) AS suplr_class_cd,
  CAST(NULL AS string) AS suplr_class_nm,
  COALESCE(lfa1.LAND1, NULL) AS suplr_cntry_cd,
  dim_supplier.TCOUNTRY_CODE AS suplr_cntry_nm,
  CAST(NULL AS string) AS cust_svc_email_txt,
  CAST(NULL AS string) AS cust_svc_contact_nm,
  CAST(NULL AS string) AS cust_svc_phn_area_cd,
  CAST(NULL AS string) AS cust_svc_phn_nbr,
  CAST(NULL AS string) AS suplr_dvrsty_cd,
  CAST(NULL AS string) AS suplr_dvrsty_nm,
  dim_supplier.CEMAIL_URI AS suplr_email_addr,
  COALESCE(lfa1.LIFNR, NULL) AS suplr_id,
  COALESCE(lfa1.BRSCH, NULL) AS suplr_indy_cd,
  CAST(NULL AS string) AS suplr_indy_nm,
  COALESCE(lfa1.spras, NULL) AS suplr_lang_cd,
  CAST(NULL AS string) AS suplr_lang_nm,
  dim_supplier.TBP_UUID AS suplr_nm,
  payment_data.TPAYMENT_METHOD AS paymt_type_cd,
  dim_supplier.CPHONE_NR AS suplr_phn_nbr,
  COALESCE(adrc.POST_CODE1, NULL) AS suplr_pstl_cd,
  dim_supplier.CCREATION_DT AS src_crt_ts,
  dim_supplier.CCHANGE_DT AS src_updt_ts,
  CAST(NULL AS string) AS suplr_rel_cd,
  CAST(NULL AS string) AS suplr_rgn_cd,
  CAST(NULL AS string) AS suplr_rgn_nm,
  CAST(NULL AS string) AS suplr_ship_mode_cd,
  dim_supplier.CREGION_CODE AS suplr_st_cd,
  dim_supplier.TREGION_CODE AS suplr_st_nm,
  dim_supplier.CTAX_ID_NR AS suplr_tax_id,
  payment_data.TACCT_DET_CREDITOR_GROUP_CODE AS suplr_type_cd,
  CAST(NULL AS string) AS suplr_type_nm
FROM sap_dim_supplier dim_supplier
LEFT JOIN sap_dim_master lfa1 ON dim_supplier.CBP_UUID = lfa1.CBP_UUID
LEFT JOIN sap_dim_supplier_payment_data payment_data ON dim_supplier.CBP_UUID = payment_data.CBP_UUID
WHERE dim_supplier.CBP_UUID IS NOT NULL

-- =============================
-- f_po_receipt_transformation
-- =============================
/**************************************************************************
Artefact Name :- f_po_receipt SQL
Description  :- Fact table for purchase order receipts, combining current and historical data with deduplication logic.
**************************************************************************/

-- Query: f_po_receipt_transformation
-- Pattern: fact_union_dedup
-- Coverage: 66 rows

WITH
po_receipt_unified AS (
  SELECT
    *
  FROM sap_fct_po_receipt
  UNION ALL
  SELECT
    *
  FROM fct_po_receipt
),
po_receipt_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY CDELIVERY_UUID, CITEM_ID ORDER BY CDELIVERY_DATE DESC) AS rn FROM po_receipt_unified) x WHERE rn = 1
)

SELECT
  f_po_receipt.CBU_QNT_UNIT AS base_uom,
  IF(base_uom_desc.MSEHL = '', 'Unknown', base_uom_desc.MSEHL) AS base_uom_text,
  f_po_receipt.CBUYER AS business_unit,
  f_po_receipt.CEMPL_RESP AS buyer_id,
  f_po_receipt.TEMPL_RESP AS buyer_name,
  f_po_receipt.CBUYER AS co_cd,
  CASE WHEN t001.WAERS = 'RMB' THEN 'CNY' ELSE t001.WAERS END AS co_curncy_cd,
  f_po_receipt.TBUYER AS co_name,
  CAST(NULL AS STRING) AS contract_end_date,
  IF(ekko.BSTYP IN ('K', 'L'), 'Y', 'N') AS contract_flag,
  CAST(NULL AS STRING) AS contract_start_date,
  CASE WHEN ekko.BSTYP = 'K' THEN 'Contract' WHEN ekko.BSTYP = 'L' THEN 'Sched Agr' ELSE 'NA' END AS contract_type,
  CAST(NULL AS STRING) AS delvr_cmplt_flg,
  'DSD' AS div_cd,
  DATE_FORMAT(DATE_ADD(TO_DATE('1899-12-30'), CAST(f_po_receipt.KCDEL_ST_DT AS INT)), 'yyyyMMdd') AS dock_dt,
  f_po_receipt.CITM_DLV_EDDT AS due_dt,
  f_po_receipt.KCRC_DLVD_AMT AS ext_recpt_co_amt,
  f_po_receipt.KCDLVD_AMT AS ext_recpt_txn_amt,
  CAST(NULL AS STRING) AS fk_orig,
  CAST(NULL AS STRING) AS floor_stock_cd,
  'PSBIOLC' AS hfm_entity,
  CAST(NULL AS STRING) AS inv_loc,
  f_po_receipt.TPRD_UUID AS item_desc,
  f_po_receipt.CITEM_ID AS item_nbr,
  IF(lcr_lkup.lcr_flg IS NOT NULL, lcr_lkup.lcr_flg, 'N') AS lcr_flag,
  IF(lcr_lkup.lcr_reg IS NOT NULL, lcr_lkup.lcr_reg, 'NA') AS lcr_region,
  CAST(NULL AS STRING) AS match_typ_cd,
  CAST(NULL AS STRING) AS match_typ_desc,
  CASE WHEN EKBE.WAERS = 'RMB' THEN 'CNY' ELSE EKBE.WAERS END AS po_curncy_cd,
  f_po_receipt.CITEM_ID AS po_delivry_line_nbr,
  f_po_receipt.CREF_PO_ITEM_UUID AS po_line_nbr,
  CASE WHEN ekpo.pstyp = '0' THEN 'Standard' WHEN ekpo.pstyp = '1' THEN 'Blanket item' WHEN ekpo.pstyp = '2' THEN 'Consignment' WHEN ekpo.pstyp = '3' THEN 'Subcontracting' WHEN ekpo.pstyp = '4' THEN 'Material unknown' WHEN ekpo.pstyp = '5' THEN 'Third-party' WHEN ekpo.pstyp = '6' THEN 'Text' WHEN ekpo.pstyp = '7' THEN 'Stock transfer' WHEN ekpo.pstyp = '8' THEN 'Material group' WHEN ekpo.pstyp = '9' THEN 'Service' ELSE 'Unknown' END AS po_line_type_cd,
  f_po_receipt.CREF_PO_UUID AS po_nbr,
  COALESCE(lfb1.zterm, lfm1.zterm, ekko.zterm) AS po_paymt_terms_cd,
  CAST(NULL AS DOUBLE) AS prod_cost,
  f_po_receipt.CBUYER AS profit_cntr,
  f_po_receipt.CITM_DLV_EDDT AS promise_dt,
  f_po_receipt.CNET_PRC_QTY_UNT AS purch_uom,
  IF(purch_uom_desc.MSEHL = '', 'Unknown', purch_uom_desc.MSEHL) AS purch_uom_text,
  CAST((CASE WHEN MSEG.SHKZG = 'H' THEN COALESCE(MSEG.MENGE, 0) * -1 ELSE COALESCE(MSEG.MENGE, 0) END) AS DOUBLE) AS recpt_base_qty,
  f_po_receipt.KCRC_DLVD_AMT * (CAST(COALESCE(co_curr_mth.co_pmar_rt, 1) AS DOUBLE)) AS recpt_co_pmar_amt,
  CASE WHEN EKBE.WAERS = 'RMB' THEN 'CNY' ELSE EKBE.WAERS END AS recpt_curncy_cd,
  f_po_receipt.CITM_DLV_EDDT AS recpt_date,
  CAST(SUBSTR(MKPF.BLDAT, 1, 6) AS STRING) AS recpt_date_period,
  f_po_receipt.CITEM_ID AS recpt_line_seq_nbr,
  f_po_receipt.CDELIVERY_UUID AS recpt_nbr,
  f_po_receipt.KCDLVD_AMT * txn_curr_mth.txn_pmar_rt AS recpt_pmar_amt,
  CAST((CASE WHEN MSEG.SHKZG = 'H' THEN COALESCE(MSEG.ERFMG, 0) * -1 ELSE COALESCE(MSEG.ERFMG, 0) END) AS DOUBLE) AS recpt_txn_qty,
  CAST(NULL AS STRING) AS recpt_type_cd,
  f_po_receipt.CDELIVERY_YEAR AS recpt_yr_nbr,
  CAST(NULL AS STRING) AS ref_recpt_line_seq_nbr,
  CAST(NULL AS STRING) AS ref_recpt_nbr,
  CAST(NULL AS STRING) AS ref_recpt_yr_nbr,
  f_po_receipt.CRECEIVING_SITE AS site_cd,
  IF(f_po_receipt.CITM_TYPE = 18, 'Direct', 'Indirect') AS spend_type_cd,
  'byd_brsbn' AS src_sys_cd,
  COALESCE(LFM1.zterm, 'NA') AS suplr_paymt_terms_cd,
  f_po_receipt.TCSH_DSCNT_TRM AS suplr_paymt_terms_desc,
  f_po_receipt.CSELLER_UUID AS supplier_id,
  f_po_receipt.TSELLER_UUID AS supplier_name,
  f_po_receipt.CDELIVERY_DATE AS txn_date,
  f_po_receipt.CQUANTITY_UNIT AS txn_uom,
  IF(txn_uom_desc.MSEHL = '', 'Unknown', txn_uom_desc.MSEHL) AS txn_uom_text,
  IF(f_po_receipt.CITM_TYPE = 18, 'Y', 'N') AS vomi_flag,
  CAST(NULL AS STRING) AS warehouse,
  CAST(NULL AS STRING) AS warehouse_nm
FROM po_receipt_dedup f_po_receipt
LEFT JOIN f_purchase_order ON f_po_receipt.CREF_PO_UUID = f_purchase_order.CPO_ID AND f_po_receipt.CREF_PO_ITEM_UUID = f_purchase_order.CITM_ID
LEFT JOIN (SELECT curr_mnth.pmar_rt AS co_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd FROM d_curncy_mth_rt curr_mnth WHERE UPPER(to_curncy_cd) = 'USD') co_curr_mth ON co_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND co_curr_mth.from_curncy_cd = '?'
LEFT JOIN (SELECT curr_mnth.pmar_rt AS txn_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd, curr_mnth.to_curncy_cd FROM d_curncy_mth_rt curr_mnth WHERE TRIM(UPPER(to_curncy_cd)) = 'USD') txn_curr_mth ON txn_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND TRIM(UPPER(txn_curr_mth.from_curncy_cd)) = '?'
WHERE f_po_receipt.CDELIVERY_UUID IS NOT NULL
