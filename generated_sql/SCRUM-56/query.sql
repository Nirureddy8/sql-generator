-- Databricks notebook source
-- Generated for: SCRUM-56
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 3: d_company_transformation
--   Pattern: dimension_flat
-- Query 4: d_org_unit_transformation
--   Pattern: dimension_flat
-- Query 5: d_product_transformation
--   Pattern: dimension_flat
-- Query 6: d_product_plant_transformation
--   Pattern: dimension_flat
-- Query 7: f_po_recpt_txn_transformation
--   Pattern: generic
-- Query 8: d_supplier_transformation
--   Pattern: dimension_flat
-- Query 9: f_po_receipt_transformation
--   Pattern: fact_multi_scenario
-- Query 10: f_purchase_order_transformation
--   Pattern: fact_union_dedup
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
Generated plan for d_gl_acct dimension table.
**************************************************************************/

-- Query: d_gl_acct_transformation
-- Pattern: dimension_flat
-- Coverage: 16 rows
-- WARNING: unresolved items: Unclear how to resolve curncy_cd, curncy_nm, dtl_lvl_nbr, object_acct_cd, object_acct_cost_type_cd, object_acct_subsdry_nm, object_acct_type_cd, and subsdry_cd due to missing source_field or logic.

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
  coalesce(SKAT.TXT50, 'Unknown') AS gl_acct_nm,
  CAST(NULL AS string) AS object_acct_cd,
  CAST(NULL AS string) AS object_acct_cost_type_cd,
  CAST(NULL AS string) AS object_acct_subsdry_nm,
  CAST(NULL AS string) AS object_acct_type_cd,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS subsdry_cd
FROM dim_gl_acct dim
LEFT JOIN sap_dim_gl_acct sap ON dim.ccompany_uuid = sap.tcompany_uuid
WHERE dim.ccompany_uuid IS NOT NULL AND dim.cglacct IS NOT NULL

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
  sap_dim_org_unit_site.ccity_name AS city_nm,
  sap_dim_company.ccntry_code AS cntry_cd,
  sap_dim_company.tcntry_code AS cntry_nm,
  sap_dim_company.cco_id AS co_cd,
  'AUD' AS co_curncy_cd,
  'Australian Dollar' AS co_curncy_nm,
  sap_dim_company.tco_id AS co_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CASE WHEN sap_dim_company.bukrs IN ('0070', '5000', '1800', '1220', '1000', '0040', '2070', '2000', '2010', '1900', '1530', '1287', '1310', '1030', '1200', '1600', '2030', '0020', '0010', '0110', '2930', '3000', '1520', '1710', '1120', '1150', '2010', '2080', '2040', '1170', '2900', '2090') OR sap_dim_company.bukrs BETWEEN '1400' AND '1480' THEN 'AIG' ELSE 'NON_AIG' END AS group_nm,
  'PSBIOLC' AS hfm_entity_cd,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm
FROM sap_dim_company sap_dim_company
LEFT JOIN sap_dim_org_unit_site sap_dim_org_unit_site ON sap_dim_org_unit_site.cparty_id = 4192
WHERE sap_dim_company.cco_id IS NOT NULL

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
WHERE sap.CPARTY_ID IS NOT NULL AND sap.TPARTY_ID IS NOT NULL AND sap.cregion_code IS NOT NULL AND sap.ccity_name IS NOT NULL

-- =============================
-- d_product_transformation
-- =============================
/**************************************************************************
Generated plan for d_product dimension table.
**************************************************************************/

-- Query: d_product_transformation
-- Pattern: dimension_flat
-- Coverage: 139 rows
-- WARNING: unresolved items: MARA table is referenced in logic but not listed in source_tables.; No source_field or logic provided for temp_cond_cd, temp_cond_nm, transp_grp_cd, transp_grp_nm, unspsc, x_distrb_chain_mtl_stat_cd, x_distrb_chain_mtl_stat_nm, x_plant_mtl_stat_cd, x_plant_mtl_stat_nm.

WITH
uom_conversion_view AS (
  SELECT
    base.vbeln,
    base.posnr,
    base.matnr,
    base.vrkme,
    base.meins,
    base.bmeng,
    base.netpr,
    marm.umrez,
    marm.umren,
    CASE
      WHEN base.vrkme = base.meins THEN base.bmeng
      WHEN marm.umren = 0 OR marm.umren IS NULL THEN base.bmeng
      ELSE base.bmeng * (marm.umrez / marm.umren)
    END AS qty_primary_uom,
    CASE
      WHEN base.vrkme = base.meins THEN base.netpr
      WHEN marm.umrez = 0 OR marm.umrez IS NULL THEN base.netpr
      ELSE base.netpr * (marm.umren / marm.umrez)
    END AS price_primary_uom
  FROM vbep base
  LEFT JOIN marm marm
    ON marm.matnr = base.matnr
   AND marm.meinh = base.vrkme
),
sto_orders AS (
  SELECT
    ekpo.ebeln AS order_nbr,
    ekpo.ebelp AS order_line_nbr,
    ekpo.matnr AS item_nbr,
    ekpo.werks AS plant_cd,
    ekpo.menge AS order_qty,
    ekpo.meins AS order_uom_cd,
    ekko.bsart AS order_type,
    ekko.bukrs AS order_company_cd,
    ekko.aedat AS order_dt
  FROM ekpo ekpo
  INNER JOIN ekko ekko
    ON ekko.ebeln = ekpo.ebeln
  WHERE ekko.bsart IN ('UB', 'NB')
),
sto_receipts AS (
  SELECT
    ekbe.ebeln,
    ekbe.ebelp,
    ekbe.budat AS receipt_dt,
    ekbe.menge AS receipt_qty,
    ekbe.shkzg
  FROM ekbe ekbe
  WHERE ekbe.bwart IN ('101', '102', '161', '162')
    AND ekbe.vgabe = '1'
),
sto_received_qty AS (
  SELECT
    ebeln,
    ebelp,
    SUM(
      CASE
        WHEN shkzg = 'H' THEN -1 * receipt_qty
        ELSE receipt_qty
      END
    ) AS total_received_qty,
    MAX(receipt_dt) AS last_receipt_dt
  FROM sto_receipts
  GROUP BY ebeln, ebelp
),
sto_joined AS (
  SELECT
    o.*,
    COALESCE(r.total_received_qty, 0) AS total_received_qty,
    r.last_receipt_dt,
    (o.order_qty - COALESCE(r.total_received_qty, 0)) AS open_qty
  FROM sto_orders o
  LEFT JOIN sto_received_qty r
    ON r.ebeln = o.order_nbr
   AND r.ebelp = o.order_line_nbr
)

