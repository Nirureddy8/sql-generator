-- Databricks notebook source
-- Generated for: SCRUM-40
-- Merged from multiple query sources
--
-- Query 1: d_buyer_transformation
--   Purpose: Transform and load data into d_buyer
-- Query 2: d_gl_acct_transformation
--   Purpose: Transform and load data into d_gl_acct
-- Query 3: d_company_transformation
--   Purpose: Transform and load data into d_company
-- Query 4: d_org_unit_transformation
--   Purpose: Transform and load data into d_org_unit
-- Query 5: d_product_transformation
--   Purpose: Transform and load data into d_product
-- Query 6: d_product_plant_transformation
--   Purpose: Transform and load data into d_product_plant
-- Query 7: d_supplier_transformation
--   Purpose: Transform and load data into d_supplier
-- Query 8: f_po_receipt_transformation
--   Purpose: Transform and load data into f_po_receipt
-- Query 9: f_purchase_order_transformation
--   Purpose: Transform and load data into f_purchase_order
-- Query 10: f_supplier_invoice_transformation
--   Purpose: Transform and load data into f_supplier_invoice
-- Query 11: f_po_recpt_txn_transformation
--   Purpose: Transform and load data into f_po_recpt_txn
--

WITH d_buyer_transformation as (
-- Query: d_buyer_transformation
-- Purpose: Transform and load data into 'd_buyer'
-- Query Type: SELECT

WITH
  _source_d_buyer_0 AS (
SELECT
  sap_dim_buyer.cee_id AS buyer_cd,
  sap_dim_buyer.tee_id AS buyer_nm
FROM sap_dim_buyer
WHERE sap_dim_buyer.cee_id IS NOT NULL
  ),
  _source_d_buyer_1 AS (
SELECT
  'byd_brsbn' AS src_sys_cd
FROM sap_dim_buyer
WHERE sap_dim_buyer.src_sys_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    buyer_cd AS buyer_cd,
    buyer_nm AS buyer_nm,
    'byd_brsbn' AS src_sys_cd
  FROM _source_d_buyer_1
  )
SELECT * FROM _transformed
),
d_gl_acct_transformation as (
-- Query: d_gl_acct_transformation
-- Purpose: Transform and load data into 'd_gl_acct'
-- Query Type: SELECT

WITH
  _source_d_gl_acct_0 AS (
SELECT
  dim_gl_acct.ccompany_uuid AS co_cd,
  dim_gl_acct.cglacct AS gl_acct_id,
  dim_gl_acct.tglacct AS gl_acct_nm
FROM dim_gl_acct
WHERE dim_gl_acct.src_sys_cd IS NOT NULL AND dim_gl_acct.gl_acct_id IS NOT NULL
  ),
  _source_d_gl_acct_1 AS (
SELECT
  sap_dim_gl_acct.tcompany_uuid AS co_nm,
  sap_dim_gl_acct.CCOST_CTR_UUID AS cost_center_branch_cd,
  sap_dim_gl_acct.TCOST_CTR_UUID AS cost_center_branch_nm
FROM sap_dim_gl_acct
WHERE sap_dim_gl_acct.src_sys_cd IS NOT NULL AND sap_dim_gl_acct.gl_acct_id IS NOT NULL
  ),
  _source_d_gl_acct_2 AS (
SELECT
  CAST(NULL AS STRING) AS coa_id,
  CAST(NULL AS STRING) AS curncy_cd,
  CAST(NULL AS STRING) AS curncy_nm,
  CAST(NULL AS STRING) AS dtl_lvl_nbr,
  CAST(NULL AS STRING) AS object_acct_cd,
  CAST(NULL AS STRING) AS object_acct_cost_type_cd,
  CAST(NULL AS STRING) AS object_acct_subsdry_nm,
  CAST(NULL AS STRING) AS object_acct_type_cd,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS STRING) AS subsdry_cd
FROM dim_gl_acct
WHERE gl_acct_id IS NOT NULL AND src_sys_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    co_cd AS co_cd,
    gl_acct_id AS gl_acct_id,
    gl_acct_nm AS gl_acct_nm,
    co_nm AS co_nm,
    cost_center_branch_cd AS cost_center_branch_cd,
    cost_center_branch_nm AS cost_center_branch_nm,
    coa_id AS coa_id,
    curncy_cd AS curncy_cd,
    curncy_nm AS curncy_nm,
    dtl_lvl_nbr AS dtl_lvl_nbr,
    object_acct_cd AS object_acct_cd,
    object_acct_cost_type_cd AS object_acct_cost_type_cd,
    object_acct_subsdry_nm AS object_acct_subsdry_nm,
    object_acct_type_cd AS object_acct_type_cd,
    src_sys_cd AS src_sys_cd,
    subsdry_cd AS subsdry_cd
  FROM _source_d_gl_acct_2
  )
