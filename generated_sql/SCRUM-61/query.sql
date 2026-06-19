-- Databricks notebook source
-- Generated for: SCRUM-61
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 3: d_product_transformation
--   Pattern: dimension_flat
-- Query 4: d_company_transformation
--   Pattern: dimension_flat
-- Query 5: d_org_unit_transformation
--   Pattern: dimension_flat
-- Query 6: f_po_receipt_transformation
--   Pattern: fact_multi_scenario
-- Query 7: f_purchase_order_transformation
--   Pattern: fact_union_dedup
-- Query 8: d_supplier_transformation
--   Pattern: dimension_flat
-- Query 9: f_po_recpt_txn_transformation
--   Pattern: generic
-- Query 10: d_product_plant_transformation
--   Pattern: dimension_flat
-- Query 11: f_supplier_invoice_transformation
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
  sap_dim_buyer.cee_id AS buyer_cd,
  sap_dim_buyer.tee_id AS buyer_nm,
  'byd_brsbn' AS src_sys_cd
FROM sap_dim_buyer sap_dim_buyer

-- =============================
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
Generated plan for d_gl_acct dimension table
Flat dimension pattern with default handling for unmapped fields
**************************************************************************/

-- Query: d_gl_acct_transformation
-- Pattern: dimension_flat
-- Coverage: 16 rows

SELECT
  dim.ccompany_uuid AS co_cd,
  sap.tcompany_uuid AS co_nm,
  coalesce(sap.ska1.ktopl, CAST(NULL AS string)) AS coa_id,
  sap.CCOST_CTR_UUID AS cost_center_branch_cd,
  sap.TCOST_CTR_UUID AS cost_center_branch_nm,
  CAST(NULL AS string) AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS dtl_lvl_nbr,
  dim.cglacct AS gl_acct_id,
  CAST(NULL AS STRING) AS gl_acct_nm,
  CAST(NULL AS string) AS object_acct_cd,
  CAST(NULL AS string) AS object_acct_cost_type_cd,
  CAST(NULL AS string) AS object_acct_subsdry_nm,
  CAST(NULL AS string) AS object_acct_type_cd,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS subsdry_cd
FROM dim_gl_acct dim
LEFT JOIN sap_dim_gl_acct sap ON dim.ccompany_uuid = sap.tcompany_uuid
WHERE dim.cglacct IS NOT NULL

-- =============================
-- d_product_transformation
-- =============================
/**************************************************************************
This plan generates the d_product dimension table.
It uses sap_dim_product_1 as the leading table and joins sap_dim_org_unit_site where necessary.
Generated plan for d_product dimension table
Based on sap_dim_product_1 as the leading table
**************************************************************************/

-- Query: d_product_transformation
-- Pattern: dimension_flat
-- Coverage: 139 rows
-- WARNING: unresolved items: MARA table is referenced in logic but not included in source_tables or join conditions.