SELECT
  CAST(NULL AS decimal(26,6)) AS adj_unit_mult_nbr,
  CAST(NULL AS string) AS alt_sku,
  CAST(NULL AS string) AS alt_uom_cd,
  CAST(NULL AS string) AS alt_uom_nm,
  CAST(NULL AS string) AS auth_grp,
  sap_dim_product_1.cbase_measure_unit_code AS base_uom_cd,
  sap_dim_product_1.tbase_measure_unit_code AS base_uom_nm,
  IF((MARA.XCHPF)= ,N,Y) AS batch_mgmt_flg,
  CAST(NULL AS string) AS bus_area_cd,
  CAST(NULL AS string) AS bus_area_nm,
  sap_dim_product_1.cs1ansda32b006df87a0b AS cas_reg_nbr,
  IF((MARA.LVORM)= ,N,Y) AS client_lvl_del_flg,
  CAST(NULL AS string) AS cmdty_cd,
  CAST(NULL AS string) AS cmdty_class_cd,
  CAST(NULL AS string) AS cmdty_class_nm,
  CAST(NULL AS string) AS cmdty_nm,
  IF((MARA.KZKUP)= ,N,Y) AS co_prod_flg,
  CAST(NULL AS string) AS complt_mtl_maint_stat,
  IF((MARA.KZKFG)= ,N,Y) AS config_flg,
  CAST(NULL AS string) AS dang_good_profl_cd,
  CAST(NULL AS string) AS dang_good_profl_nm,
  CAST(NULL AS string) AS dens_uom_cd,
  CAST(NULL AS string) AS dens_uom_nm,
  CAST(NULL AS decimal(26,6)) AS dens_val,
  CAST(NULL AS string) AS dim_uom_cd,
  CAST(NULL AS string) AS dim_uom_nm,
  CAST(NULL AS string) AS doc_chng_nbr,
  CAST(NULL AS string) AS doc_nbr,
  CAST(NULL AS string) AS doc_page_frmt,
  CAST(NULL AS string) AS doc_ver,
  CAST(NULL AS string) AS dual_brand_cd,
  CAST(NULL AS int) AS dw_src_key,
  CAST(NULL AS STRING) AS enriched_cas_reg_nbr,
  CAST(NULL AS string) AS extrnl_mtl_grp_cd,
  CAST(NULL AS string) AS extrnl_mtl_grp_nm,
  CAST(NULL AS timestamp) AS first_sold_dt,
  CAST(NULL AS string) AS gbl_sls_rank_cd,
  CAST(NULL AS string) AS gl_class_cd,
  CAST(NULL AS string) AS gl_class_nm,
  sap_dim_product_1.KCGROSS_WEIGHT AS gross_wgt,
  CAST(NULL AS string) AS gtin_nbr,
  CAST(NULL AS string) AS haz_class_cd,
  CAST(NULL AS string) AS haz_class_nm,
  sap_dim_product_1.KCHEIGHT AS height,
  CAST(NULL AS int) AS hybris_prod_key,
  CAST(NULL AS string) AS ian,
  CAST(NULL AS string) AS ian_cat_cd,
  CAST(NULL AS string) AS ian_cat_nm,
  CAST(NULL AS string) AS indy_sector_cd,
  CAST(NULL AS string) AS indy_sector_nm,
  CAST(NULL AS string) AS interal_invntry_mtl_nbr,
  CAST(NULL AS string) AS intlct_propty,
  CAST(NULL AS string) AS intrnl_object_nbr,
  sap_dim_product_1.CPROD_CATG_UUID_01 AS item_cat_grp_cd,
  sap_dim_product_1.TPROD_CATG_UUID_01 AS item_cat_grp_nm,
  sap_dim_product_1.KCLENGTH AS length,
  CAST(NULL AS string) AS low_lvl_cd,
  CAST(NULL AS string) AS maint_stat,
  CAST(NULL AS string) AS mfgr_nm,
  sap_dim_product_1.Cs1ANsD0A4BBEA40DDD66 AS mfr_part_nbr,
  CAST(NULL AS string) AS mfr_part_profl_cd,
  CAST(NULL AS string) AS mfr_part_profl_nm,
  CAST(NULL AS decimal(20,0)) AS min_shelf_life_days,
  sap_dim_product_1.CPROD_CATG_UUID_01 AS mtl_grp_cd,
  sap_dim_product_1.TPROD_CATG_UUID_01 AS mtl_grp_nm,
  sap_dim_product_1.Cs1ANs6BA9E26842229D1 AS mtl_type_cd,
  sap_dim_product_1.Ts1ANs6BA9E26842229D1 AS mtl_type_nm,
  sap_dim_product_1.KCNET_WEIGHT AS net_wgt,
  CAST(NULL AS STRING) AS normalized_desc,
  CAST(NULL AS string) AS orig_sku,
  CAST(NULL AS string) AS pack_mtl_grp_cd,
  CAST(NULL AS string) AS pack_mtl_grp_nm,
  CAST(NULL AS string) AS pack_mtl_type_cd,
  CAST(NULL AS string) AS pack_mtl_type_nm,
  cast((case when MARM.UMREZ is NULL or MARM.UMREZ=0 then NULL else cast(MARM.UMREN as double)/ MARM.UMREZ end) as decimal(26,6)) AS pack_uom_conv_factor,
  IF((MARA.QMPUR)= ,N,Y) AS prcmt_qm_flg,
  CAST(NULL AS string) AS prim_site_cd,
  CAST(NULL AS string) AS prim_site_nm,
  CAST(NULL AS string) AS prod_cat_id,
  CAST(NULL AS string) AS prod_desc,
  CAST(NULL AS string) AS prod_hier_str,
  CAST(NULL AS string) AS prod_inspn_memo,
  CAST(NULL AS string) AS prod_line_cd,
  CAST(NULL AS string) AS prod_line_nm,
  CAST(NULL AS string) AS prod_nm,
  CAST(NULL AS string) AS prod_orig_cd,
  CAST(NULL AS string) AS prod_orig_nm,
  CAST(NULL AS string) AS prod_rept_hier_base,
  CAST(NULL AS string) AS prog_nbr,
  CAST(NULL AS string) AS prog_nm,
  CAST(NULL AS string) AS prog_path_cd,
  CAST(NULL AS string) AS prog_path_nm,
  CAST(NULL AS string) AS purch_uom_cd,
  CAST(NULL AS string) AS purch_uom_nm,
  CAST(NULL AS string) AS purch_val_cd,
  CAST(NULL AS string) AS purch_val_nm,
  CAST(NULL AS string) AS rd_proj_cd,
  CAST(NULL AS string) AS rd_proj_nm,
  IF((MARA.KZREV)= ,N,Y) as rev_lvl_,
  CAST(NULL AS int) AS sell_days,
  CAST(NULL AS int) AS sheets_cnt,
  CAST(NULL AS string) AS ship_cond_cd,
  CAST(NULL AS string) AS ship_cond_nm,
  sap_dim_product_1.CMATR_INT_ID AS sku,
  CAST(NULL AS timestamp) AS sku_launch_dt,
  sap_dim_product_1.TMATR_INT_ID AS sku_nm,
  CAST(NULL AS string) AS sku_size,
  CAST(NULL AS string) AS sku_sub_type_cd,
  CAST(NULL AS string) AS sku_sup_type_nm,
  CAST(NULL AS string) AS sku_type_cd,
  CAST(NULL AS string) AS sku_type_nm,
  CAST(NULL AS string) AS src_div_cd,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS int) AS src_sys_prod_id,
  CAST(NULL AS string) AS stk_type_cd,
  CAST(NULL AS string) AS stk_type_nm,
  CAST(NULL AS string) AS strg_cond_cd,
  CAST(NULL AS string) AS strg_cond_nm,
  CAST(NULL AS string) AS sub_prod_line_cd,
  CAST(NULL AS string) AS sub_prod_line_nm,
  CAST(NULL AS string) AS temp_cond_cd,
  CAST(NULL AS string) AS temp_cond_nm,
  CAST(NULL AS string) AS transp_grp_cd,
  CAST(NULL AS string) AS transp_grp_nm,
  CAST(MARA.MHDHB AS decimal(20,0)) AS ttl_shelf_life_days,
  CAST(NULL AS string) AS unspsc,
  sap_dim_product_1.KCGROSS_VOLUME AS vol,
  sap_dim_product_1.CGROSS_VOLUME_UNIT_CODE AS vol_uom_cd,
  sap_dim_product_1.TGROSS_VOLUME_UNIT_CODE AS vol_uom_nm,
  sap_dim_product_1.CGROSS_WEIGHT_UNIT_CODE AS wgt_uom_cd,
  sap_dim_product_1.TGROSS_WEIGHT_UNIT_CODE AS wgt_uom_nm,
  sap_dim_product_1.KCWIDTH AS width,
  CAST(NULL AS string) AS x_distrb_chain_mtl_stat_cd,
  (case when MARA.MSTDE=00000000 then cast(null as timestamp) else CasT(to_date(MARA.MSTDE, yyyyMMdd) as timestamp) end) AS x_distrb_chain_mtl_stat_dt,
  CAST(NULL AS string) AS x_distrb_chain_mtl_stat_nm,
  IF((MARA.SATNR)= ,N,Y) AS x_plant_config_flg,
  CAST(NULL AS string) AS x_plant_mtl_stat_cd,
  (case when MARA.MSTDV=00000000 then cast(null as timestamp) else CasT(to_date(MARA.MSTDV, yyyyMMdd) as timestamp) end) AS x_plant_mtl_stat_dt,
  CAST(NULL AS string) AS x_plant_mtl_stat_nm
