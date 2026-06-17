-- Query: d_product_plant_transformation
-- Purpose: Transform and load data into d_product_plant
-- Query Type: SELECT

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
FROM some_leading_table
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
WHERE sap_dim_product_plant.src_sys_cd IS NOT NULL
  AND sap_dim_product_plant.CPRODUCT_ID IS NOT NULL
  AND sap_dim_product_plant.CSUPPLY_PLANNING_AREA IS NOT NULL
  ),
  _source_d_product_plant_4 AS (
SELECT
  sap_dim_master.KCVALPCOMP AS std_cost_amt
FROM sap_dim_master
INNER JOIN sap_dim_product_plant
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
SELECT * FROM _transformed;