SELECT
  CAST(NULL AS string) AS temp_cond_cd,
  CAST(NULL AS string) AS temp_cond_nm,
  CAST(NULL AS string) AS transp_grp_cd,
  CAST(NULL AS string) AS transp_grp_nm,
  CAST(MARA.MHDHB AS decimal(20,0)) AS ttl_shelf_life_days,
  CAST(NULL AS string) AS unspsc,
  sap.KCGROSS_VOLUME AS vol,
  sap.CGROSS_VOLUME_UNIT_CODE AS vol_uom_cd,
  sap.TGROSS_VOLUME_UNIT_CODE AS vol_uom_nm,
  sap.CGROSS_WEIGHT_UNIT_CODE AS wgt_uom_cd,
  sap.TGROSS_WEIGHT_UNIT_CODE AS wgt_uom_nm,
  sap.KCWIDTH AS width,
  CAST(NULL AS string) AS x_distrb_chain_mtl_stat_cd,
  (case when MARA.MSTDE=00000000 then cast(null as timestamp) else CasT(to_date(MARA.MSTDE, yyyyMMdd) as timestamp) end) AS x_distrb_chain_mtl_stat_dt,
  CAST(NULL AS string) AS x_distrb_chain_mtl_stat_nm,
  IF((MARA.SATNR) = '', 'N', 'Y') AS x_plant_config_flg,
  CAST(NULL AS string) AS x_plant_mtl_stat_cd,
  (case when MARA.MSTDV=00000000 then cast(null as timestamp) else CasT(to_date(MARA.MSTDV, yyyyMMdd) as timestamp) end) AS x_plant_mtl_stat_dt,
  CAST(NULL AS string) AS x_plant_mtl_stat_nm,
  CAST(NULL AS STRING) AS alt_uom_cd,
  CAST(NULL AS STRING) AS alt_uom_nm,
  CAST(NULL AS STRING) AS auth_grp,
  CAST(NULL AS STRING) AS base_uom_cd,
  CAST(NULL AS STRING) AS base_uom_nm,
  CAST(NULL AS STRING) AS batch_mgmt_flg,
  CAST(NULL AS STRING) AS bus_area_cd,
  CAST(NULL AS STRING) AS bus_area_nm,
  CAST(NULL AS STRING) AS cas_reg_nbr,
  CAST(NULL AS STRING) AS client_lvl_del_flg,
  CAST(NULL AS STRING) AS cmdty_cd,
  CAST(NULL AS STRING) AS cmdty_class_cd,
  CAST(NULL AS STRING) AS cmdty_class_nm,
  CAST(NULL AS STRING) AS cmdty_nm,
  CAST(NULL AS STRING) AS co_prod_flg,
  CAST(NULL AS STRING) AS complt_mtl_maint_stat,
  CAST(NULL AS STRING) AS config_flg,
  CAST(NULL AS STRING) AS dang_good_profl_cd,
  CAST(NULL AS STRING) AS dang_good_profl_nm,
  CAST(NULL AS STRING) AS dens_uom_cd,
  CAST(NULL AS STRING) AS dens_uom_nm,
  CAST(NULL AS DECIMAL(26,6)) AS dens_val,
  CAST(NULL AS STRING) AS dim_uom_cd,
  CAST(NULL AS STRING) AS dim_uom_nm,
  CAST(NULL AS STRING) AS doc_chng_nbr,
  CAST(NULL AS STRING) AS doc_nbr,
  CAST(NULL AS STRING) AS doc_page_frmt,
  CAST(NULL AS STRING) AS doc_ver,
  CAST(NULL AS STRING) AS dual_brand_cd,
  CAST(NULL AS INT) AS dw_src_key,
  CAST(NULL AS STRING) AS enriched_cas_reg_nbr,
  CAST(NULL AS STRING) AS extrnl_mtl_grp_cd,
  CAST(NULL AS STRING) AS extrnl_mtl_grp_nm,
  CAST(NULL AS TIMESTAMP) AS first_sold_dt,
  CAST(NULL AS STRING) AS gbl_sls_rank_cd,
  CAST(NULL AS STRING) AS gl_class_cd,
  CAST(NULL AS STRING) AS gl_class_nm,
  CAST(NULL AS DECIMAL(26,6)) AS gross_wgt,
  CAST(NULL AS STRING) AS gtin_nbr,
  CAST(NULL AS STRING) AS haz_class_cd,
  CAST(NULL AS STRING) AS haz_class_nm,
  CAST(NULL AS DECIMAL(11,3)) AS height,
  CAST(NULL AS INT) AS hybris_prod_key,
  CAST(NULL AS STRING) AS ian,
  CAST(NULL AS STRING) AS ian_cat_cd,
  CAST(NULL AS STRING) AS ian_cat_nm,
  CAST(NULL AS STRING) AS indy_sector_cd,
  CAST(NULL AS STRING) AS indy_sector_nm,
  CAST(NULL AS STRING) AS interal_invntry_mtl_nbr,
  CAST(NULL AS STRING) AS intlct_propty,
  CAST(NULL AS STRING) AS intrnl_object_nbr,
  CAST(NULL AS STRING) AS item_cat_grp_cd,
  CAST(NULL AS STRING) AS item_cat_grp_nm,
  CAST(NULL AS DECIMAL(11,3)) AS length,
  CAST(NULL AS STRING) AS low_lvl_cd,
  CAST(NULL AS STRING) AS maint_stat,
  CAST(NULL AS STRING) AS mfgr_nm,
  CAST(NULL AS STRING) AS mfr_part_nbr,
  CAST(NULL AS STRING) AS mfr_part_profl_cd,
  CAST(NULL AS STRING) AS mfr_part_profl_nm,
  CAST(NULL AS DECIMAL(20,0)) AS min_shelf_life_days,
  CAST(NULL AS STRING) AS mtl_grp_cd,
  CAST(NULL AS STRING) AS mtl_grp_nm,
  CAST(NULL AS STRING) AS mtl_type_cd,
  CAST(NULL AS STRING) AS mtl_type_nm,
  CAST(NULL AS DECIMAL(26,6)) AS net_wgt,
  CAST(NULL AS STRING) AS normalized_desc,
  CAST(NULL AS STRING) AS orig_sku,
  CAST(NULL AS STRING) AS pack_mtl_grp_cd,
  CAST(NULL AS STRING) AS pack_mtl_grp_nm,
  CAST(NULL AS STRING) AS pack_mtl_type_cd,
  CAST(NULL AS STRING) AS pack_mtl_type_nm,
  CAST(NULL AS DECIMAL(26,6)) AS pack_uom_conv_factor,
  CAST(NULL AS STRING) AS prcmt_qm_flg,
  CAST(NULL AS STRING) AS prim_site_cd,
  CAST(NULL AS STRING) AS prim_site_nm,
  CAST(NULL AS STRING) AS prod_cat_id,
  CAST(NULL AS STRING) AS prod_desc,
  CAST(NULL AS STRING) AS prod_hier_str,
  CAST(NULL AS STRING) AS prod_inspn_memo,
  CAST(NULL AS STRING) AS prod_line_cd,
  CAST(NULL AS STRING) AS prod_line_nm,
  CAST(NULL AS STRING) AS prod_nm,
  CAST(NULL AS STRING) AS prod_orig_cd,
  CAST(NULL AS STRING) AS prod_orig_nm,
  CAST(NULL AS STRING) AS prod_rept_hier_base,
  CAST(NULL AS STRING) AS prog_nbr,
  CAST(NULL AS STRING) AS prog_nm,
  CAST(NULL AS STRING) AS prog_path_cd,
  CAST(NULL AS STRING) AS prog_path_nm,
  CAST(NULL AS STRING) AS purch_uom_cd,
  CAST(NULL AS STRING) AS purch_uom_nm,
  CAST(NULL AS STRING) AS purch_val_cd,
  CAST(NULL AS STRING) AS purch_val_nm,
  CAST(NULL AS STRING) AS rd_proj_cd,
  CAST(NULL AS STRING) AS rd_proj_nm,
  CAST(NULL AS STRING) AS rev_lvl_assgn_flg,
  CAST(NULL AS INT) AS sell_days,
  CAST(NULL AS INT) AS sheets_cnt,
  CAST(NULL AS STRING) AS ship_cond_cd,
  CAST(NULL AS STRING) AS ship_cond_nm,
  CAST(NULL AS STRING) AS sku,
  CAST(NULL AS TIMESTAMP) AS sku_launch_dt,
  CAST(NULL AS STRING) AS sku_nm,
  CAST(NULL AS STRING) AS sku_size,
  CAST(NULL AS STRING) AS sku_sub_type_cd,
  CAST(NULL AS STRING) AS sku_sup_type_nm,
  CAST(NULL AS STRING) AS sku_type_cd,
  CAST(NULL AS STRING) AS sku_type_nm,
  CAST(NULL AS STRING) AS src_div_cd,
  CAST(NULL AS STRING) AS src_sys_cd,
  CAST(NULL AS INT) AS src_sys_prod_id,
  CAST(NULL AS STRING) AS stk_type_cd,
  CAST(NULL AS STRING) AS stk_type_nm,
  CAST(NULL AS STRING) AS strg_cond_cd,
  CAST(NULL AS STRING) AS strg_cond_nm,
  CAST(NULL AS STRING) AS sub_prod_line_cd,
  CAST(NULL AS STRING) AS sub_prod_line_nm,
  CAST(NULL AS decimal(26,6)) AS adj_unit_mult_nbr,
  CAST(NULL AS string) AS alt_sku
FROM sap_dim_product_1 sap
LEFT JOIN sap_dim_org_unit_site site ON sap.some_key = site.some_key

-- =============================
-- d_company_transformation
-- =============================
/**************************************************************************
Generated plan for d_company dimension table.
**************************************************************************/

-- Query: d_company_transformation
-- Pattern: dimension_flat
-- Coverage: 19 rows

SELECT
  site.ccity_name AS city_nm,
  sap.ccntry_code AS cntry_cd,
  sap.tcntry_code AS cntry_nm,
  sap.cco_id AS co_cd,
  'AUD' AS co_curncy_cd,
  'Australian Dollar' AS co_curncy_nm,
  sap.tco_id AS co_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  (CASE WHEN sap.bukrs IN ('0070', '5000', '1800', '1220', '1000', '0040', '2070', '2000', '2010', '1900', '1530', '1287', '1310', '1030', '1200', '1600', '2030', '0020', '0010', '0110', '2930', '3000', '1520', '1710', '1120', '1150', '2010', '2080', '2040', '1170', '2900', '2090') OR sap.bukrs BETWEEN '1400' AND '1480' THEN 'AIG' ELSE 'NON_AIG' END) AS group_nm,
  'PSBIOLC' AS hfm_entity_cd,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm
FROM sap_dim_company sap
LEFT JOIN sap_dim_org_unit_site site ON site.cparty_id = 4192
WHERE sap.cco_id IS NOT NULL

-- =============================
-- d_org_unit_transformation
-- =============================
/**************************************************************************
Generated plan for d_org_unit dimension table.
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
  CAST(NULL AS string) AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS org_unit_cat_nm,
  sap.CPARTY_ID AS org_unit_cd,
  sap.TPARTY_ID AS org_unit_nm,
  'manufacturing plant' AS org_unit_type,
  CAST(NULL AS string) AS parent_org_unit_cd,
  CAST(NULL AS string) AS parent_org_unit_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  sap.cregion_code AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm,
  sap.cst_name AS street_nm
FROM sap_dim_org_unit_site sap

-- =============================
-- f_po_receipt_transformation
-- =============================
/**************************************************************************
Generated plan for f_po_receipt with multiple scenarios: currency_conversion, sto, uom_conversion.
**************************************************************************/

-- Query: f_po_receipt_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 66 rows

WITH
currency_conversion AS (
  SELECT
    sap.KCRC_DLVD_AMT * (cast(coalesce(co_curr_mth.co_pmar_rt, 1) as double)) AS recpt_co_pmar_amt,
    sap.KCRC_DLVD_AMT * txn_curr_mth.txn_pmar_rt AS recpt_pmar_amt
  FROM sap_fct_po_receipt sap
  LEFT JOIN (select curr_mnth.pmar_rt as co_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd from d_curncy_mth_rt curr_mnth where upper(to_curncy_cd) = 'USD') co_curr_mth ON co_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr
  LEFT JOIN (select curr_mnth.pmar_rt as txn_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd, curr_mnth.to_curncy_cd from d_curncy_mth_rt curr_mnth where trim(upper(to_curncy_cd)) = 'USD') txn_curr_mth ON txn_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr
),
sto AS (
  SELECT
    sap.CITM_TYPE AS sto_item_type,
    CASE WHEN sap.CITM_TYPE = '18' THEN 'Direct' ELSE 'Indirect' END AS spend_type_cd
  FROM sap_fct_po_receipt sap
),
uom_conversion AS (
  SELECT
    sap.CBU_QNT_UNIT AS base_uom,
    sap.TBU_QNT_UNIT AS base_uom_text
  FROM sap_fct_po_receipt sap
)

SELECT * FROM currency_conversion
UNION ALL
SELECT * FROM sto
UNION ALL
SELECT * FROM uom_conversion

-- =============================
-- f_purchase_order_transformation
-- =============================
/**************************************************************************
Generated plan for f_purchase_order with union and deduplication logic.
**************************************************************************/

-- Query: f_purchase_order_transformation
-- Pattern: fact_union_dedup
-- Coverage: 123 rows
-- WARNING: unresolved items: Some fields have incomplete logic or missing source_field/source_table mappings.

WITH
po_unified AS (
  SELECT
    *,
    1 as src_priority
  FROM sap_fct_purchase_order curr
  UNION ALL
  SELECT
    *,
    2 as src_priority
  FROM fct_purchase_order_history hist
),
po_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY CPO_ID, CITM_ID ORDER BY src_priority) AS rn FROM po_unified) x WHERE rn = 1
),
purchase_order_unified AS (
  SELECT
    *,
    1 as src_priority
  FROM sap_fct_purchase_order curr
  UNION ALL
  SELECT
    *,
    2 as src_priority
  FROM fct_purchase_order_history hist
),
purchase_order_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY po_nbr ORDER BY src_priority) AS rn FROM purchase_order_unified) x WHERE rn = 1
)