FROM sap_dim_product_1 sap_dim_product_1

-- =============================
-- d_product_plant_transformation
-- =============================
/**************************************************************************
Generated plan for d_product_plant dimension table.
**************************************************************************/

-- Query: d_product_plant_transformation
-- Pattern: dimension_flat
-- Coverage: 192 rows

WITH
sto_orders AS (
  SELECT
    ekpo.ebeln AS order_nbr,
    ekpo.ebelp AS order_line_nbr,
    ekpo.matnr AS item_nbr,
    ekpo.werks AS plant_cd,
    ekpo.menge AS order_qty,
    ekpo.meins AS order_uom_cd,
    ekko.bsart AS order_type,
    ekko.bukrs AS order_company_cd,
    ekko.aedat AS order_dt
  FROM ekpo ekpo
  INNER JOIN ekko ekko
    ON ekko.ebeln = ekpo.ebeln
  WHERE ekko.bsart IN ('UB', 'NB')
),
sto_receipts AS (
  SELECT
    ekbe.ebeln,
    ekbe.ebelp,
    ekbe.budat AS receipt_dt,
    ekbe.menge AS receipt_qty,
    ekbe.shkzg
  FROM ekbe ekbe
  WHERE ekbe.bwart IN ('101', '102', '161', '162')
    AND ekbe.vgabe = '1'
),
sto_received_qty AS (
  SELECT
    ebeln,
    ebelp,
    SUM(
      CASE
        WHEN shkzg = 'H' THEN -1 * receipt_qty
        ELSE receipt_qty
      END
    ) AS total_received_qty,
    MAX(receipt_dt) AS last_receipt_dt
  FROM sto_receipts
  GROUP BY ebeln, ebelp
),
sto_joined AS (
  SELECT
    o.*,
    COALESCE(r.total_received_qty, 0) AS total_received_qty,
    r.last_receipt_dt,
    (o.order_qty - COALESCE(r.total_received_qty, 0)) AS open_qty
  FROM sto_orders o
  LEFT JOIN sto_received_qty r
    ON r.ebeln = o.order_nbr
   AND r.ebelp = o.order_line_nbr
)

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
  sap_dim_product_plant.CSUPPLY_PLANNING_AREA AS site_cd,
  sap_dim_product_plant.CPRODUCT_ID AS sku,
  sap_dim_product_plant.TPRODUCT_ID AS sku_nm,
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
FROM sap_dim_product_plant sap_dim_product_plant

-- =============================
-- f_po_recpt_txn_transformation
-- =============================
/**************************************************************************
Generated plan for f_po_recpt_txn based on provided mappings and requirements.
**************************************************************************/

-- Query: f_po_recpt_txn_transformation
-- Pattern: generic
-- Coverage: 38 rows
-- WARNING: unresolved items: No source_field or logic provided for most fields. Defaulting to CAST(NULL AS <data_type>).; Primary key po_recpt_txn_key has no source_field or logic.

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
-- d_supplier_transformation
-- =============================
/**************************************************************************
Generated plan for d_supplier dimension table.
**************************************************************************/

-- Query: d_supplier_transformation
-- Pattern: dimension_flat
-- Coverage: 64 rows

