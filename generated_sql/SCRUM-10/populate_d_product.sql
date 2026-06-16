-- Query: populate_d_product
-- Purpose: Populate the d_product table with product details from pt_mstr.
-- Query Type: SELECT

SELECT 
  pt.pt_part AS product_key,
  pt.pt_desc1 AS product_name,
  pt.pt_prod_line AS product_category,
  pt.pt_brand AS product_brand
FROM 
  edp_raw.sap_hana.pt_mstr pt;