SELECT
  po.CPO_ID AS po_nbr,
  po.CITM_ID AS po_line_nbr,
  cast(coalesce(eket.menge,0) as double) AS po_qty,
  po.CQUANTITY_UNIT AS po_uom,
  po.TQUANTITY_UNIT AS po_uom_text,
  po.CSELLER AS supplier_cd,
  po.TSELLER AS supplier_name,
  po.CITM_CREAT_DATE AS po_crt_dt,
  CAST(NULL AS string) AS acct_seq_nbr,
  CAST(NULL AS string) AS co_cd,
  CASE WHEN po.cprocess_type = 'THPA' THEN 'Y' ELSE 'N' END AS vomi_flag,
  CAST(NULL AS string) AS warehouse,
  CAST(NULL AS string) AS warehouse_nm,
  CAST(NULL AS DECIMAL(38,6)) AS base_open_qty,
  CAST(NULL AS DOUBLE) AS base_qty,
  CAST(NULL AS STRING) AS base_uom,
  CAST(NULL AS STRING) AS base_uom_text,
  CAST(NULL AS STRING) AS blkt_cd,
  CAST(NULL AS STRING) AS business_unit,
  CAST(NULL AS STRING) AS buyer_cd,
  CAST(NULL AS STRING) AS buyer_name,
  CAST(NULL AS STRING) AS co_curncy_cd,
  CAST(NULL AS STRING) AS co_name,
  CAST(NULL AS STRING) AS coi,
  CAST(NULL AS STRING) AS contract_end_date,
  CAST(NULL AS STRING) AS contract_flag,
  CAST(NULL AS STRING) AS contract_start_date,
  CAST(NULL AS STRING) AS contract_type,
  CAST(NULL AS STRING) AS coo,
  CAST(NULL AS STRING) AS cost_centre_cd,
  CAST(NULL AS STRING) AS cost_centre_nm,
  CAST(NULL AS STRING) AS delvr_cmplt_flg,
  CAST(NULL AS STRING) AS dept_cd,
  CAST(NULL AS STRING) AS div_cd,
  CAST(NULL AS DOUBLE) AS dock_qty,
  CAST(NULL AS STRING) AS due_dt,
  CAST(NULL AS STRING) AS erp_commondity_cd,
  CAST(NULL AS STRING) AS erp_commondity_nm,
  CAST(NULL AS DOUBLE) AS ext_prc_co_amt,
  CAST(NULL AS DOUBLE) AS ext_prc_co_pmar_amt,
  CAST(NULL AS DOUBLE) AS ext_prc_txn_amt,
  CAST(NULL AS DOUBLE) AS ext_prc_txn_pmar_amt,
  CAST(NULL AS STRING) AS floor_stock_cd,
  CAST(NULL AS STRING) AS gl_account,
  CAST(NULL AS STRING) AS gl_acct_id,
  CAST(NULL AS STRING) AS gl_acct_nm,
  CAST(NULL AS STRING) AS good_receipt_ind,
  CAST(NULL AS STRING) AS header_status_cd,
  CAST(NULL AS STRING) AS header_status_nm,
  CAST(NULL AS STRING) AS hfm_entity,
  CAST(NULL AS STRING) AS inco_terms_cd,
  CAST(NULL AS STRING) AS inco_terms_nm,
  CAST(NULL AS STRING) AS inv_flg,
  CAST(NULL AS STRING) AS inv_flg_text,
  CAST(NULL AS STRING) AS item_desc,
  CAST(NULL AS STRING) AS item_nbr,
  CAST(NULL AS STRING) AS item_status_cd,
  CAST(NULL AS STRING) AS item_status_nm,
  CAST(NULL AS STRING) AS job_no,
  CAST(NULL AS STRING) AS last_recpt_dt,
  CAST(NULL AS STRING) AS lcr_flag,
  CAST(NULL AS STRING) AS lcr_region,
  CAST(NULL AS DECIMAL(3,0)) AS line_seq,
  CAST(NULL AS STRING) AS nature,
  CAST(NULL AS STRING) AS nature_nm,
  CAST(NULL AS DOUBLE) AS open_qty,
  CAST(NULL AS DOUBLE) AS open_txn_amt,
  CAST(NULL AS DOUBLE) AS open_txn_pmar_amt,
  CAST(NULL AS DOUBLE) AS orig_po_qty,
  CAST(NULL AS STRING) AS part_rev_no,
  CAST(NULL AS STRING) AS pass_through_field,
  CAST(NULL AS STRING) AS pass_through_line,
  CAST(NULL AS STRING) AS payment_compliance_flg,
  CAST(NULL AS STRING) AS paymt_terms_cd,
  CAST(NULL AS STRING) AS paymt_terms_desc,
  CAST(NULL AS STRING) AS plan_delvry_dt,
  CAST(NULL AS STRING) AS planner_cd,
  CAST(NULL AS STRING) AS planner_name,
  CAST(NULL AS STRING) AS approval_dt_key,
  CAST(NULL AS STRING) AS complt_dt_key,
  CAST(NULL AS STRING) AS po_crt_period,
  CAST(NULL AS STRING) AS po_curncy_cd,
  CAST(NULL AS STRING) AS po_hdr_desc,
  CAST(NULL AS STRING) AS po_line_del_flg,
  CAST(NULL AS STRING) AS po_line_sq,
  CAST(NULL AS STRING) AS po_line_type_cd,
  CAST(NULL AS STRING) AS po_line_type_nm,
  CAST(NULL AS STRING) AS ship_to_city_nm,
  CAST(NULL AS STRING) AS ship_to_cntry_cd,
  CAST(NULL AS STRING) AS ship_to_entity_type_nm,
  CAST(NULL AS STRING) AS po_ship_to_name,
  CAST(NULL AS STRING) AS po_type_cd,
  CAST(NULL AS STRING) AS po_type_nm,
  CAST(NULL AS STRING) AS profit_cntr,
  CAST(NULL AS STRING) AS purch_org_id,
  CAST(NULL AS STRING) AS purch_uom,
  CAST(NULL AS STRING) AS purch_uom_text,
  CAST(NULL AS STRING) AS ref_no,
  CAST(NULL AS STRING) AS release_dt,
  CAST(NULL AS STRING) AS reporting_site,
  CAST(NULL AS DOUBLE) AS returned_qty,
  CAST(NULL AS STRING) AS sec_supp_cd,
  CAST(NULL AS STRING) AS site_id,
  CAST(NULL AS STRING) AS spend_typ_cd,
  CAST(NULL AS STRING) AS src_crt_by,
  CAST(NULL AS STRING) AS src_crt_ts,
  CAST(NULL AS STRING) AS src_sys_cd,
  CAST(NULL AS DOUBLE) AS stk_unit_price,
  CAST(NULL AS DOUBLE) AS stock_qty,
  CAST(NULL AS STRING) AS suplr_cat_no,
  CAST(NULL AS STRING) AS suplr_confrm_dt,
  CAST(NULL AS STRING) AS suplr_promise_delv_dt,
  CAST(NULL AS STRING) AS supplier_type_cd,
  CAST(NULL AS DOUBLE) AS ttl_recpt_qty,
  CAST(NULL AS DOUBLE) AS txn_co_exch_rt,
  CAST(NULL AS STRING) AS unit,
  CAST(NULL AS STRING) AS unit_nm,
  CAST(NULL AS DOUBLE) AS unit_prc_co_amt,
  CAST(NULL AS DOUBLE) AS unit_prc_co_pmar_amt,
  CAST(NULL AS DOUBLE) AS unit_prc_txn_amt,
  CAST(NULL AS DOUBLE) AS unit_prc_txn_pmar_amt,
  CAST(NULL AS DOUBLE) AS uom_conv_factor,
  CAST(NULL AS STRING) AS vendor_mat_no
FROM po_dedup po
LEFT JOIN (select curr_mnth.PMAR_RT as CO_PMAR_RT, curr_mnth.CURNCY_MTH_RT_KEY, curr_mnth.YR_MTH_NBR, if(curr_mnth.FROM_CURNCY_CD='CNY','RMB',curr_mnth.FROM_CURNCY_CD) FROM_CURNCY_CD from d_curncy_mth_rt curr_mnth where TO_CURNCY_CD = 'USD') co_curr_mth ON trim(upper(co_curr_mth.YR_MTH_NBR)) = trim(upper(d_dt.fscl_yr_prd_nbr)) AND trim(upper(co_curr_mth.FROM_CURNCY_CD)) = 'USD'
LEFT JOIN (select curr_mnth.PMAR_RT as po_PMAR_RT, curr_mnth.CURNCY_MTH_RT_KEY, curr_mnth.YR_MTH_NBR, if(curr_mnth.FROM_CURNCY_CD='CNY','RMB',curr_mnth.FROM_CURNCY_CD) FROM_CURNCY_CD from d_curncy_mth_rt curr_mnth where TO_CURNCY_CD = 'USD') txn_curr_mth ON trim(upper(txn_curr_mth.YR_MTH_NBR)) = trim(upper(d_dt.fscl_yr_prd_nbr)) AND trim(upper(txn_curr_mth.FROM_CURNCY_CD)) = 'USD'
LEFT JOIN (select kcvalpcomp, cmatr_int_id, row_number() over (partition by cmatr_int_id order by csupplier_id asc) as rank from dim_master where trim(upper(dim_master.csupply_planning_area)) != '5192') dim_master ON trim(upper(dim_product_plant.cproduct_id)) = trim(upper(dim_master.cmatr_int_id)) AND rank = 1