WITH
sto_orders AS (
  SELECT
    ekpo.ebeln AS order_nbr,
    ekpo.ebelp AS order_line_nbr,
    ekpo.matnr AS item_nbr,
    ekpo.werks AS plant_cd,
    ekpo.menge AS order_qty,
    ekpo.meins AS order_uom_cd,
    ekko.bsart AS order_type,
    ekko.bukrs AS order_company_cd,
    ekko.aedat AS order_dt
  FROM ekpo ekpo
  INNER JOIN ekko ekko
    ON ekko.ebeln = ekpo.ebeln
  WHERE ekko.bsart IN ('UB', 'NB')
),
sto_receipts AS (
  SELECT
    ekbe.ebeln,
    ekbe.ebelp,
    ekbe.budat AS receipt_dt,
    ekbe.menge AS receipt_qty,
    ekbe.shkzg
  FROM ekbe ekbe
  WHERE ekbe.bwart IN ('101', '102', '161', '162')
    AND ekbe.vgabe = '1'
),
sto_received_qty AS (
  SELECT
    ebeln,
    ebelp,
    SUM(
      CASE
        WHEN shkzg = 'H' THEN -1 * receipt_qty
        ELSE receipt_qty
      END
    ) AS total_received_qty,
    MAX(receipt_dt) AS last_receipt_dt
  FROM sto_receipts
  GROUP BY ebeln, ebelp
),
sto_joined AS (
  SELECT
    o.*,
    COALESCE(r.total_received_qty, 0) AS total_received_qty,
    r.last_receipt_dt,
    (o.order_qty - COALESCE(r.total_received_qty, 0)) AS open_qty
  FROM sto_orders o
  LEFT JOIN sto_received_qty r
    ON r.ebeln = o.order_nbr
   AND r.ebelp = o.order_line_nbr
)

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
  COALESCE(lfa1.KRAUS, CAST(NULL AS string)) AS dnb_co_nbr,
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
  CAST(NULL AS string) AS suplr_addr_line_2,
  CAST(NULL AS string) AS suplr_addr_line_3,
  CAST(NULL AS string) AS suplr_addr_line_4,
  CAST(NULL AS string) AS suplr_assgn_grp_cd,
  CAST(NULL AS string) AS suplr_assgn_grp_nm,
  COALESCE(adrc.CITY1, 'Unknown') AS suplr_city_nm,
  CAST(NULL AS string) AS suplr_class_cd,
  CAST(NULL AS string) AS suplr_class_nm,
  COALESCE(lfa1.LAND1, CAST(NULL AS string)) AS suplr_cntry_cd,
  dim_supplier.TCOUNTRY_CODE AS suplr_cntry_nm,
  CAST(NULL AS string) AS cust_svc_email_txt     suplr_contact_email_addr_cust_serv,
  CAST(NULL AS string) AS cust_svc_contact_nm      suplr_contact_nm_cust_serv,
  CAST(NULL AS string) AS cust_svc_phn_area_cd,
  CAST(NULL AS string) AS cust_svc_phn_nbr    suplr_contact_phn_nbr_cust_serv,
  CAST(NULL AS string) AS suplr_dvrsty_cd,
  CAST(NULL AS string) AS suplr_dvrsty_nm,
  dim_supplier.CEMAIL_URI AS suplr_email_addr,
  COALESCE(lfa1.LIFNR, CAST(NULL AS string)) AS suplr_id,
  COALESCE(lfa1.BRSCH, CAST(NULL AS string)) AS suplr_indy_cd,
  CAST(NULL AS string) AS suplr_indy_nm,
  COALESCE(lfa1.spras, CAST(NULL AS string)) AS suplr_lang_cd,
  CAST(NULL AS string) AS suplr_lang_nm,
  dim_supplier.TBP_UUID AS suplr_nm,
  payment_data.TPAYMENT_METHOD AS paymt_type_cd   suplr_paymt_typ,
  dim_supplier.CPHONE_NR AS suplr_phn_nbr,
  COALESCE(adrc.POST_CODE1, ?) AS suplr_pstl_cd,
  dim_supplier.CCREATION_DT AS src_crt_ts          suplr_crt_ts,
  dim_supplier.CCHANGE_DT AS src_updt_ts          suplr_updt_ts,
  CAST(NULL AS string) AS suplr_rel_cd,
  CAST(NULL AS string) AS suplr_rgn_cd,
  CAST(NULL AS string) AS suplr_rgn_nm,
  CAST(NULL AS string) AS suplr_ship_mode_cd  suplr_shipment_mode,
  dim_supplier.CREGION_CODE AS suplr_st_cd,
  dim_supplier.TREGION_CODE AS suplr_st_nm,
  dim_supplier.CTAX_ID_NR AS suplr_tax_id        suplr_tax_nbr,
  CASE WHEN payment_data.TACCT_DET_CREDITOR_GROUP_CODE IN ('Domestic, third party', 'Foreign, third party') THEN '3rd party supplier' WHEN payment_data.TACCT_DET_CREDITOR_GROUP_CODE IN ('Inside/Outside BG, affiliated', 'Inside BG, affiliated', 'Employees') THEN 'IC supplier' ELSE CAST(NULL AS string) END AS suplr_type_cd,
  CAST(NULL AS string) AS suplr_type_nm
FROM sap_dim_supplier dim_supplier
LEFT JOIN sap_dim_master lfa1 ON dim_supplier.CBP_UUID = lfa1.CBP_UUID
LEFT JOIN sap_dim_supplier_payment_data payment_data ON payment_data.CBP_UUID = dim_supplier.CBP_UUID
WHERE dim_supplier.CBP_UUID IS NOT NULL

-- =============================
-- f_po_receipt_transformation
-- =============================
/**************************************************************************
Generated plan for f_po_receipt with multiple scenarios: currency_conversion, sto, uom_conversion.
**************************************************************************/

-- Query: f_po_receipt_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 66 rows
-- WARNING: unresolved items: Unclear join condition for co_curr_mth.from_curncy_cd = '?'; Unclear join condition for txn_curr_mth.from_curncy_cd = '?'

