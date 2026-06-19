-- Databricks notebook source
-- Generated for: SCRUM-69
-- Universal Plan Schema generation
--
-- Query 1: sheet_transformation
--   Pattern: dimension_flat
-- Query 2: f_dly_open_order_transformation
--   Pattern: fact_join_enriched

-- =============================
-- sheet_transformation
-- =============================
/**************************************************************************
Generated SQL transformation for target table 'sheet'.
**************************************************************************/

-- Query: sheet_transformation
-- Pattern: dimension_flat
-- Coverage: 3 rows
-- WARNING: unresolved items: Row Sheet2::5: No source_field, logic, or default_val provided for 'in'.; Row Sheet2::11: No source_field, logic, or default_val provided for 'norway'.; Row Sheet2::12: No source_field, logic, or default_val provided for 'qad'.

SELECT
  CAST(NULL AS string) AS in,
  CAST(NULL AS string) AS norway,
  CAST(NULL AS string) AS qad
FROM msd_qad_usapd msd

-- =============================
-- f_dly_open_order_transformation
-- =============================
/**************************************************************************
Fact table for daily open orders.
Includes enriched data from multiple source tables.
**************************************************************************/

-- Query: f_dly_open_order_transformation
-- Pattern: fact_join_enriched
-- Coverage: 115 rows

SELECT
  CAST(NULL AS decimal(38,0)) AS as_of_dt_key,
  CAST(NULL AS string) AS bill_block_cd,
  CAST(NULL AS string) AS bill_block_nm,
  CAST(NULL AS STRING) AS bill_to_cust_id,
  CONCAT_WS('|', ('msd_qad_',lower(ca_mstr.ca_domain)), ca_mstr.ca_customer) AS bill_to_cust_key,
  br.businessrelationsearchname AS bill_to_cust_nm,
  CAST(NULL AS double) AS bo_co_curncy_amt,
  CAST(NULL AS string) AS bo_flg,
  CAST(NULL AS double) AS bo_lcur_amt,
  CAST(NULL AS double) AS bo_qty,
  CAST(NULL AS string) AS bo_stat_nm,
  CAST(NULL AS STRING) AS bu_cd,
  CAST(NULL AS string) AS ccg_lcd_chnl,
  CAST(NULL AS string) AS ccg_lcd_vndr_nbr,
  si.si_entity AS co_cd,
  CAST(NULL AS string) AS co_curncy_cd,
  CONCAT_WS('|', ('msd_qad_',lower(si_mstr.si_domain)), si_mstr.si_entity) AS co_key,
  si.si_desc AS co_nm,
  CAST(NULL AS string) AS co_usd_curncy_mth_rt_key,
  CAST(NULL AS decimal(38,0)) AS commit_dt_key,
  CAST(NULL AS string) AS contact_key,
  CAST(NULL AS string) AS cost_curncy_cd,
  CAST(NULL AS string) AS cur_lot_nbr,
  CAST(NULL AS string) AS cur_ord_stat_cd,
  CAST(NULL AS string) AS cur_ord_stat_nm,
  CAST(NULL AS string) AS cust_key,
  CAST(NULL AS string) AS cust_po_nbr,
  CAST(NULL AS string) AS delvr_block_cd,
  CAST(NULL AS string) AS delvr_block_nm,
  CAST(NULL AS string) AS derived_prod_key,
  CAST(NULL AS string) AS derived_sku,
  CAST(NULL AS string) AS derived_sku_nm,
  CAST(NULL AS double) AS disc_amt,
  CONCAT_WS('|', ('msd_qad_', ca.ca_domain), 'ETL Load Date YYYYMMDD', ca.ca_nbr, itm.itm_line) AS dly_open_ord_key,
  CAST(NULL AS string) AS dw_dly_open_ord_key,
  CAST(NULL AS string) AS dw_src_cd,
  CAST(NULL AS decimal(38,0)) AS expect_ship_dt_key,
  CAST(NULL AS double) AS fin_bo_co_curncy_amt,
  CAST(NULL AS double) AS fin_bo_lcur_amt,
  CAST(NULL AS double) AS fin_bo_qty,
  CAST(NULL AS string) AS fin_ord_line_complt_flg,
  CAST(NULL AS string) AS hdr_bill_block_cd,
  CAST(NULL AS string) AS hdr_bill_block_nm,
  CAST(NULL AS string) AS hdr_delvr_block_cd,
  CAST(NULL AS string) AS hdr_delvr_block_nm,
  CAST(NULL AS string) AS hdr_ord_type_cd,
  CAST(NULL AS string) AS hdr_ord_type_nm,
  CAST(NULL AS string) AS hfm_entity_cd,
  CAST(NULL AS string) AS hfm_entity_key,
  CAST(NULL AS double) AS invc_qty,
  CAST(NULL AS decimal(38,0)) AS mtl_avbl_dt_key,
  CAST(NULL AS string) AS next_ord_stat_cd,
  CAST(NULL AS string) AS next_ord_stat_nm,
  CAST(NULL AS double) AS ord_co_curncy_amt,
  ca.ca_curr AS ord_curncy_cd,
  ca.ca_opn_date AS ord_dt_key,
  CAST(NULL AS string) AS ord_hdr_usd_curncy_mth_rt_key,
  CAST(NULL AS double) AS ord_lcur_amt,
  CAST(NULL AS decimal(38,0)) AS ord_line_ship_nlt_dt_key,
  CAST(NULL AS string) AS ord_overall_stat_cd,
  CAST(NULL AS string) AS ord_overall_stat_nm,
  ((wod.wod_qty_req * wod.wod_price) - wod.wod_covered_amt) + ((wr.wr_act_run * wr.wr_price) - wr.wr_covered_amt) AS ord_prc_per_unit_amt,
  CAST(NULL AS double) AS ord_qty,
  CAST(NULL AS decimal(38,0)) AS ord_rls_dt_key,
  CAST(NULL AS double) AS ord_txn_curncy_amt,
  CAST(NULL AS string) AS ord_type_cd,
  'CALL' AS ord_type_nm,
  CAST(NULL AS decimal(38,0)) AS orig_proms_dt_key,
  CAST(NULL AS string) AS overall_stat_cd,
  CAST(NULL AS string) AS overall_stat_nm,
  CAST(NULL AS string) AS plant_cd,
  CAST(NULL AS string) AS plant_key,
  CAST(NULL AS string) AS plant_nm,
  CAST(NULL AS string) AS po_line_nbr,
  CAST(NULL AS string) AS po_nbr,
  (sum(wod_qty_req)/count(*)) * sum(wod_price) - sum(wod_covered_amt) + (sum(wr_act_run)/count(*)) * sum(wr_price) - sum(wr_covered_amt) AS prc_per_unit_amt,
  CONCAT_WS('|', ('msd_qad_', itm.itm_domain), itm.itm_part) AS prod_key,
  CAST(NULL AS STRING) AS prod_line_cd,
  CAST(NULL AS string) AS prod_plant_key,
  CAST(NULL AS string) AS proj_cd,
  CAST(NULL AS decimal(38,0)) AS proms_delvr_dt_key,
  CAST(NULL AS decimal(38,0)) AS proms_ship_dt_key,
  CAST(NULL AS timestamp) AS rec_crt_ts,
  CAST(NULL AS timestamp) AS rec_updt_ts,
  CAST(NULL AS string) AS reject_rsn_cd,
  CAST(NULL AS string) AS reject_rsn_nm,
  CAST(NULL AS decimal(38,0)) AS req_delvr_dt_key,
  CAST(NULL AS string) AS req_strg_loc_cd,
  CAST(NULL AS string) AS revnu_div,
  CAST(NULL AS decimal(38,0)) AS sched_ship_dt_key,
  CAST(NULL AS double) AS ship_qty,
  CAST(NULL AS string) AS ship_to_cntry_hier_key,
  ca.ca_eu_nbr AS ship_to_cust_id,
  CAST(NULL AS string) AS ship_to_cust_key,
  CAST(NULL AS string) AS ship_to_cust_nm,
  itm.itm_part AS sku,
  pt.pt_desc1 AS sku_nm,
  CAST(NULL AS string) AS sls_ord_key,
  lower(ca_mstr.ca_domain) = lower(itm_det.itm_domain) AND ca_mstr.ca_nbr = itm_det.itm_nbr AND lower(itm_det.itm_site) = lower(si_mstr.si_site) AS sls_ord_line_nbr,
  ca.ca_nbr AS sls_ord_nbr,
  CAST(NULL AS string) AS sls_rep_cust_key,
  CAST(NULL AS string) AS sls_terr_cd,
  CAST(NULL AS string) AS sold_to_cust_id,
  CAST(NULL AS string) AS sold_to_cust_key,
  CAST(NULL AS string) AS sold_to_cust_nm,
  CAST(NULL AS string) AS src_crt_by,
  ca.ca_opn_date AS src_crt_ts,
  concat("msd_qad_",lower(ca_mstr.ca_domain)) AS src_sys_cd,
  ca.ca_mod_userid AS src_updt_by,
  ca.ca_mod_date AS src_updt_ts,
  CAST(NULL AS string) AS strg_loc_cd,
  CAST(NULL AS double) AS target_qty,
  CAST(NULL AS double) AS unit_std_cost,
  CAST(NULL AS string) AS uom_cd,
  cc.costcentrecode AS cost_center_cd