-- =============================
-- d_supplier_transformation
-- =============================
/**************************************************************************
Generated plan for d_supplier dimension table.
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
  if(lower(trim(dim_supplier.cpur_block_ind)) = 'active' ,'N','Y') as suplr_active_flg,
  dim_supplier.CFRMTD_PSTL_ADDR AS suplr_addr_line_1,
  dim_supplier.Address AS suplr_addr_line_2,
  dim_supplier.Address AS suplr_addr_line_3,
  dim_supplier.Address AS suplr_addr_line_4,
  CAST(NULL AS string) AS suplr_assgn_grp_cd,
  CAST(NULL AS string) AS suplr_assgn_grp_nm,
  CAST(NULL AS STRING) AS suplr_city_nm,
  CAST(NULL AS string) AS suplr_class_cd,
  CAST(NULL AS string) AS suplr_class_nm,
  COALESCE(lfa1.LAND1, NULL) AS suplr_cntry_cd,
  dim_supplier.TCOUNTRY_CODE AS suplr_cntry_nm,
  CAST(NULL AS string) AS cust_svc_email_txt_suplr_contact_email_addr_cust_serv,
  CAST(NULL AS string) AS cust_svc_contact_nm_suplr_contact_nm_cust_serv,
  CAST(NULL AS string) AS cust_svc_phn_area_cd,
  CAST(NULL AS string) AS cust_svc_phn_nbr_suplr_contact_phn_nbr_cust_serv,
  CAST(NULL AS string) AS suplr_dvrsty_cd,
  CAST(NULL AS string) AS suplr_dvrsty_nm,
  dim_supplier.CEMAIL_URI AS suplr_email_addr,
  COALESCE(lfa1.LIFNR, NULL) AS suplr_id,
  COALESCE(lfa1.BRSCH, NULL) AS suplr_indy_cd,
  CAST(NULL AS string) AS suplr_indy_nm,
  COALESCE(lfa1.spras, NULL) AS suplr_lang_cd,
  CAST(NULL AS string) AS suplr_lang_nm,
  dim_supplier.TBP_UUID AS suplr_nm,
  payment_data.TPAYMENT_METHOD AS paymt_type_cd_suplr_paymt_typ,
  dim_supplier.CPHONE_NR AS suplr_phn_nbr,
  COALESCE(adrc.POST_CODE1, ?) AS suplr_pstl_cd,
  dim_supplier.CCREATION_DT AS src_crt_ts_suplr_crt_ts,
  dim_supplier.CCHANGE_DT AS src_updt_ts_suplr_updt_ts,
  CAST(NULL AS string) AS suplr_rel_cd,
  CAST(NULL AS string) AS suplr_rgn_cd,
  CAST(NULL AS string) AS suplr_rgn_nm,
  CAST(NULL AS string) AS suplr_ship_mode_cd_suplr_shipment_mode,
  dim_supplier.CREGION_CODE AS suplr_st_cd,
  dim_supplier.TREGION_CODE AS suplr_st_nm,
  dim_supplier.CTAX_ID_NR AS suplr_tax_id_suplr_tax_nbr,
  payment_data.TACCT_DET_CREDITOR_GROUP_CODE AS suplr_type_cd,
  CAST(NULL AS string) AS suplr_type_nm
FROM sap_dim_supplier dim_supplier
LEFT JOIN sap_dim_supplier_payment_data payment_data ON payment_data.CBP_UUID = dim_supplier.CBP_UUID

-- =============================
-- f_po_recpt_txn_transformation
-- =============================
/**************************************************************************
Generated plan for f_po_recpt_txn based on provided mappings.
**************************************************************************/

-- Query: f_po_recpt_txn_transformation
-- Pattern: generic
-- Coverage: 38 rows
-- WARNING: unresolved items: No source_field or logic provided for most fields. Defaulting to CAST(NULL AS <data_type>).

SELECT
  CAST(NULL AS string) AS po_recpt_txn_key,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS txn_nbr,
  CAST(NULL AS string) AS txn_line_nbr,
  CAST(NULL AS string) AS dw_src_key,
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
-- d_product_plant_transformation
-- =============================
/**************************************************************************
Generated plan for d_product_plant dimension table.
**************************************************************************/

-- Query: d_product_plant_transformation
-- Pattern: dimension_flat
-- Coverage: 192 rows

