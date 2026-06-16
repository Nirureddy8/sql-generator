-- Query: d_product_transformation
-- Purpose: Transform and load data into the d_product dimension table.
-- Query Type: SELECT

-- Databricks SQL Notebook: d_product Transformation
-- Purpose: Transform and load data into the d_product dimension table.

WITH pt_mstr_cte AS (
    SELECT
        pt.pt_part,
        pt.pt_desc1,
        pt.pt_prod_line,
        pt.pt_brand
    FROM edp_raw.sap_hana.pt_mstr pt
)
SELECT
    CAST(pt.pt_part AS STRING) AS product_key,
    CAST(pt.pt_desc1 AS STRING) AS product_name,
    CAST(pt.pt_prod_line AS STRING) AS product_category,
    CAST(pt.pt_brand AS STRING) AS product_brand
FROM pt_mstr_cte pt;