WITH
uom_conversion_view AS (
  SELECT
    base.vbeln,
    base.posnr,
    base.matnr,
    base.vrkme,
    base.meins,
    base.bmeng,
    base.netpr,
    marm.umrez,
    marm.umren,
    CASE
      WHEN base.vrkme = base.meins THEN base.bmeng
      WHEN marm.umren = 0 OR marm.umren IS NULL THEN base.bmeng
      ELSE base.bmeng * (marm.umrez / marm.umren)
    END AS qty_primary_uom,
    CASE
      WHEN base.vrkme = base.meins THEN base.netpr
      WHEN marm.umrez = 0 OR marm.umrez IS NULL THEN base.netpr
      ELSE base.netpr * (marm.umren / marm.umrez)
    END AS price_primary_uom
  FROM vbep base
  LEFT JOIN marm marm
    ON marm.matnr = base.matnr
   AND marm.meinh = base.vrkme
),
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
sto_orders AS (
  SELECT
    ekpo.ebeln AS order_nbr,
    ekpo.ebelp AS order_line_nbr,
    ekpo.matnr AS item_nbr,
    ekpo.werks AS plant_cd,
    ekpo.menge AS order_qty,
    ekpo.meins AS order_uom_cd,
    ekko.bsart AS order_type,
    ekko.bukrs AS order_company_cd,
    ekko.aedat AS order_dt
  FROM ekpo ekpo
  INNER JOIN ekko ekko
    ON ekko.ebeln = ekpo.ebeln
  WHERE ekko.bsart IN ('UB', 'NB')
),
sto_receipts AS (
  SELECT
    ekbe.ebeln,
    ekbe.ebelp,
    ekbe.budat AS receipt_dt,
    ekbe.menge AS receipt_qty,
    ekbe.shkzg
  FROM ekbe ekbe
  WHERE ekbe.bwart IN ('101', '102', '161', '162')
    AND ekbe.vgabe = '1'
),
sto_received_qty AS (
  SELECT
    ebeln,
    ebelp,
    SUM(
      CASE
        WHEN shkzg = 'H' THEN -1 * receipt_qty
        ELSE receipt_qty
      END
    ) AS total_received_qty,
    MAX(receipt_dt) AS last_receipt_dt
  FROM sto_receipts
  GROUP BY ebeln, ebelp
),
sto_joined AS (
  SELECT
    o.*,
    COALESCE(r.total_received_qty, 0) AS total_received_qty,
    r.last_receipt_dt,
    (o.order_qty - COALESCE(r.total_received_qty, 0)) AS open_qty
  FROM sto_orders o
  LEFT JOIN sto_received_qty r
    ON r.ebeln = o.order_nbr
   AND r.ebelp = o.order_line_nbr
),
currency_conversion AS (
  SELECT curr_mnth.pmar_rt AS co_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd FROM d_curncy_mth_rt curr_mnth WHERE UPPER(to_curncy_cd) = 'USD'
),
txn_currency_conversion AS (
  SELECT curr_mnth.pmar_rt AS txn_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd, curr_mnth.to_curncy_cd FROM d_curncy_mth_rt curr_mnth WHERE TRIM(UPPER(to_curncy_cd)) = 'USD'
)

SELECT
  sap.CBU_QNT_UNIT AS base_uom,
  if(base_uom_desc.MSEHL=,Unknown,base_uom_desc.MSEHL) AS base_uom_text,
  sap.CBUYER AS business_unit,
  sap.CEMPL_RESP AS buyer_id,
  sap.TEMPL_RESP AS buyer_name,
  sap.CBUYER AS co_cd,
  CASE when t001.WAERS = RMB Then CNY Else t001.WAERS End AS co_curncy_cd,
  sap.TBUYER AS co_name,
  CAST(NULL AS string) AS contract_end_date,
  if(ekko.BSTYP in (K, L),Y,N) AS contract_flag,
  CAST(NULL AS string) AS contract_start_date,
  (case when ekko.BSTYP = 'K' then 'Contract' when ekko.BSTYP = 'L' then 'Sched Agr' else 'NA' end) AS contract_type,
  CAST(NULL AS string) AS delvr_cmplt_flg,
  'DSD' AS div_cd,
  date_format(date_add(to_date('1899-12-30'), cast(KCDEL_ST_DT as int)), 'yyyyMMdd') as dock_dt,
  sap.CITM_DLV_EDDT AS due_dt,
  CAST(NULL AS double) AS ext_recpt_co_amt,
  CAST(NULL AS double) AS ext_recpt_txn_amt,
  CAST(NULL AS string) AS fk_orig,
  CAST(NULL AS string) AS floor_stock_cd,
  'PSBIOLC' AS hfm_entity,
  CAST(NULL AS string) AS inv_loc,
  sap.TPRD_UUID AS item_desc,
  sap.CITEM_ID AS item_nbr,
  if(lcr_lkup.lcr_flg is not null,lcr_lkup.lcr_flg,N) AS lcr_flag,
  if(lcr_lkup.lcr_reg is not null,lcr_lkup.lcr_reg,NA) AS lcr_region,
  CAST(NULL AS string) AS match_typ_cd,
  CAST(NULL AS string) AS match_typ_desc,
  CASE WHEN EKBE.WAERS = 'RMB' THEN 'CNY' ELSE EKBE.WAERS END AS po_curncy_cd,
  CAST(sap.CITEM_ID AS int) AS po_delivry_line_nbr,
  sap.CREF_PO_ITEM_UUID AS po_line_nbr,
  (case when ekpo.pstyp = '0' then 'Standard' when ekpo.pstyp = '1' then 'Blanket item' when ekpo.pstyp = '2' then 'Consignment' when ekpo.pstyp = '3' then 'Subcontracting' when ekpo.pstyp = '4' then 'Material unknown' when ekpo.pstyp = '5' then 'Third-party' when ekpo.pstyp = '6' then 'Text' when ekpo.pstyp = '7' then 'Stock transfer' when ekpo.pstyp = '8' then 'Material group' when ekpo.pstyp = '9' then 'Service' else 'Unknown' end) AS po_line_type_cd,
  sap.CREF_PO_UUID AS po_nbr,
  coalesce(lfb1.zterm, lfm1.zterm, ekko.zterm) AS po_paymt_terms_cd,
  CAST(NULL AS double) AS prod_cost,
  sap.CBUYER AS profit_cntr,
  sap.CITM_DLV_EDDT AS promise_dt,
  sap.CNET_PRC_QTY_UNT AS purch_uom,
  if(purch_uom_desc.MSEHL=,Unknown,purch_uom_desc.MSEHL) AS purch_uom_text,
  cast((CASE  WHEN MSEG.SHKZG='H' THEN coalesce(MSEG.MENGE,0) *-1   ELSE coalesce(MSEG.MENGE,0)  END) as double) AS recpt_base_qty,
  sap_fact_po_receipt.KCRC_DLVD_AMT * * (cast(coalesce(co_curr_mth.co_pmar_rt,1) as double)) AS recpt_co_pmar_amt,
  CASE WHEN EKBE.WAERS = 'RMB' THEN 'CNY' ELSE EKBE.WAERS END AS recpt_curncy_cd,
  sap.CITM_DLV_EDDT AS recpt_date,
  cast(substr(MKPF.BLDAT,1,6) as string) AS recpt_date_period,
  sap.CITEM_ID AS recpt_line_seq_nbr,
  sap.CDELIVERY_UUID AS recpt_nbr,
  sap_fact_po_receipt.KCRC_DLVD_AMT * pmar_rt AS recpt_pmar_amt,
  cast((CASE  WHEN MSEG.SHKZG=H THEN coalesce(MSEG.ERFMG,0) *-1   ELSE coalesce(MSEG.ERFMG,0)  END) as double) AS recpt_txn_qty,
  CAST(NULL AS string) AS recpt_type_cd,
  sap.CDELIVERY_YEAR AS recpt_yr_nbr,
  CAST(NULL AS string) AS ref_recpt_line_seq_nbr,
  CAST(NULL AS string) AS ref_recpt_nbr,
  CAST(NULL AS string) AS ref_recpt_yr_nbr,
  sap.CRECEIVING_SITE AS site_cd,
  If sap_fct_po_receipt.CITM_TYPE = 18, 'Direct', else 'Indirect' AS spend_type_cd,
  'byd_brsbn' AS src_sys_cd,
  coalesce(LFM1.zterm, 'NA') AS suplr_paymt_terms_cd,
  sap.TCSH_DSCNT_TRM AS suplr_paymt_terms_desc,
  sap.CSELLER_UUID AS supplier_id,
  sap.TSELLER_UUID AS supplier_name,
  sap.CDELIVERY_DATE AS txn_date,
  sap.CQUANTITY_UNIT AS txn_uom,
  if(txn_uom_desc.MSEHL=,Unknown,txn_uom_desc.MSEHL) AS txn_uom_text,
  If sap_fct_po_receipt.CITM_TYPE = 18, 'Y', else 'N' AS vomi_flag,
  CAST(NULL AS string) AS warehouse,
  CAST(NULL AS string) AS warehouse_nm
