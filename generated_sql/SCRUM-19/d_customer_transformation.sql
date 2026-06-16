-- Query: d_customer_transformation
-- Purpose: Transform and load data into the d_customer dimension table.
-- Query Type: SELECT

-- Databricks SQL Notebook: d_customer Transformation
-- Purpose: Transform and load data into the d_customer dimension table.

WITH ad_mstr_cte AS (
    SELECT
        ad.ad_domain,
        ad.ad_addr,
        ad.ad_name,
        ad.ad_type,
        ad.ad_country,
        ad.ad_status
    FROM edp_raw.sap_hana.ad_mstr ad
),
region_map_cte AS (
    SELECT
        ad.ad_country,
        CASE
            WHEN ad.ad_country IN ('US', 'CA') THEN 'North America'
            WHEN ad.ad_country IN ('FR', 'DE') THEN 'Europe'
            ELSE 'Other'
        END AS customer_region
    FROM ad_mstr_cte ad
)
SELECT
    CONCAT('msd_qad_', LOWER(ad.ad_domain), '|', ad.ad_addr) AS cust_key,
    CAST(ad.ad_name AS STRING) AS customer_name,
    CAST(ad.ad_type AS STRING) AS customer_type,
    CAST(ad.ad_country AS STRING) AS customer_country,
    CAST(rm.customer_region AS STRING) AS customer_region,
    CAST(ad.ad_status AS STRING) AS customer_status
FROM ad_mstr_cte ad
LEFT JOIN region_map_cte rm
    ON ad.ad_country = rm.ad_country;