SELECT
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
  CAST(NULL AS string) AS batch_mgmt_flg,
  CAST(NULL AS string) AS bom_usage_cd,
  CAST(NULL AS string) AS bom_usage_nm,
  CAST(NULL AS string) AS bulk_mtl_flg,
  CAST(NULL AS string) AS buyer_cd,
  CAST(NULL AS string) AS buyer_nm,
  CAST(NULL AS string) AS cc_ind_fixed_flg,
  CAST(NULL AS string) AS certf_type_cd,
  CAST(NULL AS string) AS certf_type_nm,
  CAST(NULL AS string) AS cmdty_cd_uom_cd,
  CAST(NULL AS string) AS cmdty_cd_uom_nm,
  CAST(NULL AS string) AS cmdty_import_cd,
  CAST(NULL AS string) AS cmdty_import_nm,
  CAST(NULL AS string) AS co_prod_flg,
  CAST(NULL AS string) AS commsn_flg,
  CAST(NULL AS int) AS comsmp_bckwrd_prd,
  CAST(NULL AS int) AS comsmp_frwrd_prd,
  CAST(NULL AS string) AS comsmp_mode,
  CAST(NULL AS string) AS comsmp_tax_cntrl_cd,
  CAST(NULL AS string) AS comsmp_tax_cntrl_nm,
  CAST(NULL AS string) AS coverage_range_profl_cd,
  CAST(NULL AS string) AS coverage_range_profl_nm,
  CAST(NULL AS string) AS critical_part_flg,
  CAST(NULL AS string) AS dependent_req_ind,
  CAST(NULL AS string) AS dis_continuation_ind,
  CAST(NULL AS string) AS doc_flg,
  (case when marc.ausdt ='00000000' then null
else
cast(substring(marc.ausdt,1,4)||'-'|| substring(marc.ausdt,5,2)||'-'|| substring(marc.ausdt,7,2) as date) 
end ) AS eff_end_dt,
  CAST(NULL AS string) AS export_import_mtl_grp_cd,
  CAST(NULL AS string) AS export_import_mtl_grp_nm,
  CAST(NULL AS string) AS extrnl_prcmt_deflt_strg_loc_cd,
  CAST(NULL AS string) AS extrnl_prcmt_deflt_strg_loc_nm,
  CAST(NULL AS string) AS fcst_model_auto_reset_flg,
  CAST(NULL AS decimal(38,6)) AS fixed_lot_size_qty,
  CAST(NULL AS string) AS follow_up_sku,
  CAST(NULL AS string) AS fscl_yr_var_cd,
  CAST(NULL AS string) AS fscl_yr_var_nm,
  CAST(NULL AS decimal(38,6)) AS in_house_prod_time,
  CAST(NULL AS string) AS inspn_setup_flg,
  CAST(NULL AS decimal(38,6)) AS intoper_time,
  CAST(NULL AS int) AS intrnl_object_nbr,
  CAST(NULL AS string) AS inv_flg,
  CAST(NULL AS string) AS invntry_cycle_cnt_cat_cd,
  CAST(NULL AS string) AS invntry_cycle_cnt_cat_nm,
  CAST(NULL AS string) AS issue_strg_loc_cd,
  CAST(NULL AS string) AS issue_strg_loc_nm,
  CAST(NULL AS string) AS issue_uom_cd,
  CAST(NULL AS string) AS issue_uom_nm,
  CAST(NULL AS string) AS item_accnt_class_cd,
  CAST(NULL AS string) AS item_accnt_class_desc,
  CAST(NULL AS string) AS item_cls_cd,
  CAST(NULL AS string) AS item_cls_nm,
  CAST(NULL AS string) AS item_pool_cd,
  CAST(NULL AS string) AS item_pool_nm,
  CAST(NULL AS string) AS item_revision,
  CAST(NULL AS string) AS item_stat_cd,
  CAST(NULL AS string) AS item_stat_nm,
  CAST(NULL AS int) AS lead_tm_lvl_nbr,
  CAST(NULL AS string) AS load_grp_cd,
  CAST(NULL AS string) AS load_grp_nm,
  CAST(NULL AS string) AS logs_hndlg_grp_cd,
  CAST(NULL AS string) AS logs_hndlg_grp_nm,
  CAST(NULL AS decimal(38,6)) AS lot_size_qty,
  CAST(NULL AS string) AS maint_stat,
  CAST(NULL AS string) AS mardh_rec_exist_flg,
  CAST(NULL AS decimal(38,6)) AS max_lot_size_qty,
  CAST(NULL AS decimal(38,6)) AS max_stk_qty,
  CAST(NULL AS bigint) AS max_strg_prd,
  CAST(NULL AS string) AS max_strg_prd_uom,
  CAST(NULL AS int) AS mfg_lead_tm_days_nbr,
  CAST(NULL AS decimal(38,6)) AS min_lot_size_qty,
  CAST(NULL AS decimal(38,6)) AS min_sfty_stk_qty,
  CAST(NULL AS string) AS mixed_mrp_flg,
  CAST(NULL AS string) AS mrp_grp_cd,
  CAST(NULL AS string) AS mrp_grp_nm,
  CAST(NULL AS string) AS mrp_profl_cd,
  CAST(NULL AS string) AS mrp_profl_nm,
  CAST(NULL AS string) AS mrp_type_cd,
  CAST(NULL AS string) AS mrp_type_nm,
  CAST(NULL AS string) AS mtl_cfop_cat,
  CAST(NULL AS string) AS mtl_config_cd,
  CAST(NULL AS string) AS mtl_config_nm,
  CAST(NULL AS string) AS mtl_frt_grp_cd,
  CAST(NULL AS string) AS mtl_frt_grp_nm,
  CAST(NULL AS string) AS mtl_plang_lots_size_cd,
  CAST(NULL AS string) AS mtl_plang_lots_size_nm,
  CAST(NULL AS string) AS mtl_planr_cd,
  CAST(NULL AS string) AS mtl_planr_nm,
  CAST(NULL AS string) AS not_cost_flg,
  CAST(NULL AS string) AS on_hand_rank_abc_ind,
  CAST(NULL AS decimal(38,6)) AS ord_cost_amt,
  CAST(NULL AS string) AS orig_cntry_cd,
  CAST(NULL AS string) AS orig_cntry_nm,
  CAST(NULL AS string) AS orig_rgn_cd,
  CAST(NULL AS string) AS orig_rgn_nm,
  CAST(NULL AS decimal(38,6)) AS over_delvr_tol_lmt,
  CAST(NULL AS string) AS pharm_prod_cas_cd,
  CAST(NULL AS string) AS pharm_prod_cas_nm,
  CAST(NULL AS decimal(38,6)) AS pland_delvr_days,
  CAST(NULL AS string) AS plang_strat_grp_cd,
  CAST(NULL AS string) AS plang_strat_grp_nm,
  CAST(NULL AS decimal(38,6)) AS plang_time_fence,
  CAST(NULL AS string) AS plant_cd,
  CAST(NULL AS string) AS plant_lvl_del_flg,
  CAST(NULL AS string) AS plant_mtl_stat_cd,
  (case when marc.mmstd ='00000000' then null
else
cast(substring(marc.mmstd,1,4)||'-'|| substring(marc.mmstd,5,2)||'-'|| substring(marc.mmstd,7,2) as date) 
end ) AS plant_mtl_stat_dt,
  CAST(NULL AS string) AS plant_mtl_stat_nm,
  CAST(NULL AS string) AS plant_nm,
  CAST(NULL AS double) AS plant_to_plant_stk_in_transfer,
  CAST(NULL AS int) AS post_prd,
  CAST(NULL AS int) AS post_prd_fscl_yr,
  (CASE WHEN marc.insmk IS NULL OR marc.insmk = '' THEN 'N' ELSE 'Y' END) AS post_to_inspn_stk_flg,
  CAST(NULL AS string) AS ppc_plang_cal_cd,
  CAST(NULL AS string) AS ppc_plang_cal_nm,
  CAST(NULL AS string) AS prcmt_qual_mgmt_cd,
  CAST(NULL AS string) AS prcmt_qual_mgmt_nm,
  CAST(NULL AS string) AS prcmt_type,
  CAST(NULL AS string) AS prd_ind,
  CAST(NULL AS decimal(38,6)) AS proc_time,
  CAST(NULL AS string) AS prod_cat_4_cd,
  CAST(NULL AS string) AS prod_cat_4_nm,
  CAST(NULL AS string) AS prod_cat_5_cd,
  CAST(NULL AS string) AS prod_cat_5_nm,
  CAST(NULL AS string) AS prod_cat_6_cd,
  CAST(NULL AS string) AS prod_cat_6_nm,
  CAST(NULL AS string) AS prod_grp_cd,
  CAST(NULL AS string) AS prod_grp_nm,
  CAST(NULL AS string) AS prod_identifier,
  CAST(NULL AS string) AS prod_mov_cd,
  CAST(NULL AS string) AS prod_mov_nm,
  CAST(NULL AS string) AS prod_sched_profl_cd,
  CAST(NULL AS string) AS prod_sched_profl_nm,
  CAST(NULL AS string) AS prod_supvr_cd,
  CAST(NULL AS string) AS prod_supvr_nm,
  '2952' AS profit_center_cd,
  'Large Molecule BIO' AS profit_center_nm,
  CAST(NULL AS string) AS purch_grp_cd,
  CAST(NULL AS string) AS purch_grp_nm,
  CAST(NULL AS decimal(38,6)) AS purch_ord_round_qty,
  CAST(NULL AS string) AS qm_activity_mtl_auth_grp_cd,
  CAST(NULL AS string) AS qm_activity_mtl_auth_grp_nm,
  CAST(NULL AS decimal(38,6)) AS recpt_proc_days,
  CAST(NULL AS decimal(38,6)) AS recu_inspn_intvl,
  CAST(NULL AS decimal(38,6)) AS reord_point_qty,
  (CASE WHEN marc.sauft IS NULL OR marc.sauft = ' ' THEN 'N' ELSE 'Y' END) AS rept_mfg_flg,
  CAST(NULL AS string) AS rept_mfg_profl_cd,
  CAST(NULL AS string) AS rept_mfg_profl_nm,
  CAST(NULL AS string) AS req_grp_ind,
  CAST(NULL AS string) AS sched_mrgn_cd,
  CAST(NULL AS string) AS sched_mrgn_nm,
  CAST(NULL AS string) AS serial_nbr_profl_cd,
  CAST(NULL AS string) AS serial_nbr_profl_nm,
  CAST(NULL AS decimal(38,6)) AS sfty_stk_qty,
  CAST(NULL AS decimal(38,6)) AS sfty_time_days,
  CAST(NULL AS string) AS sfty_time_ind,
  CAST(NULL AS decimal(38,6)) AS ship_cap_plang_base_qty,
  sap.CSUPPLY_PLANNING_AREA AS site_cd,
  sap.CPRODUCT_ID AS sku,
  sap.TPRODUCT_ID AS sku_nm,
  CAST(NULL AS string) AS sku_nm_lcl,
  CAST(NULL AS string) AS sls_rank_cd,
  CAST(NULL AS string) AS sls_rank_nm,
  CAST(NULL AS string) AS special_prcmt_type_cd,
  CAST(NULL AS string) AS special_prcmt_type_nm,
  CAST(NULL AS string) AS splitting_ind,
  (CASE WHEN marc.kordb IS NULL OR marc.kordb = ' ' THEN 'N' ELSE 'Y' END) AS src_list_req_flg,
  'byd_brsbn' AS src_sys_cd,
  sap_dim_master.KCVALPCOMP AS std_cost_amt,
  CAST(NULL AS decimal(38,2)) AS suplr_lead_time,
  CAST(NULL AS decimal(38,6)) AS svc_lvl_nbr,
  CAST(NULL AS string) AS transit_matrix_mtl_grp,
  CAST(NULL AS decimal(38,6)) AS transit_stk_qty,
  CAST(NULL AS decimal(38,6)) AS ttl_repln_lead_time_days,
  CAST(NULL AS decimal(38,6)) AS under_delvr_tol_lmt,
  (CASE WHEN marc.ueetk IS NULL OR marc.ueetk = ' ' THEN 'N' ELSE 'Y' END) AS unlmted_over_delvr_flg,
  CAST(NULL AS string) AS val_cat_cd,
  CAST(NULL AS string) AS val_cat_nm,
  CAST(NULL AS string) AS val_strm_cd,
  CAST(NULL AS string) AS val_strm_nm,
  CAST(NULL AS string) AS var_cd,
  CAST(NULL AS string) AS var_nm,
  (CASE WHEN marc.verkz IS NULL OR marc.verkz = '' THEN 'N' ELSE 'Y' END) AS ver_flg