FROM sap_fct_po_receipt sap
LEFT JOIN currency_conversion co_curr_mth ON co_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND co_curr_mth.from_curncy_cd = '?'
LEFT JOIN txn_currency_conversion txn_curr_mth ON txn_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND TRIM(UPPER(txn_curr_mth.from_curncy_cd)) = '?'
WHERE sap.CREF_PO_UUID IS NOT NULL

-- =============================
-- f_purchase_order_transformation
-- =============================
/**************************************************************************
Generated plan for f_purchase_order with union and deduplication logic.
This plan generates the f_purchase_order table.
It uses a union of sap_fct_purchase_order and fct_purchase_order_history.
Deduplication is applied using ROW_NUMBER.
**************************************************************************/

-- Query: f_purchase_order_transformation
-- Pattern: fact_union_dedup
-- Coverage: 123 rows
-- WARNING: unresolved items: No source_field or logic provided for warehouse and warehouse_nm. Defaulting to NULL.

WITH
uom_conversion_view AS (
  SELECT
    base.vbeln,
    base.posnr,
    base.matnr,
    base.vrkme,
    base.meins,
    base.bmeng,
    base.netpr,
    marm.umrez,
    marm.umren,
    CASE
      WHEN base.vrkme = base.meins THEN base.bmeng
      WHEN marm.umren = 0 OR marm.umren IS NULL THEN base.bmeng
      ELSE base.bmeng * (marm.umrez / marm.umren)
    END AS qty_primary_uom,
    CASE
      WHEN base.vrkme = base.meins THEN base.netpr
      WHEN marm.umrez = 0 OR marm.umrez IS NULL THEN base.netpr
      ELSE base.netpr * (marm.umren / marm.umrez)
    END AS price_primary_uom
  FROM vbep base
  LEFT JOIN marm marm
    ON marm.matnr = base.matnr
   AND marm.meinh = base.vrkme
),
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
sto_orders AS (
  SELECT
    ekpo.ebeln AS order_nbr,
    ekpo.ebelp AS order_line_nbr,
    ekpo.matnr AS item_nbr,
    ekpo.werks AS plant_cd,
    ekpo.menge AS order_qty,
    ekpo.meins AS order_uom_cd,
    ekko.bsart AS order_type,
    ekko.bukrs AS order_company_cd,
    ekko.aedat AS order_dt
  FROM ekpo ekpo
  INNER JOIN ekko ekko
    ON ekko.ebeln = ekpo.ebeln
  WHERE ekko.bsart IN ('UB', 'NB')
),
sto_receipts AS (
  SELECT
    ekbe.ebeln,
    ekbe.ebelp,
    ekbe.budat AS receipt_dt,
    ekbe.menge AS receipt_qty,
    ekbe.shkzg
  FROM ekbe ekbe
  WHERE ekbe.bwart IN ('101', '102', '161', '162')
    AND ekbe.vgabe = '1'
),
sto_received_qty AS (
  SELECT
    ebeln,
    ebelp,
    SUM(
      CASE
        WHEN shkzg = 'H' THEN -1 * receipt_qty
        ELSE receipt_qty
      END
    ) AS total_received_qty,
    MAX(receipt_dt) AS last_receipt_dt
  FROM sto_receipts
  GROUP BY ebeln, ebelp
),
sto_joined AS (
  SELECT
    o.*,
    COALESCE(r.total_received_qty, 0) AS total_received_qty,
    r.last_receipt_dt,
    (o.order_qty - COALESCE(r.total_received_qty, 0)) AS open_qty
  FROM sto_orders o
  LEFT JOIN sto_received_qty r
    ON r.ebeln = o.order_nbr
   AND r.ebelp = o.order_line_nbr
),
union_all AS (
  SELECT
    sap_po.KCBU_QUANTITY AS KCBU_QUANTITY,
    sap_po.KCBU_DLVD_QTY AS KCBU_DLVD_QTY,
    sap_po.CITM_CREAT_DATE AS CITM_CREAT_DATE,
    sap_po.CITM_DLV_EDDT AS CITM_DLV_EDDT,
    sap_po.CPO_ID AS CPO_ID,
    sap_po.CITM_ID AS CITM_ID,
    sap_po.KCQUANTITY AS KCQUANTITY,
    sap_po.KCDLVD_QTY AS KCDLVD_QTY
  FROM {'base': 'sap_fct_purchase_order', 'alias': 'sap_po'}
  UNION ALL
  SELECT
    po_hist.KCBU_QUANTITY AS KCBU_QUANTITY,
    po_hist.KCBU_DLVD_QTY AS KCBU_DLVD_QTY,
    po_hist.CITM_CREAT_DATE AS CITM_CREAT_DATE,
    po_hist.CITM_DLV_EDDT AS CITM_DLV_EDDT,
    po_hist.CPO_ID AS CPO_ID,
    po_hist.CITM_ID AS CITM_ID,
    po_hist.KCQUANTITY AS KCQUANTITY,
    po_hist.KCDLVD_QTY AS KCDLVD_QTY
  FROM {'base': 'fct_purchase_order_history', 'alias': 'po_hist'}
),
dedup AS (
  SELECT * FROM ( SELECT *, ROW_NUMBER() OVER (PARTITION BY sap_fct_purchase_order.CBUYER, sap_fct_purchase_order.CEMPL_RESP, sap_fct_purchase_order.CITM_DLV_EDDT ORDER BY sap_fct_purchase_order.CITM_DLV_EDDT DESC) AS row_num FROM sap_fct_purchase_order UNION ALL SELECT *, ROW_NUMBER() OVER (PARTITION BY fct_purchase_order_history.CBUYER, fct_purchase_order_history.CEMPL_RESP, fct_purchase_order_history.CITM_DLV_EDDT ORDER BY fct_purchase_order_history.CITM_DLV_EDDT DESC) AS row_num FROM fct_purchase_order_history ) deduped WHERE row_num = 1
),
union_all_data AS (
  SELECT
    sap.cprocess_type AS cprocess_type,
    sap.vomi_flag AS vomi_flag,
    sap.warehouse AS warehouse,
    sap.warehouse_nm AS warehouse_nm
  FROM {'base': 'sap_fct_purchase_order', 'alias': 'sap'}
  UNION ALL
  SELECT
    hist.cprocess_type AS cprocess_type,
    hist.vomi_flag AS vomi_flag,
    hist.warehouse AS warehouse,
    hist.warehouse_nm AS warehouse_nm
  FROM {'base': 'fct_purchase_order_history', 'alias': 'hist'}
),
dedup_data AS (
  SELECT * FROM ( SELECT *, ROW_NUMBER() OVER (PARTITION BY sap_fct_purchase_order.CBUYER, sap_fct_purchase_order.CEMPL_RESP, sap_fct_purchase_order.CITM_DLV_EDDT ORDER BY sap_fct_purchase_order.CITM_DLV_EDDT DESC) AS row_num FROM sap_fct_purchase_order UNION ALL SELECT *, ROW_NUMBER() OVER (PARTITION BY fct_purchase_order_history.CBUYER, fct_purchase_order_history.CEMPL_RESP, fct_purchase_order_history.CITM_DLV_EDDT ORDER BY fct_purchase_order_history.CITM_DLV_EDDT DESC) AS row_num FROM fct_purchase_order_history ) deduped_data WHERE row_num = 1
)

