-- Query: populate_f_invoice
-- Purpose: Populate the f_invoice table with invoice details by joining ad_mstr, so_mstr, and inv_mstr.
-- Query Type: SELECT

SELECT 
  inv.inv_id AS invoice_key,
  inv.inv_amt AS invoice_amount
FROM 
  edp_raw.sap_hana.ad_mstr ad
  LEFT JOIN edp_raw.sap_hana.so_mstr so ON so.so_cust = ad.ad_addr
  LEFT JOIN edp_raw.sap_hana.inv_mstr inv ON inv.inv_order = so.so_nbr
WHERE 
  so.so_status = 'COMPLETED';