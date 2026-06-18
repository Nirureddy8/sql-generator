-- ============================================================
-- Query     : d_buyer_transformation
-- Table Type: DIMENSION
-- Purpose   : Loads the buyer dimension table with relevant attributes from SAP source.
-- ============================================================
WITH
  _source AS (
    SELECT
      sap_dim_buyer.cee_id AS buyer_cd,
      sap_dim_buyer.tee_id AS buyer_nm,
      'byd_brsbn' AS src_sys_cd
    FROM catalog.schema.sap_dim_buyer sap_dim_buyer
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT
      CAST(NULL AS STRING) AS id, -- TODO: review, id column missing in source
      buyer_cd,
      buyer_nm,
      src_sys_cd
    FROM   _scd
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;

======================================================================

-- ============================================================
-- Query     : d_product_transformation
-- Table Type: DIMENSION
-- Purpose   : Transformation logic for the d_product dimension table
-- ============================================================
WITH
  _source AS (
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
      sap.Cs1ANs6BA9E26842229D1 AS mtl_type_cd,
      sap.Ts1ANs6BA9E26842229D1 AS mtl_type_nm,
      sap.CPROD_CATG_UUID_01 AS item_cat_grp_cd,
      sap.TPROD_CATG_UUID_01 AS item_cat_grp_nm,
      sap.CPROD_CATG_UUID_01 AS mtl_grp_cd,
      sap.TPROD_CATG_UUID_01 AS mtl_grp_nm,
      CAST(NULL AS decimal(26,6)) AS adj_unit_mult_nbr,
      CAST(NULL AS string) AS alt_sku,
      CAST(NULL AS string) AS alt_uom_cd,
      CAST(NULL AS string) AS alt_uom_nm,
      CAST(NULL AS string) AS auth_grp,
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
    WHERE sap.CMATR_INT_ID IS NOT NULL AND sap.sku IS NOT NULL AND sap.src_sys_cd IS NOT NULL
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT adj_unit_mult_nbr,
           alt_sku,
           alt_uom_cd,
           alt_uom_nm,
           auth_grp,
           base_uom_cd,
           base_uom_nm,
           CAST(NULL AS STRING) AS batch_mgmt_flg, -- TODO: review logic
           CAST(NULL AS STRING) AS bus_area_cd,    -- TODO: review logic
           CAST(NULL AS STRING) AS bus_area_nm,    -- TODO: review logic
           CAST(NULL AS STRING) AS cas_reg_nbr,    -- TODO: review logic
           CAST(NULL AS STRING) AS client_lvl_del_flg, -- TODO: review logic
           gross_wgt,
           height,
           width,
           vol,
           vol_uom_cd,
           vol_uom_nm,
           ttl_shelf_life_days,
           sku,
           sku_nm,
           src_sys_cd
    FROM   _scd
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;


======================================================================

-- ============================================================
-- Query     : d_gl_acct_transformation
-- Table Type: DIMENSION
-- Purpose   : Transformation logic for the General Ledger Account dimension table.
-- ============================================================
WITH
  _source AS (
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
    FROM catalog.schema.dim_gl_acct dga
    LEFT JOIN catalog.schema.sap_dim_gl_acct sga ON dga.cglacct = sga.cglacct
    WHERE dga.cglacct IS NOT NULL AND dga.ccompany_uuid IS NOT NULL
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT
      co_cd,
      co_nm,
      coa_id,
      cost_center_branch_cd,
      cost_center_branch_nm,
      curncy_cd,
      curncy_nm,
      dtl_lvl_nbr,
      gl_acct_id,
      gl_acct_nm,
      object_acct_cd,
      object_acct_cost_type_cd,
      object_acct_subsdry_nm,
      object_acct_type_cd,
      src_sys_cd,
      subsdry_cd
    FROM   _scd
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;

======================================================================

-- ============================================================
-- Query     : d_company_transformation
-- Table Type: DIMENSION
-- Purpose   : Dimension table for company details, enriched with ERP and default values
-- ============================================================
WITH
  _source AS (
    SELECT
      sap_site.ccity_name AS city_nm,
      sap_co.ccntry_code AS cntry_cd,
      sap_co.tcntry_code AS cntry_nm,
      sap_co.cco_id AS co_cd,
      'AUD' AS co_curncy_cd,
      'Australian Dollar' AS co_curncy_nm,
      sap_co.tco_id AS co_nm,
      CAST(NULL AS string) AS gbl_rgn_cd,
      CAST(NULL AS string) AS gbl_rgn_nm,
      CASE WHEN sap_co.bukrs IN ('0070', '5000', '1800', '1220', '1000', '0040', '2070', '2000', '2010', '1900', '1530', '1287', '1310', '1030', '1200', '1600', '2030', '0020', '0010', '0110', '2930', '3000', '1520', '1710', '1120', '1150', '2010', '2080', '2040', '1170', '2900', '2090') OR sap_co.bukrs BETWEEN '1400' AND '1480' THEN 'AIG' ELSE 'NON_AIG' END AS group_nm,
      'PSBIOLC' AS hfm_entity_cd,
      CAST(NULL AS string) AS lang_cd,
      CAST(NULL AS string) AS lang_iso_cd,
      CAST(NULL AS string) AS lang_nm,
      CAST(NULL AS string) AS rgn_cd,
      CAST(NULL AS string) AS rgn_nm,
      'byd_brsbn' AS src_sys_cd,
      CAST(NULL AS string) AS st_prov_cd,
      CAST(NULL AS string) AS st_prov_nm
    FROM catalog.schema.sap_dim_company sap_co
    LEFT JOIN catalog.schema.sap_dim_org_unit_site sap_site ON sap_site.cparty_id = 4192
    WHERE sap_co.cco_id IS NOT NULL AND sap_co.ccntry_code IS NOT NULL AND sap_co.tcntry_code IS NOT NULL
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT city_nm,
           cntry_cd,
           cntry_nm,
           co_cd,
           co_curncy_cd,
           co_curncy_nm,
           co_nm,
           gbl_rgn_cd,
           gbl_rgn_nm,
           group_nm,
           hfm_entity_cd,
           lang_cd,
           lang_iso_cd,
           lang_nm,
           rgn_cd,
           rgn_nm,
           src_sys_cd,
           st_prov_cd,
           st_prov_nm
    FROM   _scd
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;

======================================================================

-- ============================================================
-- Query     : d_org_unit_transformation
-- Table Type: DIMENSION
-- Purpose   : Transformation logic for organizational unit dimension
-- ============================================================
WITH
  _source AS (
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
    FROM catalog.schema.sap_dim_org_unit_site sap
    WHERE sap.CPARTY_ID IS NOT NULL AND sap.TPARTY_ID IS NOT NULL AND sap.cregion_code IS NOT NULL AND sap.cst_name IS NOT NULL
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY {bk_cols} ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT
      city_nm,
      cntry_cd,
      cntry_nm,
      co_cd,
      co_curncy_cd,
      co_curncy_nm,
      co_nm,
      curncy_cd,
      curncy_nm,
      gbl_rgn_cd,
      gbl_rgn_nm,
      lang_cd,
      lang_iso_cd,
      lang_nm,
      org_unit_cat_nm,
      org_unit_cd,
      org_unit_nm,
      org_unit_type,
      parent_org_unit_cd,
      parent_org_unit_nm,
      rgn_cd,
      rgn_nm,
      src_sys_cd,
      st_prov_cd,
      st_prov_nm,
      street_nm
    FROM   _scd
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;


======================================================================

-- =============================
/**************************************************************************
Artefact Name :- d_product_plant SQL
Description  :- Transformation logic for the d_product_plant dimension table
**************************************************************************/

-- Query: d_product_plant_transformation
-- Pattern: dimension_flat
-- Coverage: 192 rows

SELECT
  plant.CSUPPLY_PLANNING_AREA AS plant_cd,
  plant.TSUPPLY_PLANNING_AREA AS plant_nm,
  plant.CPRODUCT_ID AS sku,
  master.CMATR_INT_ID AS sku_nm,
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
  (CASE WHEN plant.CSUPPLY_PLANNING_AREA IS NULL THEN 'N' ELSE 'Y' END) AS batch_mgmt_flg,
  'byd_brsbn' AS src_sys_cd,
  sap_dim_product_plant.CSUPPLY_PLANNING_AREA AS site_cd,
  '2952' AS profit_center_cd,
  'Large Molecule BIO' AS profit_center_nm,
  sap_dim_master.KCVALPCOMP AS std_cost_amt,
  (CASE WHEN sap_dim_product_plant.insmk IS NULL OR sap_dim_product_plant.insmk = '' THEN 'N' ELSE 'Y' END) AS post_to_inspn_stk_flg,
  (CASE WHEN sap_dim_product_plant.sauft IS NULL OR sap_dim_product_plant.sauft = ' ' THEN 'N' ELSE 'Y' END) AS rept_mfg_flg,
  (CASE WHEN sap_dim_product_plant.kordb IS NULL OR sap_dim_product_plant.kordb = ' ' THEN 'N' ELSE 'Y' END) AS src_list_req_flg,
  (CASE WHEN sap_dim_product_plant.ueetk IS NULL OR sap_dim_product_plant.ueetk = ' ' THEN 'N' ELSE 'Y' END) AS unlmted_over_delvr_flg,
  (CASE WHEN sap_dim_product_plant.verkz IS NULL OR sap_dim_product_plant.verkz = '' THEN 'N' ELSE 'Y' END) AS ver_flg
FROM sap_dim_product_plant plant
LEFT JOIN sap_dim_master master ON plant.CPRODUCT_ID = master.CMATR_INT_ID
LEFT JOIN sap_dim_master sap_dim_master ON sap_dim_product_plant.CPRODUCT_ID = sap_dim_master.CMATR_INT_ID AND sap_dim_product_plant.CSUPPLY_PLANNING_AREA <> '5192'
WHERE plant.CSUPPLY_PLANNING_AREA <> '5192'

======================================================================

-- ============================================================
-- Query     : f_purchase_order_transformation
-- Table Type: FACT
-- Purpose   : Fact table for purchase orders with deduplication logic and data transformation.
-- ============================================================
WITH
  _source AS (
    -- =============================
    /**************************************************************************
    Artefact Name :- f_purchase_order SQL
    Description  :- Fact table for purchase orders, combining current and historical data with deduplication logic.
    Description  :- Transform and deduplicate purchase order data from SAP and history sources
    ***************************************************************************/

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
    LEFT JOIN sap_dim_supplier_payment_data dim_supplier_payment_data ON TRIM(UPPER(fct_purchase_order.CSELLER)) = TRIM(UPPER(dim_supplier_payment_data.CBP_UUID))
    LEFT JOIN sap_dim_org_unit_site dim_org_unit_site ON fct_purchase_order.CRECEIVING_SITE = dim_org_unit_site.CPARTY_ID
    LEFT JOIN sap_dim_product_1 dim_product ON fct_purchase_order.CPRD_UUID = dim_product.CMATR_INT_ID
    LEFT JOIN d_date d_dt ON CAST(DATE_FORMAT(fct_purchase_order.CITM_CREAT_DATE, 'yyyyMMdd') AS STRING) = CAST(d_dt.dt_key AS STRING)
    LEFT JOIN (SELECT kcvalpcomp, cmatr_int_id, ROW_NUMBER() OVER (PARTITION BY cmatr_int_id ORDER BY csupplier_id ASC) AS rank FROM dim_master WHERE TRIM(UPPER(dim_master.csupply_planning_area)) != '5192') dim_master ON TRIM(UPPER(dim_product.CMATR_INT_ID)) = TRIM(UPPER(dim_master.cmatr_int_id)) AND dim_master.rank = 1
    WHERE fct_purchase_order.CPO_ID IS NOT NULL AND fct_purchase_order.CITM_ID IS NOT NULL AND fct_purchase_order.src_sys_cd IS NOT NULL AND fct_purchase_order.po_nbr IS NOT NULL AND fct_purchase_order.po_line_nbr IS NOT NULL AND fct_purchase_order.po_type_cd IS NOT NULL AND fct_purchase_order.acct_seq_nbr IS NOT NULL AND fct_purchase_order.co_cd IS NOT NULL
  ),
  _deduped AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT acct_seq_nbr,
           CAST(NULL AS decimal(38,6)) AS base_open_qty,
           CAST(NULL AS double) AS base_qty,
           CAST(NULL AS string) AS base_uom,
           CAST(NULL AS string) AS base_uom_text,
           CAST(NULL AS string) AS blkt_cd,
           CAST(NULL AS string) AS business_unit,
           CAST(NULL AS string) AS buyer_cd,
           CAST(NULL AS string) AS buyer_name,
           CAST(NULL AS string) AS co_cd,
           CAST(NULL AS string) AS co_curncy_cd,
           CAST(NULL AS string) AS co_name -- Add remaining fields per field_list
    FROM   _deduped
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;

======================================================================

-- ============================================================
-- Query     : d_supplier_transformation
-- Table Type: DIMENSION
-- Purpose   : Dimension table for supplier data with mappings from SAP source tables
-- ============================================================
WITH
  _source AS (
    SELECT
      (CASE WHEN dim_master.erdat = '00000000' THEN CAST(NULL AS TIMESTAMP) ELSE CAST(TO_DATE(dim_master.erdat, 'yyyyMMdd') AS TIMESTAMP) END) AS addr_crt_dt,
      dim_supplier.CGLO_TRADE_NAME AS alt_suplr_id,
      CAST(NULL AS STRING) AS cmdty_mgr_nm,
      CAST(NULL AS TIMESTAMP) AS contract_begin_dt,
      CAST(NULL AS STRING) AS contract_comment_txt,
      CAST(NULL AS TIMESTAMP) AS contract_end_dt,
      CAST(NULL AS STRING) AS contract_id,
      CAST(NULL AS STRING) AS contract_stat_cd,
      CAST(NULL AS STRING) AS contract_type_nm,
      COALESCE(dim_supplier.KRAUS, NULL) AS dnb_co_nbr,
      CAST(NULL AS STRING) AS frt_terms_cd,
      CAST(NULL AS STRING) AS frt_terms_nm,
      dim_supplier.CINCTM_CODE AS inco_terms_cd,
      dim_supplier.TINCTM_CODE AS inco_terms_nm,
      dim_supplier.CLEI_ID AS lgl_suplr_nm,
      CAST(NULL AS DECIMAL(38,6)) AS mthly_projctd_saving_amt,
      CAST(NULL AS DECIMAL(38,6)) AS mthly_projctd_spend_amt,
      CAST(NULL AS STRING) AS norm_supplier_type,
      CAST(NULL AS STRING) AS parent_suplr_nm,
      dim_supplier.CCSH_DSCNT_TRM AS paymt_terms_cd,
      dim_supplier.TCSH_DSCNT_TRM AS paymt_terms_nm,
      CAST(NULL AS STRING) AS prim_branch_cd,
      CAST(NULL AS STRING) AS prim_branch_nm,
      'byd_brsbn' AS src_sys_cd,
      CAST(NULL AS STRING) AS status_cd,
      CASE WHEN LOWER(TRIM(dim_supplier.cpur_block_ind)) = 'active' THEN 'N' ELSE 'Y' END AS suplr_active_flg,
      dim_supplier.CFRMTD_PSTL_ADDR AS suplr_addr_line_1,
      CAST(NULL AS STRING) AS suplr_addr_line_2,
      CAST(NULL AS STRING) AS suplr_addr_line_3,
      CAST(NULL AS STRING) AS suplr_addr_line_4,
      CAST(NULL AS STRING) AS suplr_assgn_grp_cd,
      CAST(NULL AS STRING) AS suplr_assgn_grp_nm,
      COALESCE(dim_supplier.CCITY_NAME, 'Unknown') AS suplr_city_nm,
      CAST(NULL AS STRING) AS suplr_class_cd,
      CAST(NULL AS STRING) AS suplr_class_nm,
      COALESCE(dim_supplier.CCOUNTRY_CODE, NULL) AS suplr_cntry_cd,
      dim_supplier.TCOUNTRY_CODE AS suplr_cntry_nm,
      CAST(NULL AS STRING) AS cust_svc_email_txt,
      CAST(NULL AS STRING) AS cust_svc_contact_nm,
      CAST(NULL AS STRING) AS cust_svc_phn_area_cd,
      CAST(NULL AS STRING) AS cust_svc_phn_nbr,
      CAST(NULL AS STRING) AS suplr_dvrsty_cd,
      CAST(NULL AS STRING) AS suplr_dvrsty_nm,
      dim_supplier.CEMAIL_URI AS suplr_email_addr,
      COALESCE(dim_supplier.CBP_UUID, NULL) AS suplr_id,
      COALESCE(dim_supplier.BRSCH, NULL) AS suplr_indy_cd,
      CAST(NULL AS STRING) AS suplr_indy_nm,
      COALESCE(dim_supplier.spras, NULL) AS suplr_lang_cd,
      CAST(NULL AS STRING) AS suplr_lang_nm,
      dim_supplier.TBP_UUID AS suplr_nm,
      payment_data.TPAYMENT_METHOD AS paymt_type_cd,
      dim_supplier.CPHONE_NR AS suplr_phn_nbr,
      COALESCE(dim_supplier.CSTREET_POSTAL, NULL) AS suplr_pstl_cd,
      dim_supplier.CCREATION_DT AS src_crt_ts,
      dim_supplier.CCHANGE_DT AS src_updt_ts,
      CAST(NULL AS STRING) AS suplr_rel_cd,
      CAST(NULL AS STRING) AS suplr_rgn_cd,
      CAST(NULL AS STRING) AS suplr_rgn_nm,
      CAST(NULL AS STRING) AS suplr_ship_mode_cd,
      dim_supplier.CREGION_CODE AS suplr_st_cd,
      dim_supplier.TREGION_CODE AS suplr_st_nm,
      dim_supplier.CTAX_ID_NR AS suplr_tax_id,
      CASE WHEN payment_data.TACCT_DET_CREDITOR_GROUP_CODE IN ('Domestic, third party', 'Foreign, third party') THEN '3rd party supplier' WHEN payment_data.TACCT_DET_CREDITOR_GROUP_CODE IN ('Inside/Outside BG, affiliated', 'Inside BG, affiliated', 'Employees') THEN 'IC supplier' ELSE NULL END AS suplr_type_cd,
      CAST(NULL AS STRING) AS suplr_type_nm
    FROM sap_dim_supplier dim_supplier
    LEFT JOIN sap_dim_master dim_master ON dim_supplier.CBP_UUID = dim_master.CBP_UUID
    LEFT JOIN sap_dim_supplier_payment_data payment_data ON dim_supplier.CBP_UUID = payment_data.CBP_UUID
    WHERE dim_supplier.CBP_UUID IS NOT NULL
  ),
  _scd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY suplr_id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT addr_crt_dt,
           alt_suplr_id,
           cmdty_mgr_nm,
           contract_begin_dt,
           contract_comment_txt,
           contract_end_dt,
           contract_id,
           contract_stat_cd,
           contract_type_nm,
           dnb_co_nbr,
           frt_terms_cd,
           frt_terms_nm,
           inco_terms_cd,
           inco_terms_nm,
           lgl_suplr_nm,
           mthly_projctd_saving_amt,
           mthly_projctd_spend_amt,
           norm_supplier_type,
           parent_suplr_nm,
           paymt_terms_cd,
           paymt_terms_nm,
           prim_branch_cd,
           prim_branch_nm,
           src_sys_cd,
           status_cd,
           suplr_active_flg,
           suplr_addr_line_1,
           suplr_addr_line_2,
           suplr_addr_line_3,
           suplr_addr_line_4,
           suplr_assgn_grp_cd,
           suplr_assgn_grp_nm,
           suplr_city_nm,
           suplr_class_cd,
           suplr_class_nm,
           suplr_cntry_cd,
           suplr_cntry_nm,
           cust_svc_email_txt,
           cust_svc_contact_nm,
           cust_svc_phn_area_cd,
           cust_svc_phn_nbr,
           suplr_dvrsty_cd,
           suplr_dvrsty_nm,
           suplr_email_addr,
           suplr_id,
           suplr_indy_cd,
           suplr_indy_nm,
           suplr_lang_cd,
           suplr_lang_nm,
           suplr_nm,
           paymt_type_cd,
           suplr_phn_nbr,
           suplr_pstl_cd,
           src_crt_ts,
           src_updt_ts,
           suplr_rel_cd,
           suplr_rgn_cd,
           suplr_rgn_nm,
           suplr_ship_mode_cd,
           suplr_st_cd,
           suplr_st_nm,
           suplr_tax_id,
           suplr_type_cd,
           suplr_type_nm
    FROM   _scd
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;


======================================================================

-- ============================================================
-- Query     : f_po_recpt_txn_transformation
-- Table Type: UNKNOWN
-- Purpose   : Transformation logic for the f_po_recpt_txn table
-- ============================================================
WITH
  _source AS (
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
    FROM catalog.schema.sap_fct_po_receipt sap
    WHERE sap.txn_nbr IS NOT NULL
  ),
  _transformed AS (
    SELECT
      po_recpt_txn_key,
      src_sys_cd,
      txn_nbr,
      txn_line_nbr,
      dw_src_key,
      div_cd,
      po_recpt_key,
      recpt_nbr,
      recpt_line_seq_nbr,
      po_nbr,
      po_line_nbr,
      po_line_type_cd,
      acct_seq_nbr,
      match_type_cd,
      recpt_yr_nbr,
      co_key,
      co_cd,
      prod_key,
      sku,
      plant_cd,
      plant_key,
      prod_plant_key,
      suplr_key,
      suplr_cd,
      suplr_lot_nbr,
      erp_lot_nbr,
      coo_cd,
      coo_nm,
      txn_uom_cd,
      txn_uom_nm,
      txn_qty,
      txn_type_cd,
      src_crt_by,
      src_crt_ts,
      src_updt_by,
      src_updt_ts,
      rec_crt_ts,
      rec_updt_ts
    FROM _source
  )
SELECT * FROM _transformed;


======================================================================

-- ============================================================
-- Query     : f_supplier_invoice_transformation
-- Table Type: FACT
-- Purpose   : Fact table for supplier invoices, combining current and historical data with deduplication logic.
-- ============================================================
WITH
  _source AS (
    -- =============================
/**************************************************************************
Artefact Name :- f_supplier_invoice SQL
Description  :- Fact table for supplier invoices, combining current and historical data with deduplication logic.
**************************************************************************/

-- Query: f_supplier_invoice_transformation
-- Pattern: fact_union_dedup
-- Coverage: 105 rows

WITH
supplier_invoice_union AS (
  SELECT
    *
  FROM sap_fct_supplier_invoice current
  UNION ALL
  SELECT
    *
  FROM fct_purchase_order_history history
),
supplier_invoice_dedup AS (
  SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY CINVOICE_UUID, CITEM_ID ORDER BY CTRANSACT_DATE DESC) AS rn FROM supplier_invoice_union) x WHERE rn = 1
)

SELECT
  'byd_brsbn' AS src_sys_cd,
  fct_supplier_invoice.CINVOICE_UUID AS vchr_nbr,
  fct_supplier_invoice.CITEM_ID AS vchr_line_nbr,
  fct_supplier_invoice.CREF_PO AS po_nbr,
  fct_supplier_invoice.CREF_PO_ITEM AS po_line_nbr,
  fct_supplier_invoice.CINVOICE_YEAR AS fscl_yr_nbr,
  fct_supplier_invoice.CBUYER AS co_cd,
  fct_supplier_invoice.CTRANSACT_DATE AS actual_payment_dt,
  fct_supplier_invoice.CCASHDIS_TERMSCD AS ap_payment_term_cd,
  fct_supplier_invoice.TCASHDIS_TERMSCD AS ap_payment_term_desc
FROM supplier_invoice_dedup fct_supplier_invoice
LEFT JOIN dim_product_1 ON TRIM(UPPER(fct_supplier_invoice.cprd_uuid)) = TRIM(UPPER(dim_product_1.cmatr_int_id)) AND TRIM(UPPER(fct_supplier_invoice.creceiving_site)) = TRIM(UPPER(dim_product_1.csite_id))
LEFT OUTER JOIN edp_lkup ON edp_lkup.lkup_key_02 = fct_supplier_invoice.cbuyer AND UPPER(edp_lkup.lkup_typ_nm) = 'TFS_CO_CD_TO_DIV_CD_BU' AND LOWER(edp_lkup.lkup_key_01) = 'byd_brsbn'
WHERE fct_supplier_invoice.CSELLER IS NOT NULL
  ),
  _deduped AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY CINVOICE_UUID, CITEM_ID ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT 
      CAST(NULL AS STRING) as actual_payment_dt,
      CAST(NULL AS STRING) as ap_payment_term_cd,
      CAST(NULL AS STRING) as ap_payment_term_desc,
      CAST(NULL AS STRING) as aprval_dt,
      CAST(NULL AS DOUBLE) as base_qty,
      CAST(NULL AS STRING) as base_uom_cd,
      CAST(NULL AS STRING) as business_unit,
      CAST(NULL AS STRING) as buyer_cd,
      CAST(NULL AS STRING) as buyer_name,
      co_cd,
      CAST(NULL AS STRING) as co_curncy_cd,
      CAST(NULL AS DOUBLE) as co_curncy_mth_rt,
      CAST(NULL AS STRING) as co_name,
      CAST(NULL AS STRING) as contract_end_date,
      CAST(NULL AS STRING) as contract_flag,
      CAST(NULL AS STRING) as contract_start_date,
      CAST(NULL AS STRING) as contract_type,
      CAST(NULL AS STRING) as cost_centre_cd,
      CAST(NULL AS STRING) as cost_centre_nm,
      CAST(NULL AS STRING) as div_cd,
      CAST(NULL AS STRING) as document_type,
      CAST(NULL AS STRING) as erp_commondity_cd,
      CAST(NULL AS STRING) as erp_commondity_nm,
      CAST(NULL AS BIGINT) as fk_orig,
      CAST(NULL AS STRING) as floor_stock_cd,
      fscl_yr_nbr,
      CAST(NULL AS STRING) as gl_acct_id,
      CAST(NULL AS STRING) as gl_acct_nm,
      CAST(NULL AS STRING) as hfm_entity,
      CAST(NULL AS STRING) as inv_flg,
      CAST(NULL AS STRING) as inv_line_desc,
      CAST(NULL AS STRING) as invc_apprv_id,
      CAST(NULL AS DOUBLE) as invc_co_amt,
      CAST(NULL AS DOUBLE) as invc_co_pmar_amt,
      CAST(NULL AS STRING) as invc_entry_dt,
      CAST(NULL AS STRING) as invc_entry_period,
      CAST(NULL AS STRING) as invc_post_dt,
      CAST(NULL AS DOUBLE) as invc_qty,
      CAST(NULL AS STRING) as invc_receipt_dt,
      CAST(NULL AS DOUBLE) as invc_txn_amt,
      CAST(NULL AS DOUBLE) as invc_txn_pmar_amt,
      CAST(NULL AS STRING) as invc_txn_type,
      CAST(NULL AS STRING) as invc_uom_cd,
      CAST(NULL AS STRING) as item_desc,
      CAST(NULL AS STRING) as item_nbr,
      CAST(NULL AS STRING) as lcr_flag,
      CAST(NULL AS STRING) as lcr_region,
      CAST(NULL AS STRING) as erp_cat_cd,
      CAST(NULL AS STRING) as erp_cat_nm,
      CAST(NULL AS STRING) as nature,
      CAST(NULL AS STRING) as part_rev_no,
      CAST(NULL AS STRING) as pass_through_field,
      CAST(NULL AS STRING) as pass_through_line,
      CAST(NULL AS STRING) as payment_compliance_flg,
      CAST(NULL AS STRING) as paymt_due_dt,
      CAST(NULL AS STRING) as po_curncy_cd,
      po_line_nbr,
      po_nbr,
      CAST(NULL AS STRING) as po_paymt_terms_cd,
      CAST(NULL AS STRING) as po_paymt_terms_desc,
      CAST(NULL AS STRING) as post_yr_mth_nbr,
      CAST(NULL AS STRING) as profit_cntr,
      CAST(NULL AS STRING) as remit_to_addr_line_1,
      CAST(NULL AS STRING) as remit_to_addr_line_2,
      CAST(NULL AS STRING) as remit_to_addr_line_3,
      CAST(NULL AS STRING) as remit_to_addr_line_4,
      CAST(NULL AS STRING) as remit_to_city_nm,
      CAST(NULL AS STRING) as remit_to_cntry_cd,
      CAST(NULL AS STRING) as remit_to_cntry_nm,
      CAST(NULL AS STRING) as remit_to_rgn_cd,
      CAST(NULL AS STRING) as remit_to_rgn_nm,
      CAST(NULL AS STRING) as remit_to_st_cd,
      CAST(NULL AS STRING) as reporting_site,
      CAST(NULL AS STRING) as rpt_flex1,
      CAST(NULL AS STRING) as sec_supp_cd,
      CAST(NULL AS STRING) as site_cd,
      CAST(NULL AS STRING) as site_name,
      CAST(NULL AS STRING) as spend_type_cd,
      src_sys_cd,
      CAST(NULL AS STRING) as suplr_invc_dt,
      CAST(NULL AS STRING) as suplr_invc_nbr,
      CAST(NULL AS STRING) as suplr_nm_src,
      CAST(NULL AS STRING) as suplr_paymt_terms_cd,
      CAST(NULL AS STRING) as suplr_paymt_terms_desc,
      CAST(NULL AS STRING) as supplier_cd,
      CAST(NULL AS STRING) as supplier_name,
      CAST(NULL AS STRING) as supplier_type_cd,
      CAST(NULL AS STRING) as thermo_item_nbr,
      CAST(NULL AS DOUBLE) as txn_curncy_mth_rt,
      CAST(NULL AS STRING) as txn_orig_id,
      CAST(NULL AS STRING) as txn_ref_nbr,
      CAST(NULL AS STRING) as unit,
      CAST(NULL AS DOUBLE) as unit_prc,
      CAST(NULL AS DOUBLE) as unit_prc_pmar_amt,
      CAST(NULL AS DOUBLE) as uom_conv_factor,
      vchr_line_nbr,
      vchr_nbr,
      CAST(NULL AS STRING) as vchr_status,
      CAST(NULL AS STRING) as vchr_type_cd,
      CAST(NULL AS STRING) as vchr_type_desc,
      CAST(NULL AS STRING) as vendor_mat_no,
      CAST(NULL AS STRING) as vomi_flag,
      CAST(NULL AS STRING) as warehouse,
      CAST(NULL AS STRING) as warehouse_nm,
      CAST(NULL AS STRING) as document_desc
  FROM   _deduped
  WHERE  _rn = 1
  )
SELECT * FROM _transformed;


======================================================================

-- ============================================================
-- Query     : f_po_receipt_transformation
-- Table Type: FACT
-- Purpose   : Fact table for purchase order receipts with deduplication logic
-- ============================================================
WITH
  _source AS (
    SELECT
      f_po_receipt.CBU_QNT_UNIT AS base_uom,
      IF(base_uom_desc.MSEHL = '', 'Unknown', base_uom_desc.MSEHL) AS base_uom_text,
      f_po_receipt.CBUYER AS business_unit,
      f_po_receipt.CEMPL_RESP AS buyer_id,
      f_po_receipt.TEMPL_RESP AS buyer_name,
      f_po_receipt.CBUYER AS co_cd,
      CASE WHEN t001.WAERS = 'RMB' THEN 'CNY' ELSE t001.WAERS END AS co_curncy_cd,
      f_po_receipt.TBUYER AS co_name,
      CAST(NULL AS string) AS contract_end_date,
      IF(ekko.BSTYP IN ('K', 'L'), 'Y', 'N') AS contract_flag,
      CAST(NULL AS string) AS contract_start_date,
      CASE WHEN ekko.BSTYP = 'K' THEN 'Contract' WHEN ekko.BSTYP = 'L' THEN 'Sched Agr' ELSE 'NA' END AS contract_type,
      CAST(NULL AS string) AS delvr_cmplt_flg,
      'DSD' AS div_cd,
      DATE_FORMAT(DATE_ADD(TO_DATE('1899-12-30'), CAST(f_po_receipt.KCDEL_ST_DT AS INT)), 'yyyyMMdd') AS dock_dt,
      f_po_receipt.CITM_DLV_EDDT AS due_dt,
      f_po_receipt.KCRC_DLVD_AMT AS ext_recpt_co_amt,
      f_po_receipt.KCDLVD_AMT AS ext_recpt_txn_amt,
      CAST(NULL AS string) AS fk_orig,
      CAST(NULL AS string) AS floor_stock_cd,
      'PSBIOLC' AS hfm_entity,
      CAST(NULL AS string) AS inv_loc,
      f_po_receipt.TPRD_UUID AS item_desc,
      f_po_receipt.CITEM_ID AS item_nbr,
      IF(lcr_lkup.lcr_flg IS NOT NULL, lcr_lkup.lcr_flg, 'N') AS lcr_flag,
      IF(lcr_lkup.lcr_reg IS NOT NULL, lcr_lkup.lcr_reg, 'NA') AS lcr_region,
      CAST(NULL AS string) AS match_typ_cd,
      CAST(NULL AS string) AS match_typ_desc,
      CASE WHEN EKBE.WAERS = 'RMB' THEN 'CNY' ELSE EKBE.WAERS END AS po_curncy_cd,
      CAST(f_po_receipt.CITEM_ID AS int) AS po_delivry_line_nbr,
      f_po_receipt.CREF_PO_ITEM_UUID AS po_line_nbr,
      CASE WHEN ekpo.pstyp = '0' THEN 'Standard' WHEN ekpo.pstyp = '1' THEN 'Blanket item' WHEN ekpo.pstyp = '2' THEN 'Consignment' WHEN ekpo.pstyp = '3' THEN 'Subcontracting' WHEN ekpo.pstyp = '4' THEN 'Material unknown' WHEN ekpo.pstyp = '5' THEN 'Third-party' WHEN ekpo.pstyp = '6' THEN 'Text' WHEN ekpo.pstyp = '7' THEN 'Stock transfer' WHEN ekpo.pstyp = '8' THEN 'Material group' WHEN ekpo.pstyp = '9' THEN 'Service' ELSE 'Unknown' END AS po_line_type_cd,
      f_po_receipt.CREF_PO_UUID AS po_nbr,
      COALESCE(lfb1.zterm, lfm1.zterm, ekko.zterm) AS po_paymt_terms_cd,
      CAST(NULL AS double) AS prod_cost,
      f_po_receipt.CBUYER AS profit_cntr,
      f_po_receipt.CITM_DLV_EDDT AS promise_dt,
      f_po_receipt.CNET_PRC_QTY_UNT AS purch_uom,
      IF(purch_uom_desc.MSEHL = '', 'Unknown', purch_uom_desc.MSEHL) AS purch_uom_text,
      CAST((CASE WHEN MSEG.SHKZG = 'H' THEN COALESCE(MSEG.MENGE, 0) * -1 ELSE COALESCE(MSEG.MENGE, 0) END) AS double) AS recpt_base_qty,
      f_po_receipt.KCRC_DLVD_AMT * (CAST(COALESCE(co_curr_mth.co_pmar_rt, 1) AS double)) AS recpt_co_pmar_amt,
      CASE WHEN EKBE.WAERS = 'RMB' THEN 'CNY' ELSE EKBE.WAERS END AS recpt_curncy_cd,
      f_po_receipt.CITM_DLV_EDDT AS recpt_date,
      CAST(SUBSTR(MKPF.BLDAT, 1, 6) AS string) AS recpt_date_period,
      f_po_receipt.CITEM_ID AS recpt_line_seq_nbr,
      f_po_receipt.CDELIVERY_UUID AS recpt_nbr,
      f_po_receipt.KCRC_DLVD_AMT * txn_curr_mth.txn_pmar_rt AS recpt_pmar_amt,
      CAST((CASE WHEN MSEG.SHKZG = 'H' THEN COALESCE(MSEG.ERFMG, 0) * -1 ELSE COALESCE(MSEG.ERFMG, 0) END) AS double) AS recpt_txn_qty,
      CAST(NULL AS string) AS recpt_type_cd,
      f_po_receipt.CDELIVERY_YEAR AS recpt_yr_nbr,
      CAST(NULL AS string) AS ref_recpt_line_seq_nbr,
      CAST(NULL AS string) AS ref_recpt_nbr,
      CAST(NULL AS string) AS ref_recpt_yr_nbr,
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
      CAST(NULL AS string) AS warehouse,
      CAST(NULL AS string) AS warehouse_nm
    FROM po_receipt_dedup f_po_receipt
    LEFT JOIN f_purchase_order ON f_po_receipt.CREF_PO_UUID = f_purchase_order.CPO_ID AND f_po_receipt.CREF_PO_ITEM_UUID = f_purchase_order.CITM_ID
    LEFT JOIN (SELECT curr_mnth.pmar_rt AS co_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd FROM d_curncy_mth_rt curr_mnth WHERE UPPER(to_curncy_cd) = 'USD') co_curr_mth ON co_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND co_curr_mth.from_curncy_cd = '?'
    LEFT JOIN (SELECT curr_mnth.pmar_rt AS txn_pmar_rt, curr_mnth.yr_mth_nbr, curr_mnth.from_curncy_cd, curr_mnth.to_curncy_cd FROM d_curncy_mth_rt curr_mnth WHERE TRIM(UPPER(to_curncy_cd)) = 'USD') txn_curr_mth ON txn_curr_mth.yr_mth_nbr = d_date.fscl_yr_prd_nbr AND TRIM(UPPER(txn_curr_mth.from_curncy_cd)) = '?'
    WHERE f_po_receipt.CDELIVERY_UUID IS NOT NULL AND f_po_receipt.CITEM_ID IS NOT NULL
  ),
  _deduped AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY CURRENT_TIMESTAMP DESC) AS _rn
    FROM   _source
  ),
  _transformed AS (
    SELECT
      base_uom,
      base_uom_text,
      business_unit,
      buyer_id,
      buyer_name,
      co_cd,
      co_curncy_cd,
      co_name,
      contract_end_date,
      contract_flag,
      contract_start_date,
      contract_type,
      delvr_cmplt_flg,
      div_cd,
      dock_dt,
      due_dt,
      ext_recpt_co_amt,
      ext_recpt_txn_amt,
      fk_orig,
      floor_stock_cd,
      hfm_entity,
      inv_loc,
      item_desc,
      item_nbr,
      lcr_flag,
      lcr_region,
      match_typ_cd,
      match_typ_desc,
      po_curncy_cd,
      po_delivry_line_nbr,
      po_line_nbr,
      po_line_type_cd,
      po_nbr,
      po_paymt_terms_cd,
      prod_cost,
      profit_cntr,
      promise_dt,
      purch_uom,
      purch_uom_text,
      recpt_base_qty,
      recpt_co_pmar_amt,
      recpt_curncy_cd,
      recpt_date,
      recpt_date_period,
      recpt_line_seq_nbr,
      recpt_nbr,
      recpt_pmar_amt,
      recpt_txn_qty,
      recpt_type_cd,
      recpt_yr_nbr,
      ref_recpt_line_seq_nbr,
      ref_recpt_nbr,
      ref_recpt_yr_nbr,
      site_cd,
      spend_type_cd,
      src_sys_cd,
      suplr_paymt_terms_cd,
      suplr_paymt_terms_desc,
      supplier_id,
      supplier_name,
      txn_date,
      txn_uom,
      txn_uom_text,
      vomi_flag,
      warehouse,
      warehouse_nm
    FROM   _deduped
    WHERE  _rn = 1
  )
SELECT * FROM _transformed;