SELECT
  CAST(NULL AS string) AS acct_seq_nbr,
  d.KCBU_QUANTITY - d.KCBU_DLVD_QTY AS base_open_qty,
  cast(coalesce(eket.menge*(ekpo.umrez/ if(ekpo.umren=0,1,ekpo.umren)),0) as double) AS base_qty,
  CAST(NULL AS string) AS base_uom,
  CAST(NULL AS string) AS base_uom_text,
  CAST(NULL AS string) AS blkt_cd,
  if(cast(coalesce(CASE WHEN trim(ekpo.ko_prctr)= THEN NULL ELSE ekpo.ko_prctr END,CASE WHEN trim(ekkn.prctr)= THEN NULL ELSE ekkn.prctr END) as string) = 0000325200 and trim(ekpo.matnr) <> 104942, NULL ,case when b_unit.LKUP_VAL_05=M&M then PPA else coalesce(b_unit.LKUP_VAL_05,NA) end) AS business_unit,
  CAST(NULL AS string) AS buyer_cd,
  CAST(NULL AS string) AS buyer_name,
  CAST(NULL AS string) AS co_cd,
  CASE WHEN dedup.cprocess_type = 'THPA' THEN 'Y' ELSE 'N' END AS vomi_flag,
  CAST(NULL AS string) AS warehouse,
  CAST(NULL AS string) AS warehouse_nm
FROM dedup d
WHERE d.CPO_ID IS NOT NULL AND d.CITM_ID IS NOT NULL

-- =============================
-- f_supplier_invoice_transformation
-- =============================
/**************************************************************************
Generated plan for f_supplier_invoice with union deduplication and enrichment joins.
**************************************************************************/

-- Query: f_supplier_invoice_transformation
-- Pattern: fact_union_dedup
-- Coverage: 105 rows