SELECT * FROM _transformed
),
d_company_transformation as (
-- Query: d_company_transformation
-- Purpose: Transform and load data into 'd_company'
-- Query Type: SELECT

WITH
  _source_d_company_0 AS (
SELECT
  sap_dim_org_unit_site.ccity_name AS city_nm
FROM sap_dim_company
LEFT JOIN sap_dim_org_unit_site
  ON sap_dim_org_unit_site.cparty_id = 4192
WHERE sap_dim_company.src_sys_cd IS NOT NULL
  AND sap_dim_company.co_cd IS NOT NULL
  ),
  _source_d_company_1 AS (
SELECT
  sap_dim_company.ccntry_code AS cntry_cd,
  sap_dim_company.tcntry_code AS cntry_nm,
  sap_dim_company.cco_id AS co_cd,
  sap_dim_company.tco_id AS co_nm
FROM sap_dim_company
WHERE sap_dim_company.cco_id IS NOT NULL AND sap_dim_company.tco_id IS NOT NULL
  ),
  _source_d_company_2 AS (
SELECT
  'AUD' AS co_curncy_cd,
  'Australian Dollar' AS co_curncy_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CAST(NULL AS string) AS group_nm,
  'PSBIOLC' AS hfm_entity_cd,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS st_prov_cd,
  CAST(NULL AS string) AS st_prov_nm
FROM sap_dim_company
WHERE sap_dim_company.src_sys_cd IS NOT NULL AND sap_dim_company.co_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    city_nm AS city_nm,
    cntry_cd AS cntry_cd,
    cntry_nm AS cntry_nm,
    co_cd AS co_cd,
    co_nm AS co_nm,
    co_curncy_cd AS co_curncy_cd,
    co_curncy_nm AS co_curncy_nm,
    gbl_rgn_cd AS gbl_rgn_cd,
    gbl_rgn_nm AS gbl_rgn_nm,
    group_nm AS group_nm,
    hfm_entity_cd AS hfm_entity_cd,
    lang_cd AS lang_cd,
    lang_iso_cd AS lang_iso_cd,
    lang_nm AS lang_nm,
    rgn_cd AS rgn_cd,
    rgn_nm AS rgn_nm,
    src_sys_cd AS src_sys_cd,
    st_prov_cd AS st_prov_cd,
    st_prov_nm AS st_prov_nm
  FROM _source_d_company_2
  )
SELECT * FROM _transformed
),
d_org_unit_transformation as (
-- Query: d_org_unit_transformation
-- Purpose: Transform and load data into 'd_org_unit'
-- Query Type: SELECT

WITH
  _source_d_org_unit_0 AS (
SELECT
  sap_dim_org_unit_site.ccity_name AS city_nm,
  sap_dim_org_unit_site.ccntry_code AS cntry_cd,
  sap_dim_org_unit_site.tcntry_code AS cntry_nm,
  sap_dim_org_unit_site.CBUYER AS co_cd,
  sap_dim_org_unit_site.TBUYER AS co_nm,
  sap_dim_org_unit_site.CPARTY_ID AS org_unit_cd,
  sap_dim_org_unit_site.TPARTY_ID AS org_unit_nm,
  sap_dim_org_unit_site.cregion_code AS st_prov_cd,
  sap_dim_org_unit_site.cst_name AS street_nm
FROM sap_dim_org_unit_site
WHERE sap_dim_org_unit_site.src_sys_cd IS NOT NULL
  AND sap_dim_org_unit_site.org_unit_cd IS NOT NULL
  AND sap_dim_org_unit_site.org_unit_type IS NOT NULL
  ),
  _source_d_org_unit_1 AS (
SELECT
  'AUD' AS co_curncy_cd,
  'Australia Dollar' AS co_curncy_nm,
  CAST(NULL AS string) AS curncy_cd,
  CAST(NULL AS string) AS curncy_nm,
  CAST(NULL AS string) AS gbl_rgn_cd,
  CAST(NULL AS string) AS gbl_rgn_nm,
  CAST(NULL AS string) AS lang_cd,
  CAST(NULL AS string) AS lang_iso_cd,
  CAST(NULL AS string) AS lang_nm,
  CAST(NULL AS string) AS org_unit_cat_nm,
  'manufacturing plant' AS org_unit_type,
  CAST(NULL AS string) AS parent_org_unit_cd,
  CAST(NULL AS string) AS parent_org_unit_nm,
  CAST(NULL AS string) AS rgn_cd,
  CAST(NULL AS string) AS rgn_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS st_prov_nm
FROM sap_dim_org_unit_site
WHERE src_sys_cd IS NOT NULL AND org_unit_cd IS NOT NULL AND org_unit_type IS NOT NULL
  ),
  _transformed AS (
  SELECT
    city_nm AS city_nm,
    cntry_cd AS cntry_cd,
    cntry_nm AS cntry_nm,
    co_cd AS co_cd,
    co_nm AS co_nm,
    org_unit_cd AS org_unit_cd,
    org_unit_nm AS org_unit_nm,
    st_prov_cd AS st_prov_cd,
    street_nm AS street_nm,
    co_curncy_cd AS co_curncy_cd,
    co_curncy_nm AS co_curncy_nm,
    curncy_cd AS curncy_cd,
    curncy_nm AS curncy_nm,
    gbl_rgn_cd AS gbl_rgn_cd,
    gbl_rgn_nm AS gbl_rgn_nm,
    lang_cd AS lang_cd,
    lang_iso_cd AS lang_iso_cd,
    lang_nm AS lang_nm,
    org_unit_cat_nm AS org_unit_cat_nm,
    org_unit_type AS org_unit_type,
    parent_org_unit_cd AS parent_org_unit_cd,
    parent_org_unit_nm AS parent_org_unit_nm,
    rgn_cd AS rgn_cd,
    rgn_nm AS rgn_nm,
    src_sys_cd AS src_sys_cd,
    st_prov_nm AS st_prov_nm
  FROM _source_d_org_unit_1
  )
SELECT * FROM _transformed
),
d_product_transformation as (
-- Query: d_product_transformation
-- Purpose: Transform and load data into 'd_product'
-- Query Type: SELECT

WITH
  _source_d_product_1 AS (
SELECT
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS STRING) AS purch_val_cd,
  CAST(NULL AS STRING) AS purch_val_nm,
  CAST(NULL AS STRING) AS rd_proj_cd,
  CAST(NULL AS STRING) AS rd_proj_nm,
  CAST(NULL AS STRING) AS rev_lvl_assgn_flg,
  CAST(NULL AS INT) AS sell_days,
  CAST(NULL AS INT) AS sheets_cnt,
  CAST(NULL AS STRING) AS ship_cond_cd,
  CAST(NULL AS STRING) AS ship_cond_nm,
  CAST(NULL AS TIMESTAMP) AS sku_launch_dt,
  CAST(NULL AS STRING) AS sku_size,
  CAST(NULL AS STRING) AS sku_sub_type_cd,
  CAST(NULL AS STRING) AS sku_sup_type_nm,
  CAST(NULL AS STRING) AS sku_type_cd,
  CAST(NULL AS STRING) AS sku_type_nm,
  CAST(NULL AS STRING) AS src_div_cd,
  CAST(NULL AS INT) AS src_sys_prod_id,
  CAST(NULL AS STRING) AS stk_type_cd,
  CAST(NULL AS STRING) AS stk_type_nm,
  CAST(NULL AS STRING) AS strg_cond_cd,
  CAST(NULL AS STRING) AS strg_cond_nm,
  CAST(NULL AS STRING) AS sub_prod_line_cd,
  CAST(NULL AS STRING) AS sub_prod_line_nm,
  CAST(NULL AS STRING) AS temp_cond_cd,
  CAST(NULL AS STRING) AS temp_cond_nm,
  CAST(NULL AS STRING) AS transp_grp_cd,
  CAST(NULL AS STRING) AS transp_grp_nm,
  CAST(NULL AS DECIMAL(20,0)) AS ttl_shelf_life_days,
  CAST(NULL AS STRING) AS unspsc,
  CAST(NULL AS STRING) AS x_distrb_chain_mtl_stat_cd,
  CAST(NULL AS TIMESTAMP) AS x_distrb_chain_mtl_stat_dt,
  CAST(NULL AS STRING) AS x_distrb_chain_mtl_stat_nm,
  CAST(NULL AS STRING) AS x_plant_config_flg,
  CAST(NULL AS STRING) AS x_plant_mtl_stat_cd,
  CAST(NULL AS TIMESTAMP) AS x_plant_mtl_stat_dt,
  CAST(NULL AS STRING) AS x_plant_mtl_stat_nm
FROM sap_dim_product_1
WHERE src_sys_cd IS NOT NULL AND sku IS NOT NULL
  ),
  _source_d_product_2 AS (
SELECT
  sap_dim_product_1.cbase_measure_unit_code AS base_uom_cd,
  sap_dim_product_1.tbase_measure_unit_code AS base_uom_nm,
  sap_dim_product_1.cs1ansda32b006df87a0b AS cas_reg_nbr,
  sap_dim_product_1.KCGROSS_WEIGHT AS gross_wgt,
  sap_dim_product_1.KCHEIGHT AS height,
  sap_dim_product_1.CPROD_CATG_UUID_01 AS item_cat_grp_cd,
  sap_dim_product_1.TPROD_CATG_UUID_01 AS item_cat_grp_nm,
  sap_dim_product_1.KCLENGTH AS length,
  sap_dim_product_1.Cs1ANsD0A4BBEA40DDD66 AS mfr_part_nbr,
  sap_dim_product_1.CPROD_CATG_UUID_01 AS mtl_grp_cd,
  sap_dim_product_1.TPROD_CATG_UUID_01 AS mtl_grp_nm,
  sap_dim_product_1.Cs1ANs6BA9E26842229D1 AS mtl_type_cd,
  sap_dim_product_1.Ts1ANs6BA9E26842229D1 AS mtl_type_nm,
  sap_dim_product_1.KCNET_WEIGHT AS net_wgt,
  sap_dim_product_1.CMATR_INT_ID AS sku,
  sap_dim_product_1.TMATR_INT_ID AS sku_nm,
  sap_dim_product_1.KCGROSS_VOLUME AS vol,
  sap_dim_product_1.CGROSS_VOLUME_UNIT_CODE AS vol_uom_cd,
  sap_dim_product_1.TGROSS_VOLUME_UNIT_CODE AS vol_uom_nm,
  sap_dim_product_1.CGROSS_WEIGHT_UNIT_CODE AS wgt_uom_cd,
  sap_dim_product_1.TGROSS_WEIGHT_UNIT_CODE AS wgt_uom_nm,
  sap_dim_product_1.KCWIDTH AS width,
  CAST(NULL AS decimal(26,6)) AS adj_unit_mult_nbr,
  CAST(NULL AS string) AS alt_sku,
  CAST(NULL AS string) AS alt_uom_cd,
  CAST(NULL AS string) AS alt_uom_nm,
  CAST(NULL AS string) AS auth_grp,
  CAST(NULL AS string) AS batch_mgmt_flg,
  CAST(NULL AS string) AS bus_area_cd,
  CAST(NULL AS string) AS bus_area_nm
FROM sap_dim_product_1
WHERE sap_dim_product_1.CMATR_INT_ID IS NOT NULL AND sap_dim_product_1.src_sys_cd IS NOT NULL
  ),
  _transformed AS (
  SELECT
    src_sys_cd AS src_sys_cd,
    purch_val_cd AS purch_val_cd,
    purch_val_nm AS purch_val_nm,
    rd_proj_cd AS rd_proj_cd,
    rd_proj_nm AS rd_proj_nm,
    rev_lvl_assgn_flg AS rev_lvl_assgn_flg,
    sell_days AS sell_days,
    sheets_cnt AS sheets_cnt,
    ship_cond_cd AS ship_cond_cd,
    ship_cond_nm AS ship_cond_nm,
    sku_launch_dt AS sku_launch_dt,
    sku_size AS sku_size,
    sku_sub_type_cd AS sku_sub_type_cd,
    sku_sup_type_nm AS sku_sup_type_nm,
    sku_type_cd AS sku_type_cd,
    sku_type_nm AS sku_type_nm,
    src_div_cd AS src_div_cd,
    src_sys_prod_id AS src_sys_prod_id,
    stk_type_cd AS stk_type_cd,
    stk_type_nm AS stk_type_nm,
    strg_cond_cd AS strg_cond_cd,
    strg_cond_nm AS strg_cond_nm,
    sub_prod_line_cd AS sub_prod_line_cd,
    sub_prod_line_nm AS sub_prod_line_nm,
    temp_cond_cd AS temp_cond_cd,
    temp_cond_nm AS temp_cond_nm,
    transp_grp_cd AS transp_grp_cd,
    transp_grp_nm AS transp_grp_nm,
    ttl_shelf_life_days AS ttl_shelf_life_days,
    unspsc AS unspsc,
    x_distrb_chain_mtl_stat_cd AS x_distrb_chain_mtl_stat_cd,
    x_distrb_chain_mtl_stat_dt AS x_distrb_chain_mtl_stat_dt,
    x_distrb_chain_mtl_stat_nm AS x_distrb_chain_mtl_stat_nm,
    x_plant_config_flg AS x_plant_config_flg,
    x_plant_mtl_stat_cd AS x_plant_mtl_stat_cd,
    x_plant_mtl_stat_dt AS x_plant_mtl_stat_dt,
    x_plant_mtl_stat_nm AS x_plant_mtl_stat_nm,
    base_uom_cd AS base_uom_cd,
    base_uom_nm AS base_uom_nm,
    cas_reg_nbr AS cas_reg_nbr,
    gross_wgt AS gross_wgt,
    height AS height,
    item_cat_grp_cd AS item_cat_grp_cd,
    item_cat_grp_nm AS item_cat_grp_nm,
    length AS length,
    mfr_part_nbr AS mfr_part_nbr,
    mtl_grp_cd AS mtl_grp_cd,
    mtl_grp_nm AS mtl_grp_nm,
    mtl_type_cd AS mtl_type_cd,
    mtl_type_nm AS mtl_type_nm,
    net_wgt AS net_wgt,
    sku AS sku,
    sku_nm AS sku_nm,
    vol AS vol,
    vol_uom_cd AS vol_uom_cd,
    vol_uom_nm AS vol_uom_nm,
    wgt_uom_cd AS wgt_uom_cd,
    wgt_uom_nm AS wgt_uom_nm,
    width AS width,
    adj_unit_mult_nbr AS adj_unit_mult_nbr,
    alt_sku AS alt_sku,
    alt_uom_cd AS alt_uom_cd,
    alt_uom_nm AS alt_uom_nm,
    auth_grp AS auth_grp,
    batch_mgmt_flg AS batch_mgmt_flg,
    bus_area_cd AS bus_area_cd,
    bus_area_nm AS bus_area_nm
  FROM _source_d_product_2
  )