FROM si_mstr si
LEFT JOIN (SELECT debtorcode, debtortype_id, businessrelation_id, ROW_NUMBER() OVER (PARTITION BY debtorcode ORDER BY hub_debtor_key DESC) as rn FROM Debtor) deb ON ca_mstr.ca_customer = deb.debtorcode AND deb.rn = 1
LEFT JOIN businessrelation br ON deb.businessrelation_id = br.businessrelation_id
LEFT JOIN (SELECT DISTINCT costcentrecode, customcombo1, customcombo0, customlong0 FROM costcentre) cc ON wo.wo_cc = cc.costcentrecode
LEFT JOIN ca_mstr ca ON lower(si.si_domain) = lower(ca.ca_domain) AND lower(si.si_site) = lower(ca.ca_site)
LEFT JOIN (SELECT (SUM(wod_qty_req)/COUNT(*)) AS wod_qty_req, SUM(wod_price) AS wod_price, SUM(wod_covered_amt) AS wod_covered_amt, wod_lot, wod_domain FROM wod_det GROUP BY wod_lot, wod_domain) wod ON wo.wo_lot = wod.wod_lot AND lower(wo.wo_domain) = lower(wod.wod_domain)
LEFT JOIN (SELECT (SUM(wr_act_run)/COUNT(*)) AS wr_act_run, SUM(wr_price) AS wr_price, SUM(wr_covered_amt) AS wr_covered_amt, wr_lot, wr_domain FROM wr_route GROUP BY wr_lot, wr_domain) wr ON wo.wo_lot = wr.wr_lot AND lower(wo.wo_domain) = lower(wr.wr_domain)
LEFT JOIN pt_mstr pt ON lower(pt.pt_domain) = lower(itm_det.itm_domain) AND pt.pt_part = itm_det.itm_part
LEFT JOIN itm_det itm ON lower(ca.ca_domain) = lower(itm.itm_domain) AND ca.ca_nbr = itm.itm_nbr AND lower(itm.itm_site) = lower(si.si_site)