FROM sap_dim_product_plant sap

-- =============================
-- f_supplier_invoice_transformation
-- =============================
/**************************************************************************
Generated plan for f_supplier_invoice with union and deduplication logic.
**************************************************************************/

-- Query: f_supplier_invoice_transformation
-- Pattern: fact_union_dedup
-- Coverage: 105 rows

WITH
currency_conversion_view AS (
  SELECT
    src.fcurr AS from_curncy_cd,
    src.tcurr AS to_curncy_cd,
    src.kurst AS rate_type,
    src.gdatu AS valid_from,
    src.ffact,
    src.tfact,
    src.ukurs AS exchange_rate,
    CASE
      WHEN src.fcurr = 'JPY' OR src.fcurr = 'KRW' THEN src.ukurs * 100
      WHEN src.fcurr = 'RMB' THEN src.ukurs
      ELSE src.ukurs
    END AS adjusted_rate
  FROM tcurf src
  WHERE src.tcurr = 'USD'
),
invoice_dt_lookup AS (
  SELECT
    vbfa.vbelv AS order_vbeln,
    vbfa.posnv AS order_posnr,
    MIN(vbfa.erdat) AS first_invoice_dt,
    MAX(vbfa.erdat) AS last_invoice_dt
  FROM vbfa vbfa
  WHERE vbfa.vbtyp_n = 'M'
  GROUP BY vbfa.vbelv, vbfa.posnv
),
supplier_invoice_unified AS (
  SELECT
    *,
    1 as src_priority
  FROM sap_fct_supplier_invoice curr
  UNION ALL
  SELECT
    *,
    2 as src_priority
  FROM fct_purchase_order_history hist
),
supplier_invoice_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY CINVOICE_UUID ORDER BY src_priority) AS rn FROM supplier_invoice_unified) x WHERE rn = 1
)

