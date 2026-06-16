-- Query: populate_f_order
-- Purpose: Populate the f_order table with order details by joining ad_mstr, so_mstr, sod_det, and pt_mstr.
-- Query Type: SELECT

SELECT 
  so.so_nbr AS order_key,
  so.so_ord_date AS order_date,
  CONCAT('msd_qad_', LOWER(ad.ad_domain), '|', ad.ad_addr) AS customer_key,
  pt.pt_part AS product_key,
  sd.sod_price_tot AS order_amount,
  sd.sod_qty_ord AS quantity,
  sd.sod_disc AS discount_amount,
  sd.sod_tax AS tax_amount
FROM 
  edp_raw.sap_hana.ad_mstr ad
  LEFT JOIN edp_raw.sap_hana.so_mstr so ON so.so_cust = ad.ad_addr
  LEFT JOIN edp_raw.sap_hana.sod_det sd ON sd.sod_nbr = so.so_nbr
  LEFT JOIN edp_raw.sap_hana.pt_mstr pt ON pt.pt_domain = ad.ad_domain
WHERE 
  so.so_status = 'COMPLETED';