SELECT * FROM _transformed
),
d_product_plant_transformation as (
-- Query: d_product_plant_transformation
-- Purpose: Transform and load data into 'd_product_plant'
-- Query Type: SELECT

WITH
  _source_d_product_plant_2 AS (
SELECT
  CAST(NULL AS decimal(38,6)) AS sfty_time_days,
  CAST(NULL AS string) AS sfty_time_ind,
  CAST(NULL AS decimal(38,6)) AS ship_cap_plang_base_qty,
  CAST(NULL AS string) AS sku_nm_lcl,
  CAST(NULL AS string) AS sls_rank_cd,
  CAST(NULL AS string) AS sls_rank_nm,
  CAST(NULL AS string) AS special_prcmt_type_cd,
  CAST(NULL AS string) AS special_prcmt_type_nm,
  CAST(NULL AS string) AS splitting_ind,
  CAST(NULL AS string) AS src_list_req_flg,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS decimal(38,2)) AS suplr_lead_time,
  CAST(NULL AS decimal(38,6)) AS svc_lvl_nbr,
  CAST(NULL AS string) AS transit_matrix_mtl_grp,
  CAST(NULL AS decimal(38,6)) AS transit_stk_qty,
  CAST(NULL AS decimal(38,6)) AS ttl_repln_lead_time_days,
  CAST(NULL AS decimal(38,6)) AS under_delvr_tol_lmt,
  CAST(NULL AS string) AS unlmted_over_delvr_flg,
  CAST(NULL AS string) AS val_cat_cd,
  CAST(NULL AS string) AS val_cat_nm,
  CAST(NULL AS string) AS val_strm_cd,
  CAST(NULL AS string) AS val_strm_nm,
  CAST(NULL AS string) AS var_cd,
  CAST(NULL AS string) AS var_nm,
  CAST(NULL AS string) AS ver_flg
FROM d_product_plant
WHERE src_sys_cd IS NOT NULL AND sku IS NOT NULL AND plant_cd IS NOT NULL
  ),
  _source_d_product_plant_3 AS (
SELECT
  CAST(NULL AS STRING) AS item_revision,
  sap_dim_product_plant.CSUPPLY_PLANNING_AREA AS plant_cd,
  sap_dim_product_plant.TSUPPLY_PLANNING_AREA AS plant_nm,
  'NONE' AS site_cd,
  sap_dim_product_plant.CPRODUCT_ID AS sku,
  sap_dim_product_plant.TPRODUCT_ID AS sku_nm
FROM sap_dim_product_plant
WHERE sap_dim_product_plant.CPRODUCT_ID IS NOT NULL AND sap_dim_product_plant.CSUPPLY_PLANNING_AREA IS NOT NULL AND sap_dim_product_plant.TSUPPLY_PLANNING_AREA IS NOT NULL
  ),
  _source_d_product_plant_4 AS (
SELECT
  sap_dim_master.KCVALPCOMP AS std_cost_amt
FROM sap_dim_master
JOIN sap_dim_product_plant
  ON sap_dim_product_plant.CPRODUCT_ID = sap_dim_master.CMATR_INT_ID
WHERE sap_dim_master.CSUPPLY_PLANNING_AREA <> '5192'
  AND sap_dim_master.CSUPPLIER_ID IS NOT NULL
  ),
  _transformed AS (
  SELECT
    sfty_time_days AS sfty_time_days,
    sfty_time_ind AS sfty_time_ind,
    ship_cap_plang_base_qty AS ship_cap_plang_base_qty,
    sku_nm_lcl AS sku_nm_lcl,
    sls_rank_cd AS sls_rank_cd,
    sls_rank_nm AS sls_rank_nm,
    special_prcmt_type_cd AS special_prcmt_type_cd,
    special_prcmt_type_nm AS special_prcmt_type_nm,
    splitting_ind AS splitting_ind,
    src_list_req_flg AS src_list_req_flg,
    src_sys_cd AS src_sys_cd,
    suplr_lead_time AS suplr_lead_time,
    svc_lvl_nbr AS svc_lvl_nbr,
    transit_matrix_mtl_grp AS transit_matrix_mtl_grp,
    transit_stk_qty AS transit_stk_qty,
    ttl_repln_lead_time_days AS ttl_repln_lead_time_days,
    under_delvr_tol_lmt AS under_delvr_tol_lmt,
    unlmted_over_delvr_flg AS unlmted_over_delvr_flg,
    val_cat_cd AS val_cat_cd,
    val_cat_nm AS val_cat_nm,
    val_strm_cd AS val_strm_cd,
    val_strm_nm AS val_strm_nm,
    var_cd AS var_cd,
    var_nm AS var_nm,
    ver_flg AS ver_flg,
    item_revision AS item_revision,
    plant_cd AS plant_cd,
    plant_nm AS plant_nm,
    site_cd AS site_cd,
    sku AS sku,
    sku_nm AS sku_nm,
    std_cost_amt AS std_cost_amt
  FROM _source_d_product_plant_4
  )