SELECT
  fct.CTRANSACT_DATE AS actual_payment_dt,
  fct.CCASHDIS_TERMSCD AS ap_payment_term_cd,
  fct.TCASHDIS_TERMSCD AS ap_payment_term_desc,
  fct.CTRANSACT_DATE AS aprval_dt,
  CAST(NULL AS STRING) AS base_qty,
  CAST(NULL AS STRING) AS base_uom_cd,
  CAST(NULL AS STRING) AS business_unit,
  CAST(NULL AS string) AS buyer_cd,
  CAST(NULL AS string) AS buyer_name,
  fct.CBUYER AS co_cd,
  if(t001.waers='RMB','CNY',t001.waers) AS co_curncy_cd,
  cast(co_curr_mth.co_pmar_rt as double) AS co_curncy_mth_rt,
  fct.TBUYER AS co_name,
  CAST(NULL AS string) AS contract_end_date,
  CAST(NULL AS string) AS contract_flag,
  CAST(NULL AS string) AS contract_start_date,
  CAST(NULL AS string) AS contract_type,
  fct.CCOST_CENTER AS cost_centre_cd,
  fct.TCOST_CENTER AS cost_centre_nm,
  'DSD' AS div_cd,
  fct.CINVOICE_TYCD AS document_type,
  CAST(NULL AS string) AS erp_commondity_cd,
  CAST(NULL AS string) AS erp_commondity_nm,
  CAST(NULL AS BIGINT) AS fk_orig,
  CAST(NULL AS STRING) AS floor_stock_cd,
  CAST(NULL AS STRING) AS fscl_yr_nbr,
  CAST(NULL AS STRING) AS gl_acct_id,
  CAST(NULL AS STRING) AS gl_acct_nm,
  CAST(NULL AS STRING) AS hfm_entity,
  CAST(NULL AS STRING) AS inv_flg,
  CAST(NULL AS STRING) AS inv_line_desc,
  CAST(NULL AS STRING) AS invc_apprv_id,
  CAST(NULL AS DOUBLE) AS invc_co_amt,
  CAST(NULL AS DOUBLE) AS invc_co_pmar_amt,
  CAST(NULL AS STRING) AS invc_entry_dt,
  CAST(NULL AS STRING) AS invc_entry_period,
  CAST(NULL AS STRING) AS invc_post_dt,
  CAST(NULL AS DOUBLE) AS invc_qty,
  CAST(NULL AS STRING) AS invc_receipt_dt,
  CAST(NULL AS DOUBLE) AS invc_txn_amt,
  CAST(NULL AS DOUBLE) AS invc_txn_pmar_amt,
  CAST(NULL AS STRING) AS invc_txn_type,
  CAST(NULL AS STRING) AS invc_uom_cd,
  CAST(NULL AS STRING) AS item_desc,
  CAST(NULL AS STRING) AS item_nbr,
  CAST(NULL AS STRING) AS lcr_flag,
  CAST(NULL AS STRING) AS lcr_region,
  CAST(NULL AS STRING) AS erp_cat_cd,
  CAST(NULL AS STRING) AS erp_cat_nm,
  CAST(NULL AS STRING) AS nature,
  CAST(NULL AS STRING) AS part_rev_no,
  CAST(NULL AS STRING) AS pass_through_field,
  CAST(NULL AS STRING) AS pass_through_line,
  CAST(NULL AS STRING) AS payment_compliance_flg,
  CAST(NULL AS STRING) AS paymt_due_dt,
  CAST(NULL AS STRING) AS po_curncy_cd,
  CAST(NULL AS STRING) AS po_line_nbr,
  CAST(NULL AS STRING) AS po_nbr,
  CAST(NULL AS STRING) AS po_paymt_terms_cd,
  CAST(NULL AS STRING) AS po_paymt_terms_desc,
  CAST(NULL AS STRING) AS post_yr_mth_nbr,
  CAST(NULL AS STRING) AS profit_cntr,
  CAST(NULL AS STRING) AS remit_to_addr_line_1,
  CAST(NULL AS STRING) AS remit_to_addr_line_2,
  CAST(NULL AS STRING) AS remit_to_addr_line_3,
  CAST(NULL AS STRING) AS remit_to_addr_line_4,
  CAST(NULL AS STRING) AS remit_to_city_nm,
  CAST(NULL AS STRING) AS remit_to_cntry_cd,
  CAST(NULL AS STRING) AS remit_to_cntry_nm,
  CAST(NULL AS STRING) AS remit_to_rgn_cd,
  CAST(NULL AS STRING) AS remit_to_rgn_nm,
  CAST(NULL AS STRING) AS remit_to_st_cd,
  CAST(NULL AS STRING) AS reporting_site,
  CAST(NULL AS STRING) AS rpt_flex1,
  CAST(NULL AS STRING) AS sec_supp_cd,
  CAST(NULL AS STRING) AS site_cd,
  CAST(NULL AS STRING) AS site_name,
  CAST(NULL AS STRING) AS spend_type_cd,
  CAST(NULL AS STRING) AS src_sys_cd,
  CAST(NULL AS STRING) AS suplr_invc_dt,
  CAST(NULL AS STRING) AS suplr_invc_nbr,
  CAST(NULL AS STRING) AS suplr_nm_src,
  CAST(NULL AS STRING) AS suplr_paymt_terms_cd,
  CAST(NULL AS STRING) AS suplr_paymt_terms_desc,
  CAST(NULL AS STRING) AS supplier_cd,
  CAST(NULL AS STRING) AS supplier_name,
  CAST(NULL AS STRING) AS supplier_type_cd,
  CAST(NULL AS STRING) AS thermo_item_nbr,
  CAST(NULL AS DOUBLE) AS txn_curncy_mth_rt,
  CAST(NULL AS STRING) AS txn_orig_id,
  CAST(NULL AS STRING) AS txn_ref_nbr,
  CAST(NULL AS STRING) AS unit,
  CAST(NULL AS DOUBLE) AS unit_prc,
  CAST(NULL AS DOUBLE) AS unit_prc_pmar_amt,
  CAST(NULL AS DOUBLE) AS uom_conv_factor,
  CAST(NULL AS STRING) AS vchr_line_nbr,
  CAST(NULL AS STRING) AS vchr_nbr,
  CAST(NULL AS STRING) AS vchr_status,
  CAST(NULL AS STRING) AS vchr_type_cd,
  CAST(NULL AS STRING) AS vchr_type_desc,
  CAST(NULL AS STRING) AS vendor_mat_no,
  CAST(NULL AS STRING) AS vomi_flag,
  CAST(NULL AS STRING) AS warehouse,
  CAST(NULL AS STRING) AS warehouse_nm,
  CAST(NULL AS STRING) AS document_desc
FROM supplier_invoice_dedup fct
LEFT JOIN dim_product_1 dim_prod ON trim(upper(fct.cprd_uuid)) = trim(upper(dim_prod.cmatr_int_id))
LEFT OUTER JOIN edp_lkup edp ON edp.lkup_key_02 = fct.cbuyer AND upper(edp.lkup_typ_nm) = 'TFS_CO_CD_TO_DIV_CD_BU'
WHERE fct.CSELLER IS NOT NULL AND coalesce(trim(rkwa.belnr), '') != ''
