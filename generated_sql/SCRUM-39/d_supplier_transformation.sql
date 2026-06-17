-- Query: d_supplier_transformation
-- Purpose: Transform and load data into d_supplier
-- Query Type: SELECT

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
  sap_dim_supplier.CGLO_TRADE_NAME AS alt_suplr_id,
  sap_dim_supplier.CINCTM_CODE AS inco_terms_cd,
  sap_dim_supplier.TINCTM_CODE AS inco_terms_nm,
  sap_dim_supplier.CLEI_ID AS lgl_suplr_nm,
  sap_dim_supplier.CCSH_DSCNT_TRM AS paymt_terms_cd,
  sap_dim_supplier.TCSH_DSCNT_TRM AS paymt_terms_nm,
  CASE
    WHEN lower(trim(sap_dim_supplier.CPUR_BLOCK_IND)) = 'active' THEN 'N'
    ELSE 'Y'
  END AS suplr_active_flg,
  sap_dim_supplier.CFRMTD_PSTL_ADDR AS suplr_addr_line_1,
  CAST(NULL AS STRING) AS suplr_addr_line_2,
  CAST(NULL AS STRING) AS suplr_addr_line_3,
  CAST(NULL AS STRING) AS suplr_addr_line_4,
  sap_dim_supplier.CCITY_NAME AS suplr_city_nm,
  sap_dim_supplier.CCOUNTRY_CODE AS suplr_cntry_cd,
  sap_dim_supplier.TCOUNTRY_CODE AS suplr_cntry_nm,
  sap_dim_supplier.CEMAIL_URI AS suplr_email_addr,
  sap_dim_supplier.CBP_UUID AS suplr_id,
  sap_dim_supplier.TBP_UUID AS suplr_nm,
  sap_dim_supplier.CPHONE_NR AS suplr_phn_nbr,
  sap_dim_supplier.CSTREET_POSTAL AS suplr_pstl_cd,
  sap_dim_supplier.CCREATION_DT AS src_crt_ts,
  sap_dim_supplier.CCHANGE_DT AS src_updt_ts,
  sap_dim_supplier.CREGION_CODE AS suplr_st_cd,
  sap_dim_supplier.TREGION_CODE AS suplr_st_nm,
  sap_dim_supplier.CTAX_ID_NR AS suplr_tax_id
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
SELECT * FROM _transformed;