SELECT * FROM _transformed
),
d_supplier_transformation as (
-- Query: d_supplier_transformation
-- Purpose: Transform and load data into 'd_supplier'
-- Query Type: SELECT

WITH
  _source_d_supplier_0 AS (
SELECT
  CAST(NULL AS timestamp) AS addr_crt_dt,
  CAST(NULL AS string) AS cmdty_mgr_nm,
  CAST(NULL AS timestamp) AS contract_begin_dt,
  CAST(NULL AS string) AS contract_comment_txt,
  CAST(NULL AS timestamp) AS contract_end_dt,
  CAST(NULL AS string) AS contract_id,
  CAST(NULL AS string) AS contract_stat_cd,
  CAST(NULL AS string) AS contract_type_nm,
  CAST(NULL AS string) AS dnb_co_nbr,
  CAST(NULL AS string) AS frt_terms_cd,
  CAST(NULL AS string) AS frt_terms_nm,
  CAST(NULL AS decimal(38,6)) AS mthly_projctd_saving_amt,
  CAST(NULL AS decimal(38,6)) AS mthly_projctd_spend_amt,
  CAST(NULL AS string) AS norm_supplier_type,
  CAST(NULL AS string) AS parent_suplr_nm,
  CAST(NULL AS string) AS prim_branch_cd,
  CAST(NULL AS string) AS prim_branch_nm,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS string) AS status_cd,
  CAST(NULL AS string) AS suplr_assgn_grp_cd,
  CAST(NULL AS string) AS suplr_assgn_grp_nm,
  CAST(NULL AS string) AS suplr_class_cd,
  CAST(NULL AS string) AS suplr_class_nm,
  CAST(NULL AS string) AS cust_svc_email_txt,
  CAST(NULL AS string) AS cust_svc_contact_nm,
  CAST(NULL AS string) AS cust_svc_phn_area_cd,
  CAST(NULL AS string) AS cust_svc_phn_nbr,
  CAST(NULL AS string) AS suplr_dvrsty_cd,
  CAST(NULL AS string) AS suplr_dvrsty_nm,
  CAST(NULL AS string) AS suplr_indy_cd,
  CAST(NULL AS string) AS suplr_indy_nm,
  CAST(NULL AS string) AS suplr_lang_cd,
  CAST(NULL AS string) AS suplr_lang_nm,
  CAST(NULL AS string) AS suplr_rel_cd,
  CAST(NULL AS string) AS suplr_rgn_cd,
  CAST(NULL AS string) AS suplr_rgn_nm,
  CAST(NULL AS string) AS suplr_ship_mode_cd,
  CAST(NULL AS string) AS suplr_type_nm
FROM sap_dim_supplier
WHERE src_sys_cd IS NOT NULL AND suplr_id IS NOT NULL
  ),
  _source_d_supplier_1 AS (
SELECT
  sap_dim_supplier.cglo_trade_name AS alt_suplr_id,
  sap_dim_supplier.cinctm_code AS inco_terms_cd,
  sap_dim_supplier.tinctm_code AS inco_terms_nm,
  sap_dim_supplier.clei_id AS lgl_suplr_nm,
  sap_dim_supplier.ccsh_dscnt_trm AS paymt_terms_cd,
  sap_dim_supplier.tcsh_dscnt_trm AS paymt_terms_nm,
  IF(LOWER(TRIM(sap_dim_supplier.cpur_block_ind)) = 'active', 'N', 'Y') AS suplr_active_flg,
  sap_dim_supplier.cfrmtd_pstl_addr AS suplr_addr_line_1,
  CAST(NULL AS STRING) AS suplr_addr_line_2,
  CAST(NULL AS STRING) AS suplr_addr_line_3,
  CAST(NULL AS STRING) AS suplr_addr_line_4,
  sap_dim_supplier.ccity_name AS suplr_city_nm,
  sap_dim_supplier.ccountry_code AS suplr_cntry_cd,
  sap_dim_supplier.tcountry_code AS suplr_cntry_nm,
  sap_dim_supplier.cemail_uri AS suplr_email_addr,
  sap_dim_supplier.cbp_uuid AS suplr_id,
  sap_dim_supplier.tbp_uuid AS suplr_nm,
  sap_dim_supplier.cphone_nr AS suplr_phn_nbr,
  sap_dim_supplier.cstreet_postal AS suplr_pstl_cd,
  sap_dim_supplier.ccreation_dt AS src_crt_ts,
  sap_dim_supplier.cchange_dt AS src_updt_ts,
  sap_dim_supplier.cregion_code AS suplr_st_cd,
  sap_dim_supplier.tregion_code AS suplr_st_nm,
  sap_dim_supplier.ctax_id_nr AS suplr_tax_id
FROM sap_dim_supplier
WHERE sap_dim_supplier.src_sys_cd IS NOT NULL AND sap_dim_supplier.suplr_id IS NOT NULL
  ),
  _source_d_supplier_2 AS (
SELECT
  sap_dim_supplier_payment_data.TPAYMENT_METHOD AS paymt_type_cd,
  CASE
    WHEN sap_dim_supplier_payment_data.TACCT_DET_CREDITOR_GROUP_CODE = 'Domestic, third party' THEN '3rd party supplier'
    WHEN sap_dim_supplier_payment_data.TACCT_DET_CREDITOR_GROUP_CODE = 'Foreign, third party' THEN '3rd party supplier'
    WHEN sap_dim_supplier_payment_data.TACCT_DET_CREDITOR_GROUP_CODE = 'Inside/Outside BG, affiliated' THEN 'IC supplier'
    WHEN sap_dim_supplier_payment_data.TACCT_DET_CREDITOR_GROUP_CODE = 'Inside BG, affiliated' THEN 'IC supplier'
    WHEN sap_dim_supplier_payment_data.TACCT_DET_CREDITOR_GROUP_CODE = 'Employees' THEN 'IC supplier'
    ELSE NULL
  END AS suplr_type_cd
FROM sap_dim_supplier
INNER JOIN sap_dim_supplier_payment_data
  ON sap_dim_supplier_payment_data.CBP_UUID = sap_dim_supplier.CBP_UUID
WHERE sap_dim_supplier.src_sys_cd IS NOT NULL
  AND sap_dim_supplier.suplr_id IS NOT NULL
  ),
  _transformed AS (
  SELECT
    addr_crt_dt AS addr_crt_dt,
    cmdty_mgr_nm AS cmdty_mgr_nm,
    contract_begin_dt AS contract_begin_dt,
    contract_comment_txt AS contract_comment_txt,
    contract_end_dt AS contract_end_dt,
    contract_id AS contract_id,
    contract_stat_cd AS contract_stat_cd,
    contract_type_nm AS contract_type_nm,
    dnb_co_nbr AS dnb_co_nbr,
    frt_terms_cd AS frt_terms_cd,
    frt_terms_nm AS frt_terms_nm,
    mthly_projctd_saving_amt AS mthly_projctd_saving_amt,
    mthly_projctd_spend_amt AS mthly_projctd_spend_amt,
    norm_supplier_type AS norm_supplier_type,
    parent_suplr_nm AS parent_suplr_nm,
    prim_branch_cd AS prim_branch_cd,
    prim_branch_nm AS prim_branch_nm,
    src_sys_cd AS src_sys_cd,
    status_cd AS status_cd,
    suplr_assgn_grp_cd AS suplr_assgn_grp_cd,
    suplr_assgn_grp_nm AS suplr_assgn_grp_nm,
    suplr_class_cd AS suplr_class_cd,
    suplr_class_nm AS suplr_class_nm,
    cust_svc_email_txt AS cust_svc_email_txt,
    cust_svc_contact_nm AS cust_svc_contact_nm,
    cust_svc_phn_area_cd AS cust_svc_phn_area_cd,
    cust_svc_phn_nbr AS cust_svc_phn_nbr,
    suplr_dvrsty_cd AS suplr_dvrsty_cd,
    suplr_dvrsty_nm AS suplr_dvrsty_nm,
    suplr_indy_cd AS suplr_indy_cd,
    suplr_indy_nm AS suplr_indy_nm,
    suplr_lang_cd AS suplr_lang_cd,
    suplr_lang_nm AS suplr_lang_nm,
    suplr_rel_cd AS suplr_rel_cd,
    suplr_rgn_cd AS suplr_rgn_cd,
    suplr_rgn_nm AS suplr_rgn_nm,
    suplr_ship_mode_cd AS suplr_ship_mode_cd,
    suplr_type_nm AS suplr_type_nm,
    alt_suplr_id AS alt_suplr_id,
    inco_terms_cd AS inco_terms_cd,
    inco_terms_nm AS inco_terms_nm,
    lgl_suplr_nm AS lgl_suplr_nm,
    paymt_terms_cd AS paymt_terms_cd,
    paymt_terms_nm AS paymt_terms_nm,
    suplr_active_flg AS suplr_active_flg,
    suplr_addr_line_1 AS suplr_addr_line_1,
    suplr_addr_line_2 AS suplr_addr_line_2,
    suplr_addr_line_3 AS suplr_addr_line_3,
    suplr_addr_line_4 AS suplr_addr_line_4,
    suplr_city_nm AS suplr_city_nm,
    suplr_cntry_cd AS suplr_cntry_cd,
    suplr_cntry_nm AS suplr_cntry_nm,
    suplr_email_addr AS suplr_email_addr,
    suplr_id AS suplr_id,
    suplr_nm AS suplr_nm,
    suplr_phn_nbr AS suplr_phn_nbr,
    suplr_pstl_cd AS suplr_pstl_cd,
    src_crt_ts AS src_crt_ts,
    src_updt_ts AS src_updt_ts,
    suplr_st_cd AS suplr_st_cd,
    suplr_st_nm AS suplr_st_nm,
    suplr_tax_id AS suplr_tax_id,
    paymt_type_cd AS paymt_type_cd,
    suplr_type_cd AS suplr_type_cd
  FROM _source_d_supplier_2
  )
