-- Databricks notebook source
-- Generated for: SCRUM-56
-- Universal Plan Schema generation
--
-- Query 1: d_buyer_transformation
--   Pattern: dimension_flat
-- Query 2: d_org_unit_transformation
--   Pattern: dimension_flat
-- Query 3: d_company_transformation
--   Pattern: dimension_flat
-- Query 4: d_gl_acct_transformation
--   Pattern: dimension_flat
-- Query 5: d_product_transformation
--   Pattern: dimension_flat
-- Query 6: f_po_receipt_transformation
--   Pattern: fact_multi_scenario
-- Query 7: f_po_recpt_txn_transformation
--   Pattern: generic
-- Query 8: d_supplier_transformation
--   Pattern: dimension_flat
-- Query 9: f_purchase_order_transformation
--   Pattern: fact_union_dedup
-- Query 10: d_product_plant_transformation
--   Pattern: dimension_flat
-- Query 11: f_supplier_invoice_transformation
--   Pattern: fact_multi_scenario

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
-- d_gl_acct_transformation
-- =============================
/**************************************************************************
Generated plan for d_gl_acct dimension table.
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
  coalesce(SKAT.TXT50, Unknown) AS gl_acct_nm,
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
-- d_product_transformation
-- =============================
/**************************************************************************
Generated plan for d_product dimension table.
**************************************************************************/

-- Query: d_product_transformation
-- Pattern: dimension_flat
-- Coverage: 139 rows
-- WARNING: unresolved items: Join condition for sap_dim_product_1 and sap_dim_org_unit_site is unclear. Placeholder used.; MARA table is referenced in logic but not included in source_tables or joins.; Logic for 'IF((MARA.SATNR)= ,N,Y)' is unclear and may require clarification.

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
  IF((MARA.SATNR)= ,N,Y) AS x_plant_config_flg,
  CAST(NULL AS string) AS x_plant_mtl_stat_cd,
  (case when MARA.MSTDV=00000000 then cast(null as timestamp) else CasT(to_date(MARA.MSTDV, yyyyMMdd) as timestamp) end) AS x_plant_mtl_stat_dt,
  CAST(NULL AS string) AS x_plant_mtl_stat_nm
FROM sap_dim_product_1 sap_dim_product_1
LEFT JOIN sap_dim_org_unit_site sap_dim_org_unit_site ON sap_dim_product_1.some_column = sap_dim_org_unit_site.some_column

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
  CAST(NULL AS double) AS ext_recpt_txn_amt
FROM sap_fct_po_receipt sap
LEFT JOIN currency_conversion co_curr_mth ON co_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND co_curr_mth.from_curncy_cd = '?'
LEFT JOIN txn_currency_conversion txn_curr_mth ON txn_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND TRIM(UPPER(txn_curr_mth.from_curncy_cd)) = '?'

-- =============================
-- f_po_recpt_txn_transformation
-- =============================
/**************************************************************************
Generated plan for f_po_recpt_txn transformation.
**************************************************************************/

-- Query: f_po_recpt_txn_transformation
-- Pattern: generic
-- Coverage: 38 rows
-- WARNING: unresolved items: No source_field or logic provided for most fields. Defaulting to NULL.

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
  COALESCE(adrc.CITY1,Unknown) AS suplr_city_nm,
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
  payment_data.TACCT_DET_CREDITOR_GROUP_CODE AS suplr_type_cd,
  CAST(NULL AS string) AS suplr_type_nm
FROM sap_dim_supplier dim_supplier
LEFT JOIN sap_dim_master lfa1 ON dim_supplier.CBP_UUID = lfa1.CBP_UUID
LEFT JOIN sap_dim_supplier_payment_data payment_data ON payment_data.CBP_UUID = dim_supplier.CBP_UUID
WHERE dim_supplier.CBP_UUID IS NOT NULL

-- =============================
-- f_purchase_order_transformation
-- =============================
/**************************************************************************
This plan generates the f_purchase_order table by combining current and historical data
from sap_fct_purchase_order and fct_purchase_order_history, with deduplication logic.
This plan generates the f_purchase_order table by combining data from sap_fct_purchase_order and fct_purchase_order_history.
It includes logic for deduplication and field mappings as specified.
**************************************************************************/

-- Query: f_purchase_order_transformation
-- Pattern: fact_union_dedup
-- Coverage: 123 rows

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
union_all_data AS (
  SELECT
    sap.KCBU_QUANTITY AS KCBU_QUANTITY,
    sap.KCBU_DLVD_QTY AS KCBU_DLVD_QTY
  FROM sap_fct_purchase_order sap
  UNION ALL
  SELECT
    history.KCBU_QUANTITY AS KCBU_QUANTITY,
    history.KCBU_DLVD_QTY AS KCBU_DLVD_QTY
  FROM fct_purchase_order_history history
),
dedup_data AS (
  SELECT * FROM ( SELECT *, ROW_NUMBER() OVER (PARTITION BY sap_fct_purchase_order.CBUYER, sap_fct_purchase_order.CEMPL_RESP, sap_fct_purchase_order.CITM_DLV_EDDT ORDER BY sap_fct_purchase_order.CITM_DLV_EDDT DESC) AS row_num FROM sap_fct_purchase_order UNION ALL SELECT *, ROW_NUMBER() OVER (PARTITION BY fct_purchase_order_history.CBUYER, fct_purchase_order_history.CEMPL_RESP, fct_purchase_order_history.CITM_DLV_EDDT ORDER BY fct_purchase_order_history.CITM_DLV_EDDT DESC) AS row_num FROM fct_purchase_order_history ) deduped_data WHERE row_num = 1
)

SELECT
  CASE WHEN dedup.cprocess_type = 'THPA' THEN 'Y' ELSE 'N' END AS vomi_flag,
  CAST(NULL AS string) AS warehouse,
  CAST(NULL AS string) AS warehouse_nm,
  cast(coalesce(eket.menge*(ekpo.umrez/ if(ekpo.umren=0,1,ekpo.umren)),0) as double) AS base_qty
FROM union_all_data dedup
WHERE dedup.po_nbr IS NOT NULL

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
  CAST(NULL AS double) AS std_cost_amt,
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
-- f_supplier_invoice_transformation
-- =============================
/**************************************************************************
Generated plan for f_supplier_invoice with multiple scenarios.
**************************************************************************/

-- Query: f_supplier_invoice_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 105 rows
-- WARNING: unresolved items: Details for 'Caculate' table are unclear.; Some joins for 'dim_supplier' are incomplete.

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
currency_conversion AS (
  SELECT 
  si.CINVOICE_AMT * 
  CASE 
    WHEN tcurf.tcurr = 'JPY' OR tcurf.tcurr = 'KRW' THEN tcurf.ukurs / 100 
    ELSE tcurf.ukurs 
  END AS converted_amount,
  si.CINVOICE_AMT AS original_amount,
  si.CRC_NET_AMT_CUR_ON_POS AS original_currency,
  tcurf.tcurr AS target_currency,
  tcurf.ukurs AS exchange_rate,
  si.CINVOICE_ID
FROM 
  sap_fct_supplier_invoice si
LEFT JOIN 
  tcurf 
ON 
  si.CRC_NET_AMT_CUR_ON_POS = tcurf.fcurr 
  AND tcurf.tcurr = 'USD' 
  AND si.CTRANSACT_DATE BETWEEN tcurf.gdatu AND tcurf.gdatu
),
sto AS (
  SELECT 
  ekpo.ebeln AS purchase_order_number,
  ekpo.ebelp AS purchase_order_item,
  ekko.bukrs AS company_code,
  ekko.lifnr AS supplier_number,
  ekko.ekorg AS purchasing_organization,
  ekko.ekgrp AS purchasing_group,
  ekpo.matnr AS material_number,
  ekpo.werks AS plant,
  ekpo.lgort AS storage_location,
  ekpo.menge AS order_quantity,
  ekpo.meins AS order_unit,
  ekpo.netpr AS net_price,
  ekpo.peinh AS price_unit,
  ekpo.waers AS currency,
  ekpo.ernam AS created_by,
  ekpo.aedat AS last_changed_date,
  ekbe.belnr AS material_document_number,
  ekbe.buzei AS material_document_item,
  ekbe.menge AS goods_movement_quantity,
  ekbe.bwart AS movement_type,
  ekbe.budat AS posting_date,
  ekbe.lfdat AS delivery_date,
  ekbe.werks AS goods_receipt_plant,
  ekbe.lgort AS goods_receipt_storage_location
FROM 
  ekpo
JOIN 
  ekko ON ekpo.ebeln = ekko.ebeln
LEFT JOIN 
  ekbe ON ekpo.ebeln = ekbe.ebeln AND ekpo.ebelp = ekbe.ebelp
WHERE 
  ekko.bstyp = 'U' -- Stock Transfer Orders
  AND ekpo.loekz IS NULL -- Exclude logically deleted items
  AND ekpo.elikz = '' -- Exclude completed items
),
union_archive AS (
  SELECT
    ...
  FROM sap_fct_supplier_invoice
  UNION ALL
  SELECT
    ...
  FROM fct_purchase_order_history
),
uom_conversion AS (
  SELECT 
  rkwa.shkzg, 
  CAST(COALESCE(rkwa.bstmg, 0) AS DOUBLE) * 
    CASE 
      WHEN marm.umren IS NULL OR marm.umren = 0 THEN 0 
      ELSE marm.umrez / marm.umren 
    END AS base_qty, 
  CASE 
    WHEN rkwa.shkzg = 'S' THEN 
      CAST(COALESCE(rkwa.bstmg, 0) AS DOUBLE) * -1 
    ELSE 
      CAST(COALESCE(rkwa.bstmg, 0) AS DOUBLE) 
  END * 
    CASE 
      WHEN marm.umren IS NULL OR marm.umren = 0 THEN 0 
      ELSE marm.umrez / marm.umren 
    END AS adjusted_qty, 
  marm.umrez, 
  marm.umren 
FROM 
  sap_fct_supplier_invoice rkwa 
LEFT JOIN 
  sap_dim_product_1 marm 
ON 
  rkwa.cprd_uuid = marm.cprd_uuid
)

SELECT * FROM currency_conversion
UNION ALL
SELECT * FROM sto
UNION ALL
SELECT * FROM uom_conversion