WITH
uom_conversion_view AS (
  SELECT
    base.vbeln,
    base.posnr,
    base.matnr,
    base.vrkme,
    base.meins,
    base.bmeng,
    base.netpr,
    marm.umrez,
    marm.umren,
    CASE
      WHEN base.vrkme = base.meins THEN base.bmeng
      WHEN marm.umren = 0 OR marm.umren IS NULL THEN base.bmeng
      ELSE base.bmeng * (marm.umrez / marm.umren)
    END AS qty_primary_uom,
    CASE
      WHEN base.vrkme = base.meins THEN base.netpr
      WHEN marm.umrez = 0 OR marm.umrez IS NULL THEN base.netpr
      ELSE base.netpr * (marm.umren / marm.umrez)
    END AS price_primary_uom
  FROM vbep base
  LEFT JOIN marm marm
    ON marm.matnr = base.matnr
   AND marm.meinh = base.vrkme
),
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
sto_orders AS (
  SELECT
    ekpo.ebeln AS order_nbr,
    ekpo.ebelp AS order_line_nbr,
    ekpo.matnr AS item_nbr,
    ekpo.werks AS plant_cd,
    ekpo.menge AS order_qty,
    ekpo.meins AS order_uom_cd,
    ekko.bsart AS order_type,
    ekko.bukrs AS order_company_cd,
    ekko.aedat AS order_dt
  FROM ekpo ekpo
  INNER JOIN ekko ekko
    ON ekko.ebeln = ekpo.ebeln
  WHERE ekko.bsart IN ('UB', 'NB')
),
sto_receipts AS (
  SELECT
    ekbe.ebeln,
    ekbe.ebelp,
    ekbe.budat AS receipt_dt,
    ekbe.menge AS receipt_qty,
    ekbe.shkzg
  FROM ekbe ekbe
  WHERE ekbe.bwart IN ('101', '102', '161', '162')
    AND ekbe.vgabe = '1'
),
sto_received_qty AS (
  SELECT
    ebeln,
    ebelp,
    SUM(
      CASE
        WHEN shkzg = 'H' THEN -1 * receipt_qty
        ELSE receipt_qty
      END
    ) AS total_received_qty,
    MAX(receipt_dt) AS last_receipt_dt
  FROM sto_receipts
  GROUP BY ebeln, ebelp
),
sto_joined AS (
  SELECT
    o.*,
    COALESCE(r.total_received_qty, 0) AS total_received_qty,
    r.last_receipt_dt,
    (o.order_qty - COALESCE(r.total_received_qty, 0)) AS open_qty
  FROM sto_orders o
  LEFT JOIN sto_received_qty r
    ON r.ebeln = o.order_nbr
   AND r.ebelp = o.order_line_nbr
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
union_all_data AS (
  SELECT
    sap.CTRANSACT_DATE AS actual_payment_dt,
    sap.CCASHDIS_TERMSCD AS ap_payment_term_cd,
    sap.TCASHDIS_TERMSCD AS ap_payment_term_desc,
    sap.CTRANSACT_DATE AS aprval_dt,
    sap.KCBU_QUANTITY AS base_qty,
    CAST(NULL AS string) AS base_uom_cd,
    CAST(NULL AS string) AS business_unit,
    sap.CBUYER AS co_cd,
    sap.CRC_NET_AMT_CUR_ON_POS AS co_curncy_cd,
    sap.TBUYER AS co_name,
    sap.CCOST_CENTER AS cost_centre_cd,
    sap.TCOST_CENTER AS cost_centre_nm,
    sap.CINVOICE_TYCD AS document_type,
    sap.CINVOICE_YEAR AS fscl_yr_nbr,
    sap.CGL_ACC_ALIAS_CD AS gl_acct_id,
    sap.TGL_ACC_ALIAS_CD AS gl_acct_nm,
    sap.CITEM_DESCR AS inv_line_desc,
    sap.CINVOICE_DATE AS invc_entry_dt,
    sap.CINVOICE_MONTH AS invc_entry_period,
    sap.CTRANSACT_DATE AS invc_post_dt,
    sap.KCQUANTITY AS invc_qty,
    sap.CRECEIPT_DATE AS invc_receipt_dt,
    sap.CINVOICE_UUID AS vchr_nbr,
    sap.CITEM_TYPE AS vchr_type_cd,
    sap.TITEM_TYPE AS vchr_type_desc,
    sap.TINVOICE_TYCD AS document_desc
  FROM {'base': 'sap_fct_supplier_invoice', 'alias': 'sap'}
  UNION ALL
  SELECT
    hist.CTRANSACT_DATE AS actual_payment_dt,
    hist.CCASHDIS_TERMSCD AS ap_payment_term_cd,
    hist.TCASHDIS_TERMSCD AS ap_payment_term_desc,
    hist.CTRANSACT_DATE AS aprval_dt,
    hist.KCBU_QUANTITY AS base_qty,
    CAST(NULL AS string) AS base_uom_cd,
    CAST(NULL AS string) AS business_unit,
    hist.CBUYER AS co_cd,
    hist.CRC_NET_AMT_CUR_ON_POS AS co_curncy_cd,
    hist.TBUYER AS co_name,
    hist.CCOST_CENTER AS cost_centre_cd,
    hist.TCOST_CENTER AS cost_centre_nm,
    hist.CINVOICE_TYCD AS document_type,
    hist.CINVOICE_YEAR AS fscl_yr_nbr,
    hist.CGL_ACC_ALIAS_CD AS gl_acct_id,
    hist.TGL_ACC_ALIAS_CD AS gl_acct_nm,
    hist.CITEM_DESCR AS inv_line_desc,
    hist.CINVOICE_DATE AS invc_entry_dt,
    hist.CINVOICE_MONTH AS invc_entry_period,
    hist.CTRANSACT_DATE AS invc_post_dt,
    hist.KCQUANTITY AS invc_qty,
    hist.CRECEIPT_DATE AS invc_receipt_dt,
    hist.CINVOICE_UUID AS vchr_nbr,
    hist.CITEM_TYPE AS vchr_type_cd,
    hist.TITEM_TYPE AS vchr_type_desc,
    hist.TINVOICE_TYCD AS document_desc
  FROM {'base': 'fct_purchase_order_history', 'alias': 'hist'}
),
dedup_data AS (
  SELECT 
  CTRANSACT_DATE AS actual_payment_dt,
  CCASHDIS_TERMSCD AS ap_payment_term_cd,
  TCASHDIS_TERMSCD AS ap_payment_term_desc,
  CTRANSACT_DATE AS aprval_dt,
  KCBU_QUANTITY AS base_qty,
  CBUYER AS co_cd,
  CRC_NET_AMT_CUR_ON_POS AS co_curncy_cd,
  TBUYER AS co_name,
  CCOST_CENTER AS cost_centre_cd,
  TCOST_CENTER AS cost_centre_nm,
  CINVOICE_TYCD AS document_type,
  CINVOICE_YEAR AS fscl_yr_nbr,
  CGL_ACC_ALIAS_CD AS gl_acct_id,
  TGL_ACC_ALIAS_CD AS gl_acct_nm,
  ROW_NUMBER() OVER (PARTITION BY CBUYER, CINVOICE_TYCD ORDER BY CTRANSACT_DATE DESC) AS row_num
FROM 
  sap_fct_supplier_invoice
WHERE 
  ROW_NUMBER() OVER (PARTITION BY CBUYER, CINVOICE_TYCD ORDER BY CTRANSACT_DATE DESC) = 1
)

SELECT
  dedup.actual_payment_dt AS actual_payment_dt,
  dedup.ap_payment_term_cd AS ap_payment_term_cd,
  dedup.ap_payment_term_desc AS ap_payment_term_desc,
  dedup.aprval_dt AS aprval_dt,
  CAST(NULL AS STRING) AS base_qty,
  CAST(NULL AS STRING) AS base_uom_cd,
  CAST(NULL AS STRING) AS business_unit,
  dedup.co_cd AS co_cd,
  dedup.co_curncy_cd AS co_curncy_cd,
  dedup.co_name AS co_name,
  dedup.cost_centre_cd AS cost_centre_cd,
  dedup.cost_centre_nm AS cost_centre_nm,
  dedup.document_type AS document_type,
  coalesce(d_dt.fscl_yr_nbr , date_format(fct_supplier_invoice.ctransact_date,'yyyy')) AS fscl_yr_nbr,
  dedup.gl_acct_id AS gl_acct_id,
  dedup.gl_acct_nm AS gl_acct_nm,
  dedup.inv_line_desc AS inv_line_desc,
  dedup.invc_entry_dt AS invc_entry_dt,
  coalesce(d_dt_entry.fscl_yr_prd_nbr, date_format(fct_supplier_invoice.cinvoice_date,'yyyymm')) AS invc_entry_period,
  dedup.invc_post_dt AS invc_post_dt,
  cast(if(rkwa.shkzg='S', coalesce(rkwa.bstmg,0) * -1,coalesce(rkwa.bstmg,0))as double) AS invc_qty,
  dedup.invc_receipt_dt AS invc_receipt_dt,
  CAST(NULL AS STRING) AS vchr_nbr,
  dedup.vchr_type_cd AS vchr_type_cd,
  dedup.vchr_type_desc AS vchr_type_desc,
  dedup.document_desc AS document_desc
FROM dedup_data dedup
LEFT JOIN dim_product_1 prod ON trim(upper(dedup.cprd_uuid)) = trim(upper(prod.cmatr_int_id))
LEFT OUTER JOIN edp_lkup lkup ON lkup.lkup_key_02 = dedup.cbuyer AND upper(lkup.lkup_typ_nm) = 'TFS_CO_CD_TO_DIV_CD_BU'