SELECT * FROM _transformed
),
f_po_receipt_transformation as (
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
  CASE
    WHEN f_purchase_order.CITM_TYPE != '18' THEN sap_fct_po_receipt.KCRC_DLVD_AMT
    ELSE sap_fct_po_receipt.KCDLVD_QTY * f_purchase_order.KCRC_NET_PRC_AMT
  END AS ext_recpt_co_amt,
  CASE
    WHEN f_purchase_order.CITM_TYPE != '18' THEN sap_fct_po_receipt.KCDLVD_AMT
    ELSE sap_fct_po_receipt.KCDLVD_QTY * f_purchase_order.KCNET_PRC_AMT
  END AS ext_recpt_txn_amt,
  sap_fct_po_receipt.TPRD_UUID AS item_desc,
  sap_fct_po_receipt.CITEM_ID AS item_nbr,
  sap_fct_po_receipt.CNET_PRC_AMT_CUR AS po_curncy_cd,
  CAST(NULL AS INT) AS po_delivry_line_nbr,
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
  COALESCE(sap_fct_po_receipt.CRECEIVING_SITE, 'NONE') AS site_cd,
  CASE
    WHEN sap_fct_po_receipt.CITM_TYPE = 18 THEN 'Direct'
    ELSE 'Indirect'
  END AS spend_type_cd,
  sap_fct_po_receipt.CCSH_DSCNT_TRM AS suplr_paymt_terms_cd,
  sap_fct_po_receipt.TCSH_DSCNT_TRM AS suplr_paymt_terms_desc,
  sap_fct_po_receipt.CSELLER_UUID AS supplier_id,
  sap_fct_po_receipt.TSELLER_UUID AS supplier_name,
  sap_fct_po_receipt.CDELIVERY_DATE AS txn_date,
  sap_fct_po_receipt.CQUANTITY_UNIT AS txn_uom,
  sap_fct_po_receipt.TQUANTITY_UNIT AS txn_uom_text,
  CASE
    WHEN sap_fct_po_receipt.CITM_TYPE = 18 THEN 'Y'
    ELSE 'N'
  END AS vomi_flag
FROM sap_fct_po_receipt
LEFT JOIN f_purchase_order
  ON sap_fct_po_receipt.CREF_PO_UUID = f_purchase_order.CPO_ID
  AND sap_fct_po_receipt.CREF_PO_ITEM_UUID = f_purchase_order.CITM_ID
WHERE sap_fct_po_receipt.CDELIVERY_UUID IS NOT NULL
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
  sap_fct_po_receipt.KCRC_DLVD_AMT * txn_curr_mth.pmar_rt AS recpt_pmar_amt
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
  fct_po_receipt.CDELIVERY_YEAR AS recpt_yr_nbr
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
SELECT * FROM _transformed
),
f_purchase_order_transformation as (
-- Query: f_purchase_order_transformation
-- Purpose: Transform and load data into 'f_purchase_order'
-- Query Type: SELECT

WITH
  _source_f_purchase_order_0 AS (
SELECT
  CAST(ship_to_organization_id AS STRING) AS acct_seq_nbr,
  CAST(NULL AS STRING) AS blkt_cd,
  NULL AS coi,
  CAST(NULL AS STRING) AS contract_end_date,
  CAST(NULL AS STRING) AS contract_flag,
  CAST(NULL AS STRING) AS contract_start_date,
  CAST(NULL AS STRING) AS contract_type,
  NULL AS coo,
  CAST(NULL AS STRING) AS dept_cd,
  CAST(NULL AS DOUBLE) AS dock_qty,
  CAST(NULL AS STRING) AS good_receipt_ind,
  CAST(NULL AS STRING) AS inv_flg_text,
  CAST(NULL AS STRING) AS job_no,
  MAX(sap_fct_po_receipt.CITM_DLV_EDDT) AS last_recpt_dt,
  CASE WHEN d_supplier.suplr_cntry_cd IS NOT NULL THEN 'Y' ELSE 'N' END AS lcr_flag,
  edp_lookup_table.supplier_country AS lcr_region,
  CAST(NULL AS DECIMAL(3,0)) AS line_seq,
  CAST(NULL AS STRING) AS nature,
  CAST(NULL AS STRING) AS nature_nm,
  f_purchase_order.open_qty * sap_fct_purchase_order.KCNET_PRC_AMT AS open_txn_amt,
  f_purchase_order.open_txn_amt * TCURR.Exch.Rate AS open_txn_pmar_amt,
  NULL AS part_rev_no,
  NULL AS pass_through_field,
  NULL AS pass_through_line,
  NULL AS payment_compliance_flg,
  CAST(NULL AS STRING) AS planner_cd,
  CAST(NULL AS STRING) AS planner_name,
  CAST(NULL AS STRING) AS complt_dt_key,
  CAST(NULL AS STRING) AS po_hdr_desc,
  CAST(NULL AS STRING) AS po_line_sq,
  CAST(NULL AS STRING) AS purch_org_id,
  CAST(NULL AS STRING) AS ref_no,
  CAST(NULL AS STRING) AS reporting_site,
  CAST(NULL AS STRING) AS sec_supp_cd,
  CASE WHEN sap_fct_purchase_order.CITM_TYPE = '18' THEN 'Direct' ELSE 'Indirect' END AS spend_typ_cd,
  CAST(NULL AS STRING) AS src_crt_by,
  CAST(NULL AS STRING) AS src_crt_ts,
  'byd_brsbn' AS src_sys_cd,
  CAST(NULL AS DOUBLE) AS stock_qty,
  CAST(NULL AS STRING) AS suplr_cat_no,
  CAST(NULL AS DOUBLE) AS txn_co_exch_rt,
  CAST(NULL AS STRING) AS unit,
  CAST(NULL AS STRING) AS unit_nm,
  sap_fct_purchase_order.KCRC_NET_PRC_AMT * COALESCE(co_curr_mth.co_pmar_rt, 0) AS unit_prc_co_pmar_amt,
  sap_fct_purchase_order.KCNET_PRC_AMT * COALESCE(txn_curr_mth.po_PMAR_RT, 0) AS unit_prc_txn_pmar_amt,
  ROUND(fct_purchase_order.KCBU_QUANTITY / fct_purchase_order.kcquantity, 2) AS uom_conv_factor,
  CAST(NULL AS STRING) AS warehouse,
  CAST(NULL AS STRING) AS warehouse_nm
FROM sap_fct_purchase_order
LEFT OUTER JOIN sap_fct_po_receipt
  ON sap_fct_purchase_order.CPO_ID = sap_fct_po_receipt.CREF_PO_UUID
  AND sap_fct_purchase_order.CITM_ID = sap_fct_po_receipt.CREF_PO_ITEM_UUID
LEFT OUTER JOIN d_supplier
  ON d_supplier.suplr_cntry_cd = sap_fct_purchase_order.supplier_country
LEFT OUTER JOIN edp_lookup_table
  ON edp_lookup_table.supplier_country = d_supplier.suplr_cntry_cd
LEFT OUTER JOIN (
  SELECT
    curr_mnth.PMAR_RT AS CO_PMAR_RT,
    curr_mnth.CURNCY_MTH_RT_KEY,
    curr_mnth.YR_MTH_NBR,
    IF(curr_mnth.FROM_CURNCY_CD = 'CNY', 'RMB', curr_mnth.FROM_CURNCY_CD) AS FROM_CURNCY_CD
  FROM d_curncy_mth_rt curr_mnth
  WHERE TO_CURNCY_CD = 'USD'
) co_curr_mth
  ON TRIM(UPPER(co_curr_mth.YR_MTH_NBR)) = TRIM(UPPER(d_dt.fscl_yr_prd_nbr))
  AND TRIM(UPPER(co_curr_mth.FROM_CURNCY_CD)) = 'USD'
LEFT OUTER JOIN (
  SELECT
    curr_mnth.PMAR_RT AS po_PMAR_RT,
    curr_mnth.CURNCY_MTH_RT_KEY,
    curr_mnth.YR_MTH_NBR,
    IF(curr_mnth.FROM_CURNCY_CD = 'CNY', 'RMB', curr_mnth.FROM_CURNCY_CD) AS FROM_CURNCY_CD
  FROM d_curncy_mth_rt curr_mnth
  WHERE TO_CURNCY_CD = 'USD'
) txn_curr_mth
  ON TRIM(UPPER(txn_curr_mth.YR_MTH_NBR)) = TRIM(UPPER(d_dt.fscl_yr_prd_nbr))
  AND TRIM(UPPER(txn_curr_mth.FROM_CURNCY_CD)) = 'USD'
WHERE sap_fct_purchase_order.src_sys_cd IS NOT NULL
  AND sap_fct_purchase_order.po_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_line_nbr IS NOT NULL
  AND sap_fct_purchase_order.po_type_cd IS NOT NULL
  AND sap_fct_purchase_order.acct_seq_nbr IS NOT NULL
  AND sap_fct_purchase_order.co_cd IS NOT NULL
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
    WHEN TRIM(UPPER(fct_purchase_order.citm_type)) = '18' THEN 'Y'
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
    WHEN TRIM(UPPER(fct_purchase_order.citm_oqtycan_st)) = '4' THEN 'Y'
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
    WHEN fct_purchase_order.cprocess_type = 'THPA' THEN 'Y'
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
  dim_master.kcvalpcomp AS stk_unit_price,
  sap_fct_purchase_order.src_sys_cd,
  sap_fct_purchase_order.po_nbr,
  sap_fct_purchase_order.po_line_nbr,
  sap_fct_purchase_order.po_type_cd,
  sap_fct_purchase_order.acct_seq_nbr,
  sap_fct_purchase_order.co_cd
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
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Inside/Outside BG, affiliated' THEN 'IC supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Inside BG, affiliated' THEN 'IC supplier'
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE = 'Employees' THEN 'IC supplier'
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
LEFT JOIN sap_dim_product_1 ON sap_fct_purchase_order.CPRD_UUID = sap_dim_product_1.CMATR_INT_ID
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
SELECT * FROM _transformed
),
f_supplier_invoice_transformation as (
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
FROM sap_fct_supplier_invoice
LEFT OUTER JOIN edp_lkup
  ON edp_lkup.lkup_key_02 = sap_fct_supplier_invoice.cbuyer
  AND upper(edp_lkup.lkup_typ_nm) = 'TFS_CO_CD_TO_DIV_CD_BU'
  AND lower(edp_lkup.lkup_key_01) = 'byd_brsbn'
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
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
WHERE src_sys_cd IS NOT NULL AND vchr_nbr IS NOT NULL AND vchr_line_nbr IS NOT NULL AND po_nbr IS NOT NULL AND po_line_nbr IS NOT NULL AND fscl_yr_nbr IS NOT NULL AND co_cd IS NOT NULL
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
LEFT JOIN co_curr_mth ON sap_fct_supplier_invoice.suplr_invc_dt = co_curr_mth.date
LEFT JOIN po_curr_mth ON sap_fct_supplier_invoice.suplr_invc_dt = po_curr_mth.date
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
FROM sap_fct_supplier_invoice AS fct_supplier_invoice
LEFT OUTER JOIN edp_lkup AS edp_lkup
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
FROM sap_fct_supplier_invoice
LEFT JOIN dim_product_1
  ON TRIM(UPPER(sap_fct_supplier_invoice.cprd_uuid)) = TRIM(UPPER(dim_product_1.cmatr_int_id))
  AND TRIM(UPPER(sap_fct_supplier_invoice.creceiving_site)) = TRIM(UPPER(dim_product_1.csite_id))
WHERE sap_fct_supplier_invoice.src_sys_cd IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.vchr_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.po_line_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.fscl_yr_nbr IS NOT NULL
  AND sap_fct_supplier_invoice.co_cd IS NOT NULL
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
  sap_dim_supplier.CCSH_DSCNT_TRM AS suplr_paymt_terms_cd,
  sap_dim_supplier.TCSH_DSCNT_TRM AS suplr_paymt_terms_desc
FROM sap_fct_supplier_invoice
LEFT JOIN sap_dim_supplier
  ON sap_fct_supplier_invoice.CSELLER = sap_dim_supplier.CBP_UUID
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
    WHEN sap_dim_Supplier_Payment_Data.TACCT_DET_CREDITOR_GROUP_CODE IN ('Inside/Outside BG, affiliated', 'Inside BG, affiliated', 'Employees') THEN 'IC supplier'
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
SELECT * FROM _transformed
),
f_po_recpt_txn_transformation as (
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
FROM (SELECT 1) AS dummy
WHERE 1 = 1
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
SELECT * FROM _transformed
)
SELECT * FROM d_buyer_transformation UNION ALL
SELECT * FROM d_gl_acct_transformation UNION ALL
SELECT * FROM d_company_transformation UNION ALL
SELECT * FROM d_org_unit_transformation UNION ALL
SELECT * FROM d_product_transformation UNION ALL
SELECT * FROM d_product_plant_transformation UNION ALL
SELECT * FROM d_supplier_transformation UNION ALL
SELECT * FROM f_po_receipt_transformation UNION ALL
SELECT * FROM f_purchase_order_transformation UNION ALL
SELECT * FROM f_supplier_invoice_transformation UNION ALL
SELECT * FROM f_po_recpt_txn_transformation