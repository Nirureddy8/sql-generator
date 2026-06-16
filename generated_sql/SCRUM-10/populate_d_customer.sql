-- Query: populate_d_customer
-- Purpose: Populate the d_customer table with customer details from ad_mstr.
-- Query Type: SELECT

SELECT 
  CONCAT('msd_qad_', LOWER(ad.ad_domain), '|', ad.ad_addr) AS cust_key,
  ad.ad_name AS customer_name,
  ad.ad_type AS customer_type,
  ad.ad_country AS customer_country,
  CASE 
    WHEN ad.ad_country IN ('US', 'CA') THEN 'North America'
    WHEN ad.ad_country IN ('FR', 'DE') THEN 'Europe'
    ELSE 'Other'
  END AS customer_region,
  ad.ad_status AS customer_status
FROM 
  edp_raw.sap_hana.ad_mstr ad
WHERE 
  ad.ad_type IN ('B2B', 'B2C')
  AND ad.ad_status IN ('ACTIVE', 'INACTIVE');