-- Databricks notebook source
-- Generated for: SCRUM-45
-- Merged from multiple query sources
--
-- Query 1: Changed to non mandatory_transformation
--   Purpose: Transform and load data into Changed to non mandatory
-- Query 2: Change Desc_transformation
--   Purpose: Transform and load data into Change Desc
-- Query 3: Added_transformation
--   Purpose: Transform and load data into Added
-- Query 4: Changed to mandatory_transformation
--   Purpose: Transform and load data into Changed to mandatory
-- Query 5: Definition update_transformation
--   Purpose: Transform and load data into Definition update
-- Query 6: Updated Field Name_transformation
--   Purpose: Transform and load data into Updated Field Name
--

WITH changed_to_non_mandatory_transformation as (
-- Query: Changed to non mandatory_transformation
-- Purpose: Transform and load data into 'Changed to non mandatory'
-- Query Type: SELECT

WITH
  _source_changed_to_non_mandatory_0 AS (
SELECT
  CAST(NULL AS d_product.intlct_propty) AS `116`,
  CAST(NULL AS d_product.normalized_desc) AS `133`,
  CAST(NULL AS d_product.prod_nm) AS `149`,
  CAST(NULL AS d_product_plant.item_cls_cd) AS `264`,
  CAST(NULL AS d_product_plant.item_cls_nm) AS `265`,
  CAST(NULL AS d_product_plant.mtl_planr_cd) AS `300`,
  CAST(NULL AS d_product_plant.mtl_planr_nm) AS `301`,
  CAST(NULL AS f_po_receipt.match_typ_cd) AS `485`,
  CAST(NULL AS f_po_receipt.match_typ_desc) AS `486`,
  CAST(NULL AS f_po_receipt.warehouse) AS `523`,
  CAST(NULL AS f_po_receipt.warehouse_nm) AS `524`,
  CAST(NULL AS f_purchase_order.coi) AS `575`,
  CAST(NULL AS f_purchase_order.coo) AS `580`,
  CAST(NULL AS f_purchase_order.pass_through_field) AS `622`,
  CAST(NULL AS f_purchase_order.pass_through_line) AS `623`,
  CAST(NULL AS f_supplier_invoice.contract_flag) AS `700`,
  CAST(NULL AS f_supplier_invoice.contract_type) AS `702`,
  CAST(NULL AS f_supplier_invoice.pass_through_field) AS `737`,
  CAST(NULL AS f_supplier_invoice.pass_through_line) AS `738`,
  CAST(NULL AS f_supplier_invoice.txn_orig_id) AS `775`
FROM string
  ),
  _source_changed_to_non_mandatory_1 AS (
SELECT
  d_product_plant.max_lot_size_qty AS `279`,
  d_product_plant.min_lot_size_qty AS `284`,
  d_product_plant.pland_delvr_days AS `312`,
  d_product_plant.recpt_proc_days AS `355`,
  d_product_plant.reord_point_qty AS `357`,
  d_product_plant.sfty_stk_qty AS `366`,
  d_product_plant.sfty_time_days AS `367`,
  d_product_plant.ttl_repln_lead_time_days AS `386`
FROM d_product_plant
  ),
  _transformed AS (
  SELECT
    `116` AS `116`,
    `133` AS `133`,
    `149` AS `149`,
    `264` AS `264`,
    `265` AS `265`,
    `300` AS `300`,
    `301` AS `301`,
    `485` AS `485`,
    `486` AS `486`,
    `523` AS `523`,
    `524` AS `524`,
    `575` AS `575`,
    `580` AS `580`,
    `622` AS `622`,
    `623` AS `623`,
    `700` AS `700`,
    `702` AS `702`,
    `737` AS `737`,
    `738` AS `738`,
    `775` AS `775`,
    `279` AS `279`,
    `284` AS `284`,
    `312` AS `312`,
    `355` AS `355`,
    `357` AS `357`,
    `366` AS `366`,
    `367` AS `367`,
    `386` AS `386`
  FROM _source_changed_to_non_mandatory_1
  )
SELECT * FROM _transformed
),
change_desc_transformation as (
-- Query: Change Desc_transformation
-- Purpose: Transform and load data into 'Change Desc'
-- Query Type: SELECT

WITH
  _source_change_desc_0 AS (
SELECT
  DataType.`Is Primary Key` AS `Index`
FROM DataType
  ),
  _transformed AS (
  SELECT
    `Index` AS `Index`
  FROM _source_change_desc_0
  )
SELECT * FROM _transformed
),
added_transformation as (
-- Query: Added_transformation
-- Purpose: Transform and load data into 'Added'
-- Query Type: SELECT

WITH
  _source_added_0 AS (
SELECT
  CAST(NULL AS d_product_plant.standard_cost) AS `381`,
  CAST(NULL AS f_po_recpt_txn.txn_qty) AS `555`
FROM double
  ),
  _source_added_1 AS (
SELECT
  d_supplier.cust_svc_email_txt AS cust_svc_email_txt,
  d_supplier.cust_svc_contact_nm AS cust_svc_contact_nm,
  d_supplier.cust_svc_phn_nbr AS cust_svc_phn_nbr,
  d_supplier.paymt_type_cd AS paymt_type_cd,
  d_supplier.suplr_ship_mode_cd AS suplr_ship_mode_cd,
  d_supplier.suplr_tax_id AS suplr_tax_id,
  f_po_recpt_txn.po_recpt_txn_key AS po_recpt_txn_key,
  f_po_recpt_txn.src_sys_cd AS src_sys_cd,
  f_po_recpt_txn.txn_nbr AS txn_nbr,
  f_po_recpt_txn.txn_line_nbr AS txn_line_nbr,
  f_po_recpt_txn.dw_src_key AS dw_src_key,
  f_po_recpt_txn.div_cd AS div_cd,
  f_po_recpt_txn.po_recpt_key AS po_recpt_key,
  f_po_recpt_txn.recpt_nbr AS recpt_nbr,
  f_po_recpt_txn.recpt_line_seq_nbr AS recpt_line_seq_nbr,
  f_po_recpt_txn.po_nbr AS po_nbr,
  f_po_recpt_txn.po_line_nbr AS po_line_nbr,
  f_po_recpt_txn.po_line_type_cd AS po_line_type_cd,
  f_po_recpt_txn.acct_seq_nbr AS acct_seq_nbr,
  f_po_recpt_txn.match_type_cd AS match_type_cd,
  f_po_recpt_txn.recpt_yr_nbr AS recpt_yr_nbr,
  f_po_recpt_txn.co_key AS co_key,
  f_po_recpt_txn.co_cd AS co_cd,
  f_po_recpt_txn.prod_key AS prod_key,
  f_po_recpt_txn.sku AS sku,
  f_po_recpt_txn.plant_cd AS plant_cd,
  f_po_recpt_txn.plant_key AS plant_key,
  f_po_recpt_txn.prod_plant_key AS prod_plant_key,
  f_po_recpt_txn.suplr_key AS suplr_key,
  f_po_recpt_txn.suplr_cd AS suplr_cd,
  f_po_recpt_txn.suplr_lot_nbr AS suplr_lot_nbr,
  f_po_recpt_txn.erp_lot_nbr AS erp_lot_nbr,
  f_po_recpt_txn.coo_cd AS coo_cd,
  f_po_recpt_txn.coo_nm AS coo_nm,
  f_po_recpt_txn.txn_uom_cd AS txn_uom_cd,
  f_po_recpt_txn.txn_uom_nm AS txn_uom_nm,
  f_po_recpt_txn.txn_type_cd AS txn_type_cd,
  f_po_recpt_txn.src_crt_by AS src_crt_by,
  f_po_recpt_txn.src_updt_by AS src_updt_by,
  f_purchase_order.inco_terms_cd AS inco_terms_cd,
  f_purchase_order.inco_terms_nm AS inco_terms_nm,
  f_purchase_order.po_hdr_desc AS po_hdr_desc,
  f_supplier_invoice.document_type AS document_type,
  f_supplier_invoice.inv_line_desc AS inv_line_desc,
  f_supplier_invoice.invc_post_dt AS invc_post_dt,
  f_supplier_invoice.invc_receipt_dt AS invc_receipt_dt,
  f_supplier_invoice.invc_txn_type AS invc_txn_type,
  f_supplier_invoice.erp_cat_cd AS erp_cat_cd,
  f_supplier_invoice.erp_cat_nm AS erp_cat_nm,
  f_supplier_invoice.remit_to_addr_line_1 AS remit_to_addr_line_1,
  f_supplier_invoice.remit_to_addr_line_2 AS remit_to_addr_line_2,
  f_supplier_invoice.remit_to_addr_line_3 AS remit_to_addr_line_3,
  f_supplier_invoice.remit_to_addr_line_4 AS remit_to_addr_line_4,
  f_supplier_invoice.remit_to_city_nm AS remit_to_city_nm,
  f_supplier_invoice.remit_to_cntry_cd AS remit_to_cntry_cd,
  f_supplier_invoice.remit_to_cntry_nm AS remit_to_cntry_nm,
  f_supplier_invoice.remit_to_st_cd AS remit_to_st_cd,
  f_supplier_invoice.rpt_flex1 AS rpt_flex1,
  f_supplier_invoice.suplr_nm_src AS suplr_nm_src,
  f_supplier_invoice.txn_ref_nbr AS txn_ref_nbr,
  f_supplier_invoice.vchr_type_desc AS vchr_type_desc,
  f_supplier_invoice.document_desc AS document_desc
FROM d_supplier
LEFT JOIN f_po_recpt_txn ON d_supplier.suplr_key = f_po_recpt_txn.suplr_key
LEFT JOIN f_purchase_order ON f_po_recpt_txn.po_nbr = f_purchase_order.po_nbr
LEFT JOIN f_supplier_invoice ON f_po_recpt_txn.suplr_key = f_supplier_invoice.suplr_key
  ),
  _source_added_2 AS (
SELECT
  CAST(NULL AS STRING) AS `381`,
  CAST(NULL AS STRING) AS `433`,
  CAST(NULL AS STRING) AS `434`,
  CAST(NULL AS STRING) AS `435`,
  CAST(NULL AS STRING) AS `445`,
  d_supplier.src_crt_ts AS `448`,
  d_supplier.src_updt_ts AS `449`,
  CAST(NULL AS STRING) AS `453`
FROM d_supplier
  ),
  _source_added_3 AS (
SELECT
  f_po_recpt_txn.src_crt_ts AS 558,
  f_po_recpt_txn.src_updt_ts AS 560,
  f_po_recpt_txn.rec_crt_ts AS 561,
  f_po_recpt_txn.rec_updt_ts AS 562
FROM f_po_recpt_txn
WHERE f_po_recpt_txn.src_crt_ts IS NOT NULL
  ),
  _source_added_4 AS (
SELECT
  CAST(NULL AS STRING) AS `381`,
  CAST(NULL AS STRING) AS `433`,
  CAST(NULL AS STRING) AS `434`,
  CAST(NULL AS STRING) AS `435`,
  CAST(NULL AS STRING) AS `445`,
  CAST(NULL AS STRING) AS `448`,
  CAST(NULL AS STRING) AS `449`,
  CAST(NULL AS STRING) AS `453`,
  CAST(NULL AS STRING) AS `456`,
  CAST(NULL AS STRING) AS `525`,
  CAST(NULL AS STRING) AS `526`,
  CAST(NULL AS STRING) AS `527`,
  CAST(NULL AS STRING) AS `528`,
  CAST(NULL AS STRING) AS `529`,
  CAST(NULL AS STRING) AS `530`,
  CAST(NULL AS STRING) AS `531`,
  CAST(NULL AS STRING) AS `532`,
  CAST(NULL AS STRING) AS `533`,
  CAST(NULL AS STRING) AS `534`,
  CAST(NULL AS STRING) AS `535`,
  CAST(NULL AS STRING) AS `536`,
  CAST(NULL AS STRING) AS `537`,
  CAST(NULL AS STRING) AS `538`,
  CAST(NULL AS STRING) AS `539`,
  CAST(NULL AS STRING) AS `540`,
  CAST(NULL AS STRING) AS `541`,
  CAST(NULL AS STRING) AS `542`,
  CAST(NULL AS STRING) AS `543`,
  CAST(NULL AS STRING) AS `544`,
  CAST(NULL AS STRING) AS `545`,
  CAST(NULL AS STRING) AS `546`,
  CAST(NULL AS STRING) AS `547`,
  CAST(NULL AS STRING) AS `548`,
  CAST(NULL AS STRING) AS `549`,
  CAST(NULL AS STRING) AS `550`,
  CAST(NULL AS STRING) AS `551`,
  CAST(NULL AS STRING) AS `552`,
  CAST(NULL AS STRING) AS `553`,
  CAST(NULL AS STRING) AS `554`,
  CAST(NULL AS STRING) AS `555`,
  CAST(NULL AS STRING) AS `556`,
  CAST(NULL AS STRING) AS `557`,
  CAST(NULL AS STRING) AS `558`,
  CAST(NULL AS STRING) AS `559`,
  CAST(NULL AS STRING) AS `560`,
  CAST(NULL AS STRING) AS `561`,
  CAST(NULL AS STRING) AS `562`,
  f_purchase_order.base_open_qty AS `564`,
  CAST(NULL AS STRING) AS `602`,
  CAST(NULL AS STRING) AS `603`,
  CAST(NULL AS STRING) AS `635`,
  CAST(NULL AS STRING) AS `706`,
  CAST(NULL AS STRING) AS `716`,
  CAST(NULL AS STRING) AS `722`,
  CAST(NULL AS STRING) AS `724`,
  CAST(NULL AS STRING) AS `727`,
  CAST(NULL AS STRING) AS `733`,
  CAST(NULL AS STRING) AS `734`,
  CAST(NULL AS STRING) AS `748`,
  CAST(NULL AS STRING) AS `749`,
  CAST(NULL AS STRING) AS `750`,
  CAST(NULL AS STRING) AS `751`,
  CAST(NULL AS STRING) AS `752`,
  CAST(NULL AS STRING) AS `753`,
  CAST(NULL AS STRING) AS `754`,
  CAST(NULL AS STRING) AS `757`,
  CAST(NULL AS STRING) AS `759`,
  CAST(NULL AS STRING) AS `767`,
  CAST(NULL AS STRING) AS `776`,
  CAST(NULL AS STRING) AS `785`,
  CAST(NULL AS STRING) AS `790`
FROM f_purchase_order
  ),
  _transformed AS (
  SELECT
    `381` AS `381`,
    `555` AS `555`,
    cust_svc_email_txt AS cust_svc_email_txt,
    cust_svc_contact_nm AS cust_svc_contact_nm,
    cust_svc_phn_nbr AS cust_svc_phn_nbr,
    paymt_type_cd AS paymt_type_cd,
    suplr_ship_mode_cd AS suplr_ship_mode_cd,
    suplr_tax_id AS suplr_tax_id,
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
    txn_type_cd AS txn_type_cd,
    src_crt_by AS src_crt_by,
    src_updt_by AS src_updt_by,
    inco_terms_cd AS inco_terms_cd,
    inco_terms_nm AS inco_terms_nm,
    po_hdr_desc AS po_hdr_desc,
    document_type AS document_type,
    inv_line_desc AS inv_line_desc,
    invc_post_dt AS invc_post_dt,
    invc_receipt_dt AS invc_receipt_dt,
    invc_txn_type AS invc_txn_type,
    erp_cat_cd AS erp_cat_cd,
    erp_cat_nm AS erp_cat_nm,
    remit_to_addr_line_1 AS remit_to_addr_line_1,
    remit_to_addr_line_2 AS remit_to_addr_line_2,
    remit_to_addr_line_3 AS remit_to_addr_line_3,
    remit_to_addr_line_4 AS remit_to_addr_line_4,
    remit_to_city_nm AS remit_to_city_nm,
    remit_to_cntry_cd AS remit_to_cntry_cd,
    remit_to_cntry_nm AS remit_to_cntry_nm,
    remit_to_st_cd AS remit_to_st_cd,
    rpt_flex1 AS rpt_flex1,
    suplr_nm_src AS suplr_nm_src,
    txn_ref_nbr AS txn_ref_nbr,
    vchr_type_desc AS vchr_type_desc,
    document_desc AS document_desc,
    `448` AS `448`,
    `449` AS `449`,
    558 AS 558,
    560 AS 560,
    561 AS 561,
    562 AS 562,
    `433` AS `433`,
    `434` AS `434`,
    `435` AS `435`,
    `445` AS `445`,
    `453` AS `453`,
    `456` AS `456`,
    `525` AS `525`,
    `526` AS `526`,
    `527` AS `527`,
    `528` AS `528`,
    `529` AS `529`,
    `530` AS `530`,
    `531` AS `531`,
    `532` AS `532`,
    `533` AS `533`,
    `534` AS `534`,
    `535` AS `535`,
    `536` AS `536`,
    `537` AS `537`,
    `538` AS `538`,
    `539` AS `539`,
    `540` AS `540`,
    `541` AS `541`,
    `542` AS `542`,
    `543` AS `543`,
    `544` AS `544`,
    `545` AS `545`,
    `546` AS `546`,
    `547` AS `547`,
    `548` AS `548`,
    `549` AS `549`,
    `550` AS `550`,
    `551` AS `551`,
    `552` AS `552`,
    `553` AS `553`,
    `554` AS `554`,
    `556` AS `556`,
    `557` AS `557`,
    `558` AS `558`,
    `559` AS `559`,
    `560` AS `560`,
    `561` AS `561`,
    `562` AS `562`,
    `564` AS `564`,
    `602` AS `602`,
    `603` AS `603`,
    `635` AS `635`,
    `706` AS `706`,
    `716` AS `716`,
    `722` AS `722`,
    `724` AS `724`,
    `727` AS `727`,
    `733` AS `733`,
    `734` AS `734`,
    `748` AS `748`,
    `749` AS `749`,
    `750` AS `750`,
    `751` AS `751`,
    `752` AS `752`,
    `753` AS `753`,
    `754` AS `754`,
    `757` AS `757`,
    `759` AS `759`,
    `767` AS `767`,
    `776` AS `776`,
    `785` AS `785`,
    `790` AS `790`
  FROM _source_added_4
  )
SELECT * FROM _transformed
),
changed_to_mandatory_transformation as (
-- Query: Changed to mandatory_transformation
-- Purpose: Transform and load data into 'Changed to mandatory'
-- Query Type: SELECT

WITH
  _source_changed_to_mandatory_0 AS (
SELECT
  d_supplier.inco_terms_cd AS `408`,
  d_supplier.inco_terms_nm AS `409`,
  d_supplier.lgl_suplr_nm AS `410`,
  d_supplier.suplr_active_flg AS `421`,
  d_supplier.suplr_phn_nbr AS `446`,
  f_purchase_order.base_uom_text AS `567`,
  f_purchase_order.contract_flag AS `577`,
  f_purchase_order.contract_start_date AS `578`,
  f_purchase_order.contract_type AS `579`,
  f_purchase_order.header_status_cd AS `599`,
  f_purchase_order.header_status_nm AS `600`,
  f_purchase_order.po_line_del_flg AS `636`,
  f_purchase_order.purch_uom_text AS `654`,
  f_purchase_order.release_dt AS `656`,
  f_purchase_order.suplr_confrm_dt AS `668`
FROM d_supplier
JOIN f_purchase_order ON 1=1
  ),
  _source_changed_to_mandatory_1 AS (
SELECT
  CAST(NULL AS STRING) AS `576`
FROM string
  ),
  _source_changed_to_mandatory_2 AS (
SELECT
  CAST(NULL AS STRING) AS `620`,
  CAST(NULL AS STRING) AS `658`
FROM double
  ),
  _transformed AS (
  SELECT
    `408` AS `408`,
    `409` AS `409`,
    `410` AS `410`,
    `421` AS `421`,
    `446` AS `446`,
    `567` AS `567`,
    `577` AS `577`,
    `578` AS `578`,
    `579` AS `579`,
    `599` AS `599`,
    `600` AS `600`,
    `636` AS `636`,
    `654` AS `654`,
    `656` AS `656`,
    `668` AS `668`,
    `576` AS `576`,
    `620` AS `620`,
    `658` AS `658`
  FROM _source_changed_to_mandatory_2
  )
SELECT * FROM _transformed
),
definition_update_transformation as (
-- Query: Definition update_transformation
-- Purpose: Transform and load data into 'Definition update'
-- Query Type: SELECT

WITH
  _source_definition_update_0 AS (
SELECT
  double.base_qty AS `565`,
  double.dock_qty AS `586`,
  double.ext_prc_co_amt AS `590`,
  double.ext_prc_co_pmar_amt AS `591`,
  double.ext_prc_txn_amt AS `592`,
  double.ext_prc_txn_pmar_amt AS `593`,
  double.open_qty AS `617`,
  double.open_txn_amt AS `618`,
  double.open_txn_pmar_amt AS `619`,
  double.po_qty AS `642`,
  double.stk_unit_price AS `665`,
  double.stock_qty AS `666`,
  double.ttl_recpt_qty AS `673`,
  double.unit_prc_co_amt AS `677`,
  double.unit_prc_co_pmar_amt AS `678`,
  double.unit_prc_txn_amt AS `679`,
  double.unit_prc_txn_pmar_amt AS `680`
FROM double
  ),
  _source_definition_update_1 AS (
SELECT
  CAST(NULL AS STRING) AS `686`,
  CAST(NULL AS STRING) AS `765`
FROM double
  ),
  _transformed AS (
  SELECT
    `565` AS `565`,
    `586` AS `586`,
    `590` AS `590`,
    `591` AS `591`,
    `592` AS `592`,
    `593` AS `593`,
    `617` AS `617`,
    `618` AS `618`,
    `619` AS `619`,
    `642` AS `642`,
    `665` AS `665`,
    `666` AS `666`,
    `673` AS `673`,
    `677` AS `677`,
    `678` AS `678`,
    `679` AS `679`,
    `680` AS `680`,
    `686` AS `686`,
    `765` AS `765`
  FROM _source_definition_update_1
  )
SELECT * FROM _transformed
),
updated_field_name_transformation as (
-- Query: Updated Field Name_transformation
-- Purpose: Transform and load data into 'Updated Field Name'
-- Query Type: SELECT

WITH
  _source_updated_field_name_0 AS (
SELECT
  f_purchase_order.approval_dt_key AS `630`,
  f_purchase_order.complt_dt_key AS `631`,
  f_purchase_order.ship_to_city_nm AS `643`,
  f_purchase_order.ship_to_cntry_cd AS `644`,
  f_purchase_order.ship_to_entity_type_nm AS `645`,
  f_purchase_order.po_ship_to_name AS `646`
FROM f_purchase_order
  ),
  _transformed AS (
  SELECT
    `630` AS `630`,
    `631` AS `631`,
    `643` AS `643`,
    `644` AS `644`,
    `645` AS `645`,
    `646` AS `646`
  FROM _source_updated_field_name_0
  )
SELECT * FROM _transformed
)
SELECT * FROM changed_to_non_mandatory_transformation UNION ALL
SELECT * FROM change_desc_transformation UNION ALL
SELECT * FROM added_transformation UNION ALL
SELECT * FROM changed_to_mandatory_transformation UNION ALL
SELECT * FROM definition_update_transformation UNION ALL
SELECT * FROM updated_